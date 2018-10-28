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
        Address(network: .Mainnet, type: .Ethereum, path: "m/44'/0/0/1", friendlyName: "CryptoKitties", body: "0x1234567890987654321")
    ]
    
    required init(from seed: String) {
        let privateKey = try! EthereumPrivateKey(hexPrivateKey: seed == "" ? "0xa26da69ed1df3ba4bb2a231d506b711eace012f1bd2571dfbfff9650b03375af" : seed)
        
        do {
            
            let address = try EthereumAddress(hex: "0x17dA6A8B86578CEC4525945A355E8384025fa5Af", eip55: true)
            
            let tx = EthereumTransaction(
                nonce: 200,
                gasPrice: EthereumQuantity(quantity: 21.gwei),
                gas: 21000,
                to: address,
                value: EthereumQuantity(quantity: 1.eth)
            )
            
            print(tx)
            
            let signed = try tx.sign(with: privateKey, chainId: 0)
            
            print(signed)
            
        } catch {
            print(error)
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
