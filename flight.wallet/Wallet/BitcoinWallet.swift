//
//  BitcoinWallet.swift
//  flight.wallet
//
//  Created by Aleksey Bykhun on 28/10/2018.
//  Copyright © 2018 Aleksey Bykhun. All rights reserved.
//

import Foundation
import CoreBitcoin

extension BTCAddress: AbstractAddress {
    var isMainnet: Bool {
        return network == BTCNetwork.mainnet()
    }
    
    var type: Chain {
        return .Bitcoin
    }
    
    var body: String? {
        return string
    }
}

extension BTCTransactionInput: TransactionInput {
    var address: AbstractAddress? {
        return transactionOutput?.address
    }
    
    var amount: Double? {
        return transactionOutput?.amount
    }
    
    var text: String? {
        if let tx_id = previousTransactionID {
            return "\(tx_id):\(previousIndex)"
        } else {
            return nil
        }
    }
}

extension BTCTransactionOutput: TransactionOutput {
    var address: AbstractAddress? {
        guard let script = script else { return nil }
        
        print(script.string)
        
        
        if script.isPayToPublicKeyHashScript {
            let address = script.standardAddress
            print(address)
            
            let addressTestnet = BTCPublicKeyAddressTestnet(data: address?.data)
            print(addressTestnet)
            
            return addressTestnet
        } else if script.isPayToScriptHashScript {
            let address = script.standardAddress
            print(address)
            
            let addressTestnet = BTCScriptHashAddressTestnet(data: address?.data)
            print(addressTestnet)
            
            return addressTestnet
//
//            print(address)
//            print(script.scriptHashAddress)
//            print(script.standardAddress)
//
//
//            return address
        } else {
            let address = script.standardAddress
            
            return address
        }
    }
    
    var amount: Double? {
        return Double(value) / Double(BTCCoin)
    }
    
}

extension BTCTransaction: Transaction {
    func estimateAmount(ownerAddress: AbstractAddress) -> Double {
        guard let tx_outputs = tx_outputs else { return 0 }
        
        let myOutputs = tx_outputs
            .filter { output in output.address != nil && output.address! != ownerAddress }
        
        return myOutputs.reduce(0, { sum, output in sum + (output.amount ?? 0) })
        
        let change = estimateChange(ownerAddress: ownerAddress)
        
        guard let total = total else { fatalError("Transaction without amount") }
        
        let amount = total - change
        
        guard amount >= 0 else { fatalError("Transaction passing negative value, calculation error") }
        
        return amount
    }
    
    func estimateChange(ownerAddress: AbstractAddress) -> Double {
        guard let tx_outputs = tx_outputs else { return 0 }
        
        let myOutputs = tx_outputs
            .filter { output in output.address != nil && output.address! == ownerAddress }
        
        return myOutputs.reduce(0, { sum, output in sum + (output.amount ?? 0) })
    }
    
    func decode(rawhex: String) -> Transaction {
        return BTCTransaction(hex: rawhex)
    }
    
    convenience init?(from rawhex: String) {
        self.init(hex: rawhex)
    }
    
    var tx_inputs: [TransactionInput]? {
        
        guard let tx_inputs = inputs as? [BTCTransactionInput] else {
            return nil
        }
        
        return tx_inputs
        
    }
    
    var tx_outputs: [TransactionOutput]? {
        guard let tx_outputs = outputs as? [BTCTransactionOutput] else {
            return nil
        }
        
        return tx_outputs
    }
    
    var sender: String? {
        return tx_inputs?.map { i in i.text ?? "-" }.joined(separator: ", ")
    }
    
    var destination: String? {
        return tx_outputs?.map { o in o.address?.body ?? "-" }.joined(separator: ", ")
    }
    
    var amount: Double? {
        guard let tx_outputs = tx_outputs else {
            return nil
        }
        
        return tx_outputs.first?.amount
    }
    
    var total: Double? {
        return Double(outputsAmount) / Double(BTCCoin)
    }
    
    var fee: Double? {
        return 0
    }
    
    func encode() -> String {
        return hex
    }
    
    var type: Chain {
        return .Bitcoin
    }
    
    var body: String {
        return hex
    }
    
    var network: Network {
        return .Testnet
    }
}

func ==(lhs: BTCTransactionOutput, rhs: BTCTransactionOutput) -> Bool {
    return lhs.transactionID == rhs.transactionID
        && lhs.index == rhs.index
}

extension BTCTransaction: SignedTransaction {
    var unsigned: Transaction {
        return self
    }
    
    var signatures: [String] {
        guard let inputs = inputs as? [BTCTransactionInput] else {
            return []
        }
        
        return inputs.map { input in input.signatureScript.hex }
    }
}

//    unspent_output_schema = Schema({
//        'tx_hash': str,
//        'script': str,
//        'value': int,
//        'vout': int,
//        'height': int,
//        'confirmations': int
//    })

struct UTXOs: Codable {
    let list: [UTXO]
}

struct UTXO: Codable {
    let tx_hash: String
    let vout: Int
    let script: String
    let value: Int
    let height: Int
    let confirmations: Int
    
    init(_ output: BTCTransactionOutput) {
        value = Int(output.value)
        script = output.script.string
            
        tx_hash = output.transactionID
        vout = Int(output.index)
        
        height = output.blockHeight
        confirmations = Int(output.confirmations)
    }
    
    func toOutput() -> BTCTransactionOutput? {
        let script = BTCScript(hex: self.script)
        
        guard let output = BTCTransactionOutput(value: BTCAmount(value), script: script) else { return nil }
        
        output.transactionID = tx_hash
        output.index = UInt32(vout)
        
        output.blockHeight = height
        output.confirmations = UInt(confirmations)
        
        return output
    }
}

struct BitcoinWalletUpdate: WalletUpdateInfo {
    static let JSON = JSONDecoder()
    var type: Chain = .Bitcoin
    var forAddress: Address? = nil
    
    var isOverride: Bool = false
    var newUnspents: [BTCTransactionOutput] = []
    
    init?(from json: String) {
        let data = json.data(using: .utf8)!
        
        debug("json", data)
        
        let utxos = try! BitcoinWalletUpdate.JSON.decode([UTXO].self, from: data)
        
        print(utxos)
        
        newUnspents = utxos.map { utxo in
            return utxo.toOutput() ?? nil
        }.compactMap { utxo in utxo }
    }
}

class BitcoinWallet: CryptoWallet {
    var type = Chain.Bitcoin
    var addresses: [Address] = [
//        Address(network: .Testnet, type: .Bitcoin, path: "m/44/0/0/1", friendlyName: "Default Address", body: "1Pdasdasds")
    ]
    
    var keychain: BTCKeychain!
    var storage: BitcoinUnspentsStorage
    
    required init(from seed: Data) {
        keychain = BTCKeychain(seed: seed, network: .testnet())!
        storage = BitcoinUnspentsStorage()
    }
    
    func generateAddress(index: Int = 1, isMainnet: Bool = false) -> Address? {
        let path = "m/44'/0'/0/0/\(index)"
        
        guard let btcMainnetAddress = keychain.key(withPath: path)?.address else { return nil }
        
        guard let btcTestnetAddress = keychain.key(withPath: path)?.addressTestnet else { return nil }
            
        let addressString = isMainnet
            ? btcMainnetAddress.string
            : btcTestnetAddress.string
        
        let network: Network = isMainnet ? .Mainnet : .Testnet
        
        let address = Address(
            network: network,
            type: .Bitcoin,
            path: path,
            friendlyName: "Bitcoin \(isMainnet ? "Mainnet" : "Testnet")",
            body: addressString
        )
        
        return address
    }
    
    
    func loaded(completion: @escaping (Address?) -> ()) {
        let _addrs = [
            generateAddress(index: 1),
            generateAddress(index: 1, isMainnet: true),
        ]
        
        let addrs = _addrs.compactMap({ addr in addr })
        
        addresses += addrs
        
        completion(nil)
    }
    
    
    func sign(tx: Transaction) -> SignedTransaction? {
        if let (tx, _) = sign(tx: tx.body) {
            return tx
        } else {
            return nil
        }
    }
    
    func sign(tx rawhex: String) -> (BTCTransaction, [BTCScript])? {
        
        guard let unsigned_tx = BTCTransaction.init(hex: rawhex) else {
            return nil
        }
        
        guard let inputs = unsigned_tx.inputs as? [BTCTransactionInput] else {
            return nil
        }
        
        let path = "m/44'/0'/0/0/\(1)"
        
        guard let key = keychain.key(withPath: path) else {
            return nil
        }
        
        print(key.addressTestnet)
        
        var sigs: [BTCScript] = []
        
        for index in 0..<inputs.count {
            
            let sig = BTCScript()!
            
            let tx_input = inputs[index]
            
            let script = BTCScript(address: key.addressTestnet)
            
            script?.scriptHashAddressTestnet
            print("\n")
            print("script pub key", script!.string!)
            
            let hash = try! unsigned_tx.signatureHash(for: script, inputIndex: UInt32(index), hashType: .SIGHASH_ALL)
            
            print("\n")
            print("hash", BTCHexFromData(hash)!)
            
            let signatureForScript = key.signature(forHash: hash, hashType: .SIGHASH_ALL)!
            
            print("\n")
            print("signature", BTCHexFromData(signatureForScript)!)
            
            sig.appendData(signatureForScript)
            sig.appendData(key.publicKey! as Data)
            
            print("\n")
            print("sig", sig.string!)
            
            let range = Range(uncheckedBounds: (0, signatureForScript.count - 1))
            let signature = signatureForScript.subdata(in: range) // trim hashtype byte to check the signature.
            
            assert(key.isValidSignature(signature, hash: hash), "Signature must be valid")
            
            tx_input.signatureScript = sig
            
            sigs += [sig]
        }
        
        print("\n")
        print("sigs", sigs)
        
        print("signed raw hex", unsigned_tx.hex!)
        
        return (unsigned_tx, sigs)
    }
    
    func sign(tx: Transaction, address: Address) -> SignedTransaction? {
        return sign(tx: tx)
    }
    
    func decode(tx: Transaction) -> DecodedTransaction? {
        return nil
    }
    
    func decode(tx: String) -> Transaction? {
        return BTCTransaction(from: tx)
    }
    
    func sync(update: WalletUpdateInfo) -> Bool {
        guard update.type == .Bitcoin else { return false }
        
        let update = update as! BitcoinWalletUpdate
        
        print("addresses", update.newUnspents.map { output in output.address })
        
        return storage.update(newUnspents: update.newUnspents)
    }
    
    func buildTx(from: Address? = nil, to toAddress: AbstractAddress, value: Double) -> Transaction? {
        let fromAddress = from ?? generateAddress(index: 1)
        
        debug("paying from", fromAddress)
        
        guard fromAddress?.type == .Bitcoin else { return nil }
        guard toAddress.type == .Bitcoin else { return nil }
        
        let destinationAddress = BTCAddress(string: toAddress.body)
        let changeAddress = BTCAddress(string: fromAddress!.body)

        let tx = BTCTransaction()
        
        var spentCoins = BTCAmount(0)
        let amount = BTCAmount(value) * BTCCoin
        let fee = BTCAmount(5000)
        
        storage.outputs.forEach { output in
            let input = BTCTransactionInput()
            input.transactionOutput = output
            tx.addInput(input)
            spentCoins += output.value
        }
        
        let paymentOutput = BTCTransactionOutput(value: spentCoins, address: destinationAddress)
        let changeOutput = BTCTransactionOutput(value: (spentCoins - (amount + fee)), address: changeAddress)
        
        tx.addOutput(paymentOutput)
        tx.addOutput(changeOutput)
        
//
//        tx.tx_inputs.forEach { output in
//
//            let redeemScript = try? tx.signatureHash(for: output.script, inputIndex: output.index, hashType: .SIGHASH_ALL)
//
//        }
        
        return tx
        
//        let tx = BTCTransactionBuilder.init()
//
//        tx.dataSource = storage
//
//        let _tx = try? tx.buildTransaction()
    }
    
}

class BitcoinUnspentsStorage: NSObject, BTCTransactionBuilderDataSource {
    var outputs: [BTCTransactionOutput] = []
    
    static let storageKey = "bitcoin:utxo"
    var defaults: UserDefaults?
    
    init(_ outputs: [BTCTransactionOutput]) {
        super.init()
        
        self.outputs = outputs
    }
    
    convenience init(defaults: UserDefaults = .standard) {
//        guard let addr_str = address.body else {
//            fatalError("Can't init address")
//        }
        
        
        let utxos = defaults.array(forKey: BitcoinUnspentsStorage.storageKey) as? [UTXO] ?? []
        
        let outputs = utxos.map { utxo -> BTCTransactionOutput in
            if let output = utxo.toOutput() {
                return output
            } else {
                fatalError("Cant parse outputs from local db")
            }
        }
        
        self.init(outputs)
    }
    
    func saveState() {
        guard let defaults = defaults else { return }
        
        let utxo = outputs.map(UTXO.init)
        
        defaults.set(utxo, forKey: BitcoinUnspentsStorage.storageKey)
    }
    
    func update(newUnspents: [BTCTransactionOutput]) -> Bool {
        let newOutputs = newUnspents.filter { newOutput in
//            return !outputs.contains(where: { existingOutput in
//                print("compare", newOutput.address!, existingOutput.address!)
//                return newOutput.address! == existingOutput.address!
//            })
            
            return !outputs.contains(newOutput)
        }
        
        print("updte", newUnspents)
        
        print("updte", newOutputs)
        
        print("old", outputs)
        
        outputs += newOutputs
        
        return newOutputs.count > 0
    }
    
    func unspentOutputs(for txbuilder: BTCTransactionBuilder!) -> NSEnumerator! {
        let sorted_outputs = outputs.sorted { o1, o2 in o1.blockHeight > o2.blockHeight }
        
        return NSMutableSet(array: sorted_outputs).objectEnumerator()
    }

}
