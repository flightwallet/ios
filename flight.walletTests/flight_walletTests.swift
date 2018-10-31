//
//  flight_walletTests.swift
//  flight.walletTests
//
//  Created by Aleksey Bykhun on 27/10/2018.
//  Copyright © 2018 Aleksey Bykhun. All rights reserved.
//

import XCTest
@testable import flight_wallet
import CoreBitcoin

class flight_walletTests: XCTestCase {

    var seed: Data!
    
    override func setUp() {
        seed = generateSeed()
    }

    func generateSeed() -> Data {
        let privateKey = "prosper adapt kiss kid sock blur window guilt green sort treat erupt lunar slot student fall rubber modify try salute toilet hard weapon fire"
        
        let words = privateKey.split(separator: " ")
        
        let mnemonic = BTCMnemonic(words: words, password: "", wordListType: .english)!
        
        return mnemonic.seed
    }
    
    func testETH() {
        
        let wallet = EthereumWallet(from: seed)
        
        let address = wallet.generateAddress()
        
        XCTAssert(address != nil)
    }

    
    func testBTC() {
        let wallet = BitcoinWallet(from: seed)
        
        let address = wallet.generateAddress()
        
        XCTAssert(address != nil)
    }
    
    func testSignature() {
        
        let wallet = BitcoinWallet(from: seed)
        
        let rawtx = """
0100000002814345b8456b6a53c346af926bace8ebdf7cfb02b740d1feb4f4f8a9caf040f00100000000feffffffbc701d0cfe11aa5a984fa213522a1c867641a2798be10812ace5ad63dbd53c3a0100000000feffffff0240420f00000000001976a9142d736ae2babe22e79fe9234cec70572f364f062988ace07f1904000000001976a914e1d5c3b5919b5c9249469ddedd4a0ed10c5884e088ac00000000
"""
        
        let (tx, _) = wallet.sign(tx: rawtx)!

        let sm = BTCScriptMachine(transaction: tx, inputIndex: 0)!
        let output = tx.outputs.first as! BTCTransactionOutput
        let script = output.script.copy() as! BTCScript
        
        do {
            try sm.verify(withOutputScript: script)
        } catch {
            print(error)
            XCTFail("tx should be signed correctly")
        }
        
    }

}
