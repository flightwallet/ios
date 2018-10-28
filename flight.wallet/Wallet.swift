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
        return "asd asd asd asd"
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
    
    func initCrypto(jsEngine engine: JSEngine) {
        if isLoaded { return }
        
        let eth_priv = "d63264601ef2d420fe05decf1e3f7756b2826d69c33d16b7dd1fb5b0d79fe91d"
        let btc_wif = "cRF7Az481ffsuhhZ28x32Xk4ZvPh98zhKv7hCi1pKjifqvv7AcuX"
        
        let btcWallet = BitcoinWallet(from: btc_wif, jsEngine: engine)
        let ethWallet = EthereumWallet(from: eth_priv, jsEngine: engine)
        
        self.add(wallet: ethWallet)
        self.add(wallet: btcWallet)
        
        ethWallet.loaded {_ in
            btcWallet.loaded {_ in
                self.isLoaded = true
                
                print(self.getAddresses())
            }
        }
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
