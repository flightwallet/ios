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
        
        print(tx)
        
        let path = "m/44'/60'/0/0/\(1)"
        
        guard let key = keychain.key(withPath: path) else {
            return nil
        }
        
        
        let rawPriv = key.privateKey.base64EncodedString(options: .endLineWithCarriageReturn)
        
        guard let ethKey = try? EthereumPrivateKey(bytes: Bytes(base64: rawPriv)) else {
            return nil
        }
        
        
        let signed = try? tx.sign(with: ethKey, chainId: 0)
        
        print(signed)
        
        print(signed?.verifySignature())
        
        print(signed?.rlp().ethereumValue().ethereumData?.hex())
        
        
        return nil
    }
    
    func sign(tx: Transaction) -> SignedTransaction? {
        return nil
    }
    
    func sign(tx: Transaction, address: Address) -> SignedTransaction? {
        return nil
    }
    
    
}
