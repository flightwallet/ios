//
//  Wallet.swift
//  flight.wallet
//
//  Created by Aleksey Bykhun on 27/10/2018.
//  Copyright © 2018 Aleksey Bykhun. All rights reserved.
//

import Foundation

class Wallet {
    var wallets: [Chain: CryptoWallet] = [:]
    private var seed: String
    
    let seed_key = "flight.wallet.seed"
    
    static var instance: Wallet = {
        let wallet = Wallet.start()
        wallet.initCrypto()
        return wallet
    }()
    
    static func start() -> Wallet {
        if let wallet = Wallet(defaults: UserDefaults.standard) {
            return wallet
        } else {
            let seed = Wallet.generateSeed()
            let wallet = Wallet(from: seed)
            return wallet
        }
    }
    
    static func generateSeed() -> String {
        return ""
    }
    
    init(from seed: String) {
        self.seed = seed
    }
    
    init?(defaults: UserDefaults) {
        guard let seed = defaults.string(forKey: seed_key) else {
            return nil
        }
        
        self.seed = seed
    }
    
    func initCrypto() {
        add(wallet: BitcoinWallet(from: seed))
        add(wallet: EthereumWallet(from: seed))
    }
    
    func add(wallet: CryptoWallet) {
        wallets[wallet.type] = wallet
    }
    
    func storeSeed(defaults: UserDefaults) {
        defaults.set(self.seed, forKey: seed_key)
    }
    
    func getAddresses() -> [Address] {
        return wallets.mapValues({ (wallet) in
            return wallet.addresses
        }).flatMap({ (chain, addrs) -> [Address] in
            return addrs
        })
    }
}
