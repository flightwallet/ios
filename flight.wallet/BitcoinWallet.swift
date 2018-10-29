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
    
    var type: Chain = .Bitcoin
    
    let network: Network
    
    let body: String
    
    init?(from tx: String) {
        network = .Testnet
        body = "rawtx..."
    }
    
    func encode() -> String {
        return ""
    }
}

class BitcoinWallet: CryptoWallet {
    var type = Chain.Bitcoin
    var addresses: [Address] = [
//        Address(network: .Testnet, type: .Bitcoin, path: "m/44/0/0/1", friendlyName: "Default Address", body: "1Pdasdasds")
    ]
    
    var seed: String
    var keychain: BTCKeychain!
    
    required init(from seed: String) {
        self.seed = seed
        
//        let mnemonic = BTCMnemonic(data: Data.init(base64Encoded: seed))
        
        let words = seed.split(separator: " ")
        
        print(words)
        let mnemonic = BTCMnemonic(words: words, password: nil, wordListType: .english)
        
        
        guard let _seed = mnemonic?.seed else { return }
        
        keychain = BTCKeychain(seed: _seed)
    }
    
    func generateAddress(index: Int = 1) -> Address? {
        let path = "m/44'/60'/0/0/\(index)"
        
        guard let btcAddress = keychain.key(withPath: path)?.address else { return nil }
            
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
        let rawhex = "0000000111"
        
        guard let unsigned_tx = BTCTransaction.init(hex: rawhex) else {
            return nil
        }
        
        unsigned_tx.inputs.forEach { input in
            if let input = input as? BTCTransactionInput {
                
                let index = input.transactionOutput.index
                let script = input.signatureScript
                
                do {
                    let sig = try unsigned_tx.signatureHash(for: script, inputIndex: index, hashType: .SIGHASH_ALL)
                    
                    print(sig)
                 
//                    input.signatureScript.append(other: sig)
                } catch {
                    print(error)
                }
            }
        }
        
        return nil
    }
    
    func sign(tx: Transaction, address: Address) -> SignedTransaction? {
        return nil
    }
    
    func decode(tx: Transaction) -> DecodedTransaction? {
        return nil
    }
    
    func decode(tx: String) -> Transaction? {
        return BitcoinTransaction(from: tx)
    }
}

