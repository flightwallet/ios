//
//  BitcoinWallet.swift
//  flight.wallet
//
//  Created by Aleksey Bykhun on 28/10/2018.
//  Copyright © 2018 Aleksey Bykhun. All rights reserved.
//

import Foundation
import CoreBitcoin

struct BitcoinTransaction: Transaction {
    var fee: Double?
    
    var change: Double?
    
    var from: String?
    
    var to: String?
    
    var amount: Double?
    
    var type: Chain = .Bitcoin
    
    let network: Network
    
    let body: String
    
    init?(from tx: String) {
        network = .Testnet
        body = tx //"rawtx..."
    }
    
    func encode() -> String {
        return ""
    }
}

extension BTCTransaction: Transaction {
    var from: String? {
        guard let tx_inputs = inputs as? [BTCTransactionInput] else {
            return nil
        }
        
        return tx_inputs.map { input in
            print("\tinput: ")
            if let tx_id = input.previousTransactionID {
                return "\(tx_id):\(input.previousIndex)"
            } else {
                return "-"
            }
        }.joined(separator: ", ")
    }
    
    var to: String? {
        guard let tx_outputs = outputs as? [BTCTransactionOutput] else {
            return nil
        }
        
        return tx_outputs.map { output in
            print(output)
            guard let script = output.script else { return "-" }
            
            print(script.string)
            
            if script.isPayToPublicKeyHashScript {
                
                let address = script.standardAddress
                
                print(address)
                
                let addressTestnet = BTCPublicKeyAddressTestnet(data: address?.data)
                print(addressTestnet)
                
                return addressTestnet?.string ?? "-"
            } else {
                let address = script.scriptHashAddressTestnet
                
                print(address)
                
                return address?.string ?? "-"
            }
        }.joined(separator: ", ")
    }
    
    var amount: Double? {
        guard let tx_outputs = outputs as? [BTCTransactionOutput] else {
            return nil
        }
        
        let values = tx_outputs.map { output -> Double in
            return Double(output.value) / Double(BTCCoin)
        }
        
        return values.first
    }
    
    var change: Double? {
        guard let tx_outputs = outputs as? [BTCTransactionOutput] else {
            return nil
        }
        
        let values = tx_outputs.map { output -> Double in
            return Double(output.value) / Double(BTCCoin)
        }
        
        return values.reduce(0, +) - (values.first ?? 0)
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

class BitcoinWallet: CryptoWallet {
    var type = Chain.Bitcoin
    var addresses: [Address] = [
//        Address(network: .Testnet, type: .Bitcoin, path: "m/44/0/0/1", friendlyName: "Default Address", body: "1Pdasdasds")
    ]
    
    var keychain: BTCKeychain!
    
    required init(from seed: Data) {
        keychain = BTCKeychain(seed: seed, network: .testnet())!
    }
    
    func generateAddress(index: Int = 1) -> Address? {
        let path = "m/44'/0'/0/0/\(index)"
        
        guard let btcAddress = keychain.key(withPath: path)?.addressTestnet else { return nil }
            
        let addressString = btcAddress.string
        
        let address = Address(
            network: .Testnet,
            type: .Bitcoin,
            path: path,
            friendlyName: "Bitcoin Account",
            body: addressString
        )
        
        return address
    }
    
    
    func loaded(completion: @escaping (Address?) -> ()) {
        let _addrs = [
            generateAddress(index: 1),
            generateAddress(index: 2),
            generateAddress(index: 3),
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
        return BitcoinTransaction(from: tx)
    }
}

