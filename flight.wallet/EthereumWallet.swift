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

class EthereumWallet: CryptoWallet {
    
    var type: Chain = .Ethereum
    
    var addresses: [Address] = []
    var seed: String
    var keychain: BTCKeychain!
    
    required init(from seed: String) {
        self.seed = seed
        
        let words = seed.split(separator: " ")
        
        print(words)
        let mnemonic = BTCMnemonic(words: words, password: nil, wordListType: .english)
        
        guard let _seed = mnemonic?.seed else { return }
        
        keychain = BTCKeychain(seed: _seed)
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
            friendlyName: "Ether Account",
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
