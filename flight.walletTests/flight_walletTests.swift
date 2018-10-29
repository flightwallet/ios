//
//  flight_walletTests.swift
//  flight.walletTests
//
//  Created by Aleksey Bykhun on 27/10/2018.
//  Copyright © 2018 Aleksey Bykhun. All rights reserved.
//

import XCTest
@testable import flight_wallet

class flight_walletTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testETH() {
        let privateKey = "solution endless depart clog hold rubber work use area enter visual govern"
        let wallet = EthereumWallet(from: privateKey)
        
        let address = wallet.generateAddress()
        
        XCTAssert(address != nil)
        
        
    }

    
    func testBTC() {
        let privateKey = "solution endless depart clog hold rubber work use area enter visual govern"
        let wallet = BitcoinWallet(from: privateKey)
        
        let address = wallet.generateAddress()
        
        XCTAssert(address != nil)
    }
    
    func testSignature() {
        
        let privateKey = "solution endless depart clog hold rubber work use area enter visual govern"
        let wallet = BitcoinWallet(from: privateKey)
        
        let rawtx = """
01000000012b4fcd2309554dfab9bdfbdd9e558f776f760c377d4b8819ef0b364c35be54ae010000006b4830450221009f7dc9c4243dae374f99db15c075eb6de21a90f60ddafcbcee4c09302141479a0220579ba73c3b6ac75e938426c72546505da5258048a39df73e7e50870902f5a7950121033a117cc4d164984c1e8fb58f39f08a17a2e615d77d8f7a35a7d9cdeb9e93ef4cfeffffff0100e20400000000001976a91436963a21b49f701acf03dd1e778ab5774017b53c88ac00000000
"""
        
        let signed = wallet.sign(rawtx)
        
        print(signed)
    }

}
