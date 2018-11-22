//
//  EthereumWallet.swift
//  flight.wallet
//
//  Created by Aleksey Bykhun on 28/10/2018.
//  Copyright © 2018 Aleksey Bykhun. All rights reserved.
//

import Foundation
import Web3
import CoreBitcoin

struct EthereumTransactionInput: TransactionInput {
    var address: AbstractAddress?
    
    var amount: Double? = nil
    
    var text: String? {
        return address?.body
    }
}

struct EthereumTransactionOutput: TransactionOutput {
    var address: AbstractAddress?
    
    var amount: Double?
    
    
}

extension EthereumAddress: AbstractAddress {
    var isMainnet: Bool {
        return false
    }
    
    var type: Chain {
        return .Ethereum
    }
    
    var body: String? {
        return hex(eip55: true)
    }
}

extension EthereumTransaction: Transaction {
    var network: Network {
        return .Testnet
    }
    
    var body: String {
        
        return ""

//        guard let nonce = nonce, let gasPrice = gasPrice, let gasLimit = gas, let value = value else { fatalError("Cant decode tx") }
//
//        let chainId = network == .Mainnet ? 1 : 0 // Testnet
//
//        let rlp = RLPItem(
//            nonce: nonce,
//            gasPrice: gasPrice,
//            gasLimit: gasLimit,
//            to: to,
//            value: value,
//            data: data,
//            v: EthereumQuantity(integerLiteral: UInt64(chainId)),
//            r: 0,
//            s: 0
//        )
//
//        let rawRlp = try RLPEncoder().encode(rlp)
//
//        return rawRlp.ethereumValue().ethereumData?.hex() ?? ""
    }
    
    var type: Chain {
        return .Ethereum
    }
    
    var sender: String? {
        // recover signature
        return from?.body
    }
    
    var destination: String? {
        return to?.body
    }
    
    var total: Double? {
        return Double(value?.quantity ?? 0) / Double(1e18)
    }
    
    var fee: Double? {
        return 0
    }
    
    var tx_inputs: [TransactionInput]? {
        return [
            EthereumTransactionInput(address: from, amount: nil)
        ]
    }
    
    var tx_outputs: [TransactionOutput]? {
        return [
            EthereumTransactionOutput(address: to, amount: total)
        ]
    }
    
    func estimateChange(ownerAddress: AbstractAddress) -> Double {
        return 0
    }
    
    func estimateAmount(ownerAddress: AbstractAddress) -> Double {
        return total ?? 0
    }
    
    func encode() -> String {
        return body
    }
    
    func decode(rawhex: String) -> Transaction {
        fatalError("Transaction needs to know 'from' field: this doesnt work, use wallet.decode() instead")
        
        let raw_tx = Bytes(hex: rawhex)
        
        let rlp = try! RLPDecoder().decode(raw_tx).array!
        
        print("rlp", rlp)
        
        let edata = EthereumData(bytes: raw_tx)
        
        print("data", edata)
        
        let owner_addr_hex = "000fff000ADD2ECC" //generateAddress(index: 1)!.body!
        
        print("sender", owner_addr_hex)
        
        let nonce = EthereumQuantity(quantity: rlp[0].bigUInt!)
        let gasPrice = EthereumQuantity(quantity: rlp[1].bigUInt!)
        let gas = EthereumQuantity(quantity: rlp[2].bigUInt!)
        let from = try? EthereumAddress.init(hex: owner_addr_hex, eip55: true)
        // try? EthereumAddress(rawAddress: rlp[3].bytes!)
        let to = try? EthereumAddress(rawAddress: rlp[3].bytes!)
        let value = EthereumQuantity(quantity: rlp[4].bigUInt!)
        let data = EthereumData(bytes: rlp[5].bytes!)
        
        return EthereumTransaction(
            nonce: nonce, gasPrice: gasPrice, gas: gas,
            from: from, to: to, value: value, data: data
        )
    }
    
    
}

extension EthereumSignedTransaction: SignedTransaction {
    var unsigned: Transaction {
        return self
    }
    
    var signatures: [String] {
        return []
    }
}

extension EthereumSignedTransaction: Transaction {
    var network: Network {
        return chainId == 1
            ? .Mainnet
            : .Testnet
    }
    
    var body: String {
        return rlp().ethereumValue().string ?? ""
    }
    
    var type: Chain {
        return .Ethereum
    }
    
    var from: EthereumAddress? {
        guard verifySignature() else { return nil }
        
        let recId: BigUInt
        if v.quantity >= BigUInt(35) + (BigUInt(2) * chainId.quantity) {
            recId = v.quantity - BigUInt(35) - (BigUInt(2) * chainId.quantity)
        } else {
            if v.quantity >= 27 {
                recId = v.quantity - 27
            } else {
                recId = v.quantity
            }
        }
        
        let senderPublicKey = try? EthereumPublicKey(message: RLPEncoder().encode(rlp()), v: EthereumQuantity(quantity: recId), r: r, s: s)
        
        return senderPublicKey?.address
    }
    
    var sender: String? {
        return from?.hex(eip55: true)
    }
    
    var destination: String? {
        return to?.hex(eip55: true)
    }
    
    var total: Double? {
        return Double(value.quantity) / Double(1e18)
    }
    
    var fee: Double? {
        return 0
    }
    
    var tx_inputs: [TransactionInput]? {
        return [
            EthereumTransactionInput(address: from, amount: nil)
        ]
    }
    
    var tx_outputs: [TransactionOutput]? {
        return [
            EthereumTransactionOutput(address: to, amount: total)
        ]
    }
    
    func estimateChange(ownerAddress: AbstractAddress) -> Double {
        return 0
    }
    
    func estimateAmount(ownerAddress: AbstractAddress) -> Double {
        return total ?? 0
    }
    
    func encode() -> String {
        return body
    }
    
    func decode(rawhex: String) -> Transaction {
        fatalError("EthereumSignedTransaction: can't create signed tx from hex")
        
//        let raw_tx = Bytes(hex: rawhex)
//
//        let rlp = try! RLPDecoder().decode(raw_tx).array!
//
//        print("rlp", rlp)
//
//        let edata = EthereumData(bytes: raw_tx)
//
//        print("data", edata)
//        let chainId = EthereumQuantity(integerLiteral: 0)
//
//        let nonce = EthereumQuantity(quantity: rlp[0].bigUInt!)
//        let gasPrice = EthereumQuantity(quantity: rlp[1].bigUInt!)
//        let gas = EthereumQuantity(quantity: rlp[2].bigUInt!)
//        // try? EthereumAddress(rawAddress: rlp[3].bytes!)
//        let to = try? EthereumAddress(rawAddress: rlp[3].bytes!)
//        let value = EthereumQuantity(quantity: rlp[4].bigUInt!)
//        let data = EthereumData(bytes: rlp[5].bytes!)
//
//        return EthereumSignedTransaction(
//            nonce: nonce, gasPrice: gasPrice, gasLimit: gas,
//            to: to, value: value, data: data,
//            v: 0, r: 0, s: 0,
//            chainId: chainId)
    }
    
    
}

class EthereumWallet: CryptoWallet {
    
    var type: Chain = .Ethereum
    
    var addresses: [Address] = []
    var keychain: BTCKeychain!
    
    required init(from seed: Data) {
        keychain = BTCKeychain(seed: seed)
    }
    
    func generateAddress(index: Int = 1) -> Address? {
        let path = "m/44'/60'/0/0/\(index)"
        
        guard let key = keychain.key(withPath: path) else { return nil }
        
        let rawPriv = key.privateKey.base64EncodedString(options: .endLineWithCarriageReturn)
        
        guard let ethKey = try? EthereumPrivateKey(bytes: Bytes(base64: rawPriv)) else {
            return nil
        }
        
        let addressString = ethKey.address.hex(eip55: true)
        
        let address = Address(
            network: .Testnet,
            type: .Ethereum,
            path: path,
            friendlyName: "Ethereum Testnet",
            body: addressString
        )
        
        return address
    }
    
    func loaded(completion: @escaping (Address?) -> ()) {
        let _addrs = [
            generateAddress(index: 1),
        ]
        
        let addrs = _addrs.compactMap({ addr in addr })
        
        addresses += addrs
            
        completion(nil)
    }
    
    func decode(tx: Transaction) -> DecodedTransaction? {
        
        let from = try! EthereumAddress(hex: "0xfdsfsd", eip55: true)
        
        let to = try! EthereumAddress(hex: "0xfdsfsd", eip55: true)
        
        let tx_data = EthereumData(bytes: Bytes.init(hex: "000000000"))
        
        let tx = EthereumTransaction(
            nonce: 1,
            gasPrice: 10000,
            gas: 21000,
            from: from,
            to: to,
            value: 1,
            data: tx_data
        )
        
        print(tx)
        
        return nil
    }
    
    func decode(tx: String = "0xfdsfsd") -> Transaction? {
        let raw_tx = Bytes(hex: tx)
        
        let rlp = try! RLPDecoder().decode(raw_tx).array!
        
        print("rlp", rlp)
        
        let edata = EthereumData(bytes: raw_tx)
        
        
        print("data", edata)
        
        let owner_addr_hex = generateAddress(index: 1)!.body!
        
        print("sender", owner_addr_hex)
        
        let nonce = EthereumQuantity(quantity: rlp[0].bigUInt!)
        let gasPrice = EthereumQuantity(quantity: rlp[1].bigUInt!)
        let gas = EthereumQuantity(quantity: rlp[2].bigUInt!)
        let from = try? EthereumAddress.init(hex: owner_addr_hex, eip55: true)
                    // try? EthereumAddress(rawAddress: rlp[3].bytes!)
        let to = try? EthereumAddress(rawAddress: rlp[3].bytes!)
        let value = EthereumQuantity(quantity: rlp[4].bigUInt!)
        let data = EthereumData(bytes: rlp[5].bytes!)
        
        let tx = EthereumTransaction(
            nonce: nonce, gasPrice: gasPrice, gas: gas,
            from: from, to: to, value: value, data: data
        )
        
        return tx
        
    }
    
    func sign(tx: Transaction) -> SignedTransaction? {
        guard let tx = tx as? EthereumTransaction else {
            fatalError("Can't sign non-ethereum transaction in Ethereum wallet")
        }
        
        print(tx)
        
        let path = "m/44'/60'/0/0/\(1)"
        
        guard let key = keychain.key(withPath: path) else {
            return nil
        }
        
        
        let rawPriv = key.privateKey.base64EncodedString(options: .endLineWithCarriageReturn)
        
        guard let ethKey = try? EthereumPrivateKey(bytes: Bytes(base64: rawPriv)) else {
            return nil
        }
        
        
        let signed = try? tx.sign(with: ethKey, chainId: 4)
        
        print("tx", signed)
        
        print("tx signature", signed?.verifySignature())
        
        print("tx raw hex", signed?.rlp().ethereumValue().ethereumData?.hex())
        
        
        return signed
    }
    
    func sign(tx: Transaction, address: Address) -> SignedTransaction? {
        return nil
    }
    
    
}
