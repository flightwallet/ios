//
//  BitcoinWallet.swift
//  flight.wallet
//
//  Created by Aleksey Bykhun on 28/10/2018.
//  Copyright © 2018 Aleksey Bykhun. All rights reserved.
//

import Foundation

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
    
    var jsEngine: JSEngine!
    var seed: String
    
    required init(from seed: String, jsEngine: JSEngine) {
        self.jsEngine = jsEngine
        self.seed = seed
    }

    func loaded(completion: @escaping (Address?) -> ()) {
        jsEngine.runJS(code: "getBTCAddress(\"\(seed)\")") {
            result, error in
            if let addressString = result as? String {
                let address = Address(network: .Testnet, type: .Bitcoin, path: "", friendlyName: "TEST BITCOIN", body: addressString)
                
                self.addresses.append(address)
                completion(address)
            }
        }
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

