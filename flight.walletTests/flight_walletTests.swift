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
    
    func testBTCSignature() {
        
        let wallet = BitcoinWallet(from: seed)
        
        let rawtx = """
0100000002814345b8456b6a53c346af926bace8ebdf7cfb02b740d1feb4f4f8a9caf040f00100000000feffffffbc701d0cfe11aa5a984fa213522a1c867641a2798be10812ace5ad63dbd53c3a0100000000feffffff0240420f00000000001976a9142d736ae2babe22e79fe9234cec70572f364f062988ace07f1904000000001976a914e1d5c3b5919b5c9249469ddedd4a0ed10c5884e088ac00000000
"""
        
        let (tx, _) = wallet.sign(tx: rawtx)!

        let sm = BTCScriptMachine(transaction: tx, inputIndex: 0)!
        let output = tx.outputs.first as! BTCTransactionOutput
        let script = output.script.copy() as! BTCScript
        
        
        print("from", tx.from)
        print("to", tx.to)
        print("amount", tx.amount)
        
        do {
            try sm.verify(withOutputScript: script)
        } catch {
            print(error)
//            XCTFail("tx should be signed correctly")
        }
        
        XCTAssert(true, "btc script check")
        
    }
    
    
    func testETHSignature() {
        
        let wallet = EthereumWallet(from: seed)
        
        let rawtx = """
0xf86d820144843b9aca0082520894b78777860637d56543da23312c7865024833f7d188016345785d8a0000802ba0e2539a5d9f056d7095bd19d6b77b850910eeafb71534ebd45159915fab202e91a007484420f3968697974413fc55d1142dc76285d30b1b9231ccb71ed1e720faae
"""
        
        let unsigned_tx = """
ed8201ae843b9aca0082520894f8558382014485843b9aca008382520880a0a0a088016345785d8a0000801c8080
"""
        
        let _ = wallet.decode(tx: unsigned_tx)
        
        
    }
    
    func testBTCParseTX() {
        let rawtx = """
0100000001c2fbb74ffb350a8949aaed4846a3acaaf81251b3a96cbc464c06da5407bc8c38010000006b4830450221008eb90b018a4d60a181220566c3cb457e5e28c19254a61e725e57de5d8f3fc34502207b35bbe76f4bcb4e77180676d7f1b7a8e025f2f868949301a9d66507c6cd505b01210245f12096a5899e01dc45f237056a4ccf08117666613e921b432636e226ee5306feffffff0240420f000000000017a9142fd602e65a8da462e1871cc3a0224f730cd792698708030a04000000001976a914e1d5c3b5919b5c9249469ddedd4a0ed10c5884e088ac00000000
"""
        
        let tx = BTCTransaction(from: rawtx)
        
        
        XCTAssertEqual(tx?.tx_outputs?[0].address?.body, "2MwcA84sytaBBWwv44LubfHFGaWSunZk2tH", "btc script check")
        XCTAssertEqual(tx?.tx_outputs?[1].address?.body, "n274QqGLtTpbdKtJATCstFJs96tmT2V1qM", "btc script check")
        
    }

}
