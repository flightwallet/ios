//
//  Wallet.swift
//  flight.wallet
//
//  Created by Aleksey Bykhun on 27/10/2018.
//  Copyright © 2018 Aleksey Bykhun. All rights reserved.
//

import Foundation
import CoreBitcoin
import CryptoSwift

enum InitError: Error {
    case LoadMnemonicError
    case SaveMnemonicError
    case MnemonicExistsError
    case GeneratorError
}

class Wallet {
    var wallets: [Chain: CryptoWallet] = [:]
    private var seed: Data
    
    static let seed_key = "flight.wallet.seed"
    
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
    
    static func storeMnemonic(data: Data, defaults: UserDefaults = .standard) throws {
        let mnemonic = BTCMnemonic(data: data)
        
        guard nil == defaults.data(forKey: seed_key) else {
            throw InitError.MnemonicExistsError
        }
        
        guard mnemonic?.data == data else {
            throw InitError.SaveMnemonicError
        }
        
        defaults.set(data, forKey: seed_key)
    }
    
    static func loadMnenomic(defaults: UserDefaults = .standard) throws -> Data? {
        guard let data = defaults.data(forKey: seed_key) else {
            throw InitError.LoadMnemonicError
        }
        
        let mnemonic = BTCMnemonic(data: data)
        
        guard mnemonic?.data == data else {
            throw InitError.LoadMnemonicError
        }
        
        print(mnemonic?.words as! [String])
        
        return data
    }
    
    static func generateSeed() -> Data {
        var bytes = [UInt8](repeating: 0, count: 32)
        let error = SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes)
        
        guard error == 0 else {
            fatalError("InitError.GeneratorError")
        }
        
        let entropy = Data(bytes: bytes)
        
        let mnemonic = BTCMnemonic(entropy: entropy, password: "", wordListType: .english)!

        try! Wallet.storeMnemonic(data: mnemonic.data)
        
        print(mnemonic.words as! [String])
        
        return mnemonic.seed
    }
    
    init(from seed: Data) {
        self.seed = seed
    }
    
    init?(defaults: UserDefaults) {
        guard let data = try? Wallet.loadMnenomic(defaults: defaults) else {
            return nil
        }
        
        let mnemonic = BTCMnemonic(data: data)!
        
        
        self.seed = mnemonic.seed
    }
    
    func initCrypto() {
        if isLoaded { return }
    
        let btcWallet = BitcoinWallet(from: seed)
        let ethWallet = EthereumWallet(from: seed)
        
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
    
    func getAddresses() -> [Address] {
        return wallets.mapValues({ (wallet) in
            return wallet.addresses
        }).flatMap({ (chain, addrs) -> [Address] in
            return addrs
        })
    }
}
