//
//  EthereumWallet.swift
//  flight.wallet
//
//  Created by Aleksey Bykhun on 28/10/2018.
//  Copyright © 2018 Aleksey Bykhun. All rights reserved.
//

import Foundation
import Web3

class EthereumWallet: CryptoWallet {
    
    var type: Chain = .Ethereum
    
    var addresses: [Address] = [
//        Address(network: .Mainnet, type: .Ethereum, path: "m/44'/0/0/1", friendlyName: "Default Account", body: "0x1234567890987654321")
    ]
    var jsEngine: JSEngine!
    var seed: String
    
    required init(from seed: String, jsEngine: JSEngine) {
        self.jsEngine = jsEngine
        self.seed = seed
    }
    
    func loaded(completion: @escaping (Address?) -> ()) {
        jsEngine.runJS(code: "getAddress(\"\(seed)\")") {
            result, error in
            if let addressString = result as? String {
                let address = Address(network: .Testnet, type: .Ethereum, path: "", friendlyName: "CryptoKitties", body: addressString)
                
                self.addresses.append(address)
                completion(address)
            }
        }
    }
    
    func decode(tx: Transaction) -> DecodedTransaction? {
        return nil
    }
    
    func decode(tx: String) -> Transaction? {
        
        return nil
    }
    
    func sign(tx: Transaction) -> SignedTransaction? {
        return nil
    }
    
    func sign(tx: Transaction, address: Address) -> SignedTransaction? {
        return nil
    }
    
    
}
