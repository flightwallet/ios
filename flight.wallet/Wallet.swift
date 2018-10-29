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
    
    var isLoaded: Bool = false
    
    static var instance: Wallet = {
        let wallet = Wallet.start()
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
        return "solution endless depart clog hold rubber work use area enter visual govern"
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
        if isLoaded { return }
    
        let mnemonic = Wallet.generateSeed()
        
        let btcWallet = BitcoinWallet(from: mnemonic)
        let ethWallet = EthereumWallet(from: mnemonic)
        
        self.add(wallet: btcWallet)
        self.add(wallet: ethWallet)
    }
    
    func loaded(completion: @escaping () -> ()) {
        if isLoaded {
            return completion()
        }
        
        let ethWallet = wallets[.Ethereum]
        let btcWallet = wallets[.Bitcoin]
        
        ethWallet?.loaded {_ in
            btcWallet?.loaded {_ in
                self.isLoaded = true
                
                print(self.getAddresses())
                completion()
            }
        }
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
