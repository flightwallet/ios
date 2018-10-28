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
        let privateKey = "0xd63264601ef2d420fe05decf1e3f7756b2826d69c33d16b7dd1fb5b0d79fe91d"
        let wallet = EthereumWallet(from: privateKey)
        
        
        
        
        
    }

    
    func testBTC() {
        let privateKey = "cDfds"
        
        
    }
}
