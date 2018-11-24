//
//  flight_walletUITests.swift
//  flight.walletUITests
//
//  Created by Aleksey Bykhun on 27/10/2018.
//  Copyright © 2018 Aleksey Bykhun. All rights reserved.
//

import XCTest

class flight_walletUITests: XCTestCase {
    let rawtx = """
0100000001c2fbb74ffb350a8949aaed4846a3acaaf81251b3a96cbc464c06da5407bc8c38010000006b4830450221008eb90b018a4d60a181220566c3cb457e5e28c19254a61e725e57de5d8f3fc34502207b35bbe76f4bcb4e77180676d7f1b7a8e025f2f868949301a9d66507c6cd505b01210245f12096a5899e01dc45f237056a4ccf08117666613e921b432636e226ee5306feffffff0240420f000000000017a9142fd602e65a8da462e1871cc3a0224f730cd792698708030a04000000001976a914e1d5c3b5919b5c9249469ddedd4a0ed10c5884e088ac00000000
"""
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSigning() {
        
        let app = XCUIApplication()
        let toolbar = app.toolbars["Toolbar"]
        toolbar.buttons["UNLOCK"].tap()
        app.tables.staticTexts["Bitcoin Testnet"].tap()
        toolbar.buttons["PAY"].tap()
        toolbar.buttons["PROCEED"].tap()

        let clearTextField = String(repeating: XCUIKeyboardKey.delete.rawValue, count: 15)
        
        app.typeText(clearTextField + rawtx)
        
        app.buttons["Parse"].tap()
        
        // scan QR code
        
        
        toolbar.buttons["APPROVE"].tap()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element(boundBy: 4).children(matching: .other).element.children(matching: .other).element.tap()
        toolbar.buttons["FINISH"].tap()
        

        XCTAssertTrue(true, "should not fail")
    }
    
    
    func testBadTxInput() {
        
        let app = XCUIApplication()
        let toolbar = app.toolbars["Toolbar"]
        toolbar.buttons["UNLOCK"].tap()
        app.tables.staticTexts["Bitcoin Testnet"].tap()
        toolbar.buttons["PAY"].tap()
        toolbar.buttons["PROCEED"].tap()
        
//        app.typeText("WRONG INPUT")
        
        app.buttons["Parse"].tap()
        
        // scan QR code
                
        XCTAssertTrue(true, "should not fail")
    }

}
