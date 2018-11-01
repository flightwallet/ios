//
//  flight_walletUITests.swift
//  flight.walletUITests
//
//  Created by Aleksey Bykhun on 27/10/2018.
//  Copyright © 2018 Aleksey Bykhun. All rights reserved.
//

import XCTest

class flight_walletUITests: XCTestCase {

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

    func testExample() {
       
        
        let app = XCUIApplication()
        let toolbar = app.toolbars["Toolbar"]
        let selectAccountButton = toolbar.buttons["SELECT ACCOUNT"]
        selectAccountButton.tap()
        selectAccountButton.swipeUp()
        toolbar.buttons["PAY"].tap()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.tap()
        toolbar.buttons["PROCEED"].tap()
        
        
        XCTAssertTrue(true, "should not fail")
    }

}
