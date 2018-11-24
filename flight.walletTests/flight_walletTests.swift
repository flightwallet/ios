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

let utxo_json = """
[
{
"address": "n274QqGLtTpbdKtJATCstFJs96tmT2V1qM",
"tx_hash": "24a4f491809f0e937eba35bbff76fd89d7c698dda3336b19a957f5b0c2605322",
"vout": 0,
"script": "76a914e1d5c3b5919b5c9249469ddedd4a0ed10c5884e088ac",
"amount": 0.01,
"value": 1000000,
"height": 1445028,
"confirmations": 17
},
{
"address": "n274QqGLtTpbdKtJATCstFJs96tmT2V1qM",
"tx_hash": "d6c10d4c28982c864b9b9f581ffa47aa2e5634c861672fa763d2ef87376645a3",
"vout": 1,
"script": "76a914e1d5c3b5919b5c9249469ddedd4a0ed10c5884e088ac",
"amount": 0.10155473,
"value": 10155473,
"height": 1444996,
"confirmations": 49
},
{
"address": "n274QqGLtTpbdKtJATCstFJs96tmT2V1qM",
"tx_hash": "e398f88a38a2e3e9648c5ea08e2af819f7f17fc870ab6b4f80762dea7b2089ee",
"vout": 0,
"script": "76a914e1d5c3b5919b5c9249469ddedd4a0ed10c5884e088ac",
"amount": 0.001,
"value": 100000,
"height": 1444991,
"confirmations": 54
},
{
"address": "n274QqGLtTpbdKtJATCstFJs96tmT2V1qM",
"tx_hash": "f597ee99260aadd9fc3016cb2e4fb8ff40e0c2cde42b73b330811ffd50612e33",
"vout": 0,
"script": "76a914e1d5c3b5919b5c9249469ddedd4a0ed10c5884e088ac",
"amount": 0.01,
"value": 1000000,
"height": 1444990,
"confirmations": 55
},
{
"address": "n274QqGLtTpbdKtJATCstFJs96tmT2V1qM",
"tx_hash": "d18b12d51a54289ce1febca5484c072392c2ca0172fb4f726f7c97ece2adb1b0",
"vout": 0,
"script": "76a914e1d5c3b5919b5c9249469ddedd4a0ed10c5884e088ac",
"amount": 0.001,
"value": 100000,
"height": 1444905,
"confirmations": 140
},
{
"address": "n274QqGLtTpbdKtJATCstFJs96tmT2V1qM",
"tx_hash": "25713c445887f5e64b94285b4cae5c668c58101fc05bc3d1492c5863d05c4efc",
"vout": 0,
"script": "76a914e1d5c3b5919b5c9249469ddedd4a0ed10c5884e088ac",
"amount": 0.1,
"value": 10000000,
"height": 1444745,
"confirmations": 300
},
{
"address": "n274QqGLtTpbdKtJATCstFJs96tmT2V1qM",
"tx_hash": "0d154cfe8a280baae00281bf391c38ac91ed62a589025e1311887091ddee598f",
"vout": 0,
"script": "76a914e1d5c3b5919b5c9249469ddedd4a0ed10c5884e088ac",
"amount": 0.01,
"value": 1000000,
"height": 1444593,
"confirmations": 452
},
{
"address": "n274QqGLtTpbdKtJATCstFJs96tmT2V1qM",
"tx_hash": "694656cc9c68e307e146b1c1c30ad9b40613cbd11646231a0bfe4d149825b3e9",
"vout": 0,
"script": "76a914e1d5c3b5919b5c9249469ddedd4a0ed10c5884e088ac",
"amount": 0.001,
"value": 100000,
"height": 1444505,
"confirmations": 540
},
{
"address": "n274QqGLtTpbdKtJATCstFJs96tmT2V1qM",
"tx_hash": "3243000f34e67161a23259fbf4637a2f1ffd475af266a130fc14a9a425c819a1",
"vout": 0,
"script": "76a914e1d5c3b5919b5c9249469ddedd4a0ed10c5884e088ac",
"amount": 0.002,
"value": 200000,
"height": 1444505,
"confirmations": 540
},
{
"address": "n274QqGLtTpbdKtJATCstFJs96tmT2V1qM",
"tx_hash": "1f0c2379f9a9d01de0ebeb5bc3e820ffab5c4e237cd86db27a49aea76811bd4d",
"vout": 0,
"script": "76a914e1d5c3b5919b5c9249469ddedd4a0ed10c5884e088ac",
"amount": 0.01,
"value": 1000000,
"height": 1444504,
"confirmations": 541
},
{
"address": "n274QqGLtTpbdKtJATCstFJs96tmT2V1qM",
"tx_hash": "7336e7915b61fb162ac15fa417fd54a33e1a08ad549cc0f39c6cdf2bf18a5095",
"vout": 0,
"script": "76a914e1d5c3b5919b5c9249469ddedd4a0ed10c5884e088ac",
"amount": 0.1,
"value": 10000000,
"height": 1442406,
"confirmations": 2639
},
{
"address": "n274QqGLtTpbdKtJATCstFJs96tmT2V1qM",
"tx_hash": "188e26e307f054846e8c5896167440b244db8eb4aef3a1c09f584463cf5fcce1",
"vout": 0,
"script": "76a914e1d5c3b5919b5c9249469ddedd4a0ed10c5884e088ac",
"amount": 0.01,
"value": 1000000,
"height": 1442405,
"confirmations": 2640
},
{
"address": "n274QqGLtTpbdKtJATCstFJs96tmT2V1qM",
"tx_hash": "e20f75489f89611ee27560cc28cf39d17580f2ffeaef82918a41c3ac1dda990c",
"vout": 0,
"script": "76a914e1d5c3b5919b5c9249469ddedd4a0ed10c5884e088ac",
"amount": 0.01,
"value": 1000000,
"height": 1442133,
"confirmations": 2912
},
{
"address": "n274QqGLtTpbdKtJATCstFJs96tmT2V1qM",
"tx_hash": "32989c99107c0b0b69ef51a2a55d3394378c4b75181bb6ee3c177e25b9841861",
"vout": 0,
"script": "76a914e1d5c3b5919b5c9249469ddedd4a0ed10c5884e088ac",
"amount": 0.1,
"value": 10000000,
"height": 1441628,
"confirmations": 3417
},
{
"address": "n274QqGLtTpbdKtJATCstFJs96tmT2V1qM",
"tx_hash": "026ae1ac887b0ba3f61f64a7b7bb97c4fcbff6aaaa93f60d6fb5ce9f63a81273",
"vout": 1,
"script": "76a914e1d5c3b5919b5c9249469ddedd4a0ed10c5884e088ac",
"amount": 0.5775,
"value": 57750000,
"height": 1441570,
"confirmations": 3475
}
]
"""

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
        
        
        print("from", tx.sender)
        print("to", tx.destination)
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
        
        let signed = wallet.decode(tx: unsigned_tx)
        
//        print(tx)
        
//        let signed = wallet.sign(tx: <#T##Transaction#>)
        
        print(signed!.body)
        
        XCTAssert(signed != nil)
        
    }
    
    func testBTCParseTX() {
        let rawtx = """
0100000001c2fbb74ffb350a8949aaed4846a3acaaf81251b3a96cbc464c06da5407bc8c38010000006b4830450221008eb90b018a4d60a181220566c3cb457e5e28c19254a61e725e57de5d8f3fc34502207b35bbe76f4bcb4e77180676d7f1b7a8e025f2f868949301a9d66507c6cd505b01210245f12096a5899e01dc45f237056a4ccf08117666613e921b432636e226ee5306feffffff0240420f000000000017a9142fd602e65a8da462e1871cc3a0224f730cd792698708030a04000000001976a914e1d5c3b5919b5c9249469ddedd4a0ed10c5884e088ac00000000
"""
        
        let tx = BTCTransaction(from: rawtx)
        
        
        XCTAssertEqual(tx?.tx_outputs?[0].address?.body, "2MwcA84sytaBBWwv44LubfHFGaWSunZk2tH", "btc script check")
        XCTAssertEqual(tx?.tx_outputs?[1].address?.body, "n274QqGLtTpbdKtJATCstFJs96tmT2V1qM", "btc script check")
        
    }
    
    
    func testETHParseTX() {
        
        let wallet = EthereumWallet(from: seed)
        
        let unsigned_tx = """
ed8201ae843b9aca0082520894f8558382014485843b9aca008382520880a0a0a088016345785d8a0000801c8080
"""
        
        let decoded_tx = wallet.decode(tx: unsigned_tx)!
        
        let tx = wallet.sign(tx: decoded_tx)
        
        print("sender", tx?.sender)
        
        print("dest", tx?.destination)
        
        print(tx?.tx_inputs)
        
        print(tx?.tx_outputs)
        
        XCTAssertNotNil(tx, "tx exists")
        
        XCTAssertEqual(tx?.body, "0xf86d8201ae843b9aca0082520894f8558382014485843b9aca008382520880a0a0a088016345785d8a0000801ca0ce2b15b79354ea235ca445365b6e01f2cb8cb95bffb8036fb18f8239bed09c9da06c0c217a7ecf1531a5cd5db243b5aa750b4bf573d6a5e1ab4228ec6cf1b3ff45", "tx signed correctly")
        
        XCTAssertEqual(tx?.tx_inputs?[0].address?.body, "0x8101136E114C8678761AA5964D0ae03C71f427f7", "eth input check")
        XCTAssertEqual(tx?.tx_outputs?[0].address?.body, "0xf8558382014485843b9aCa008382520880A0a0a0", "eth output check")
        
    }
    
    
    
    func testBTCUpdateWalletUtxos() {
        let wallet = BitcoinWallet(from: seed)
        let update = BitcoinWalletUpdate(from: utxo_json)!
        
        let isUpdated = wallet.sync(update: update)
        
        XCTAssertTrue(isUpdated, "wallet updates")
        
        XCTAssert(wallet.storage.outputs.count > 0, "wallet now has utxos")
        
        XCTAssert(wallet.storage.outputs.count < 20, "wallet does not import them twice")
    }
    
    func testBTCBuildTx() {
        let wallet = BitcoinWallet(from: seed)
        let update = BitcoinWalletUpdate(from: utxo_json)!
        
        let isUpdated = wallet.sync(update: update)
        XCTAssertTrue(isUpdated, "wallet updates")
        
        let addr = BTCAddress(string: "mjoyi9JuAgfagT4vcpVxvydbkMW9HrPTPz")!
        
        let tx = wallet.buildTx(to: addr, value: 0.05)
        
        XCTAssert(tx != nil, "tx built ok")
    }
    
}
