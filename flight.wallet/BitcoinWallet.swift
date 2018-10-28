//
//  BitcoinWallet.swift
//  flight.wallet
//
//  Created by Aleksey Bykhun on 28/10/2018.
//  Copyright © 2018 Aleksey Bykhun. All rights reserved.
//

import Foundation
import secp256k1

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
        Address(network: .Mainnet, type: .Bitcoin, path: "m/44/0/0/1", friendlyName: "Address 1", body: "1Pdasdasds")
    ]
    
    required init(from seed: String) {
        
//        let privateKey = PrivateKey(network: .testnet) // You can choose .mainnet or .testnet
//        let wallet = Wallet(privateKey: privateKey)
//
//        let wallet = try Wallet(wif: "92pMamV6jNyEq9pDpY4f6nBy9KpV2cfJT4L5zDUYiGqyQHJfF1K")
//
//        // Generate mnemonic
//        let mnemonic = try Mnemonic.generate()
//
//        // Generate seed from the mnemonic
//        let seed = Mnemonic.seed(mnemonic: mnemonic)
//
//        let wallet = HDWallet(seed: seed, network: .testnet)
//
//        let mnemonic = try Mnemonic.generate()
//        let seed = Mnemonic.seed(mnemonic: mnemonic)
        
        
        
//        let privateKey = HDPrivateKey(seed: seed, network: .testnet)
//        
//        // m/0'
//        let m0prv = try! privateKey.derived(at: 0, hardened: true)
//        
//        // m/0'/1
//        let m01prv = try! m0prv.derived(at: 1)
//        
//        // m/0'/1/2'
//        let m012prv = try! m01prv.derived(at: 2, hardened: true)
    }
    
    func getAddress () -> Address {
        return Address(network: .Mainnet, type: self.type, path: "m/44/0/0/1", friendlyName: "Address 1", body: "1KasdasdasD")
    }
    
    func sign(tx: Transaction) -> SignedTransaction? {
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

