//
//  demo_quiz_appUITests.swift
//  demo-quiz-appUITests
//
//  Created by Piyush Joshi on 5/6/17.
//  Copyright © 2017 Piyush Joshi. All rights reserved.
//

import XCTest

class demo_quiz_appUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        
        let usernameTextField = app.textFields["Username"]
        usernameTextField.tap()
        usernameTextField.typeText("piyushjo")
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("MobileCenter")
        
        let letSPlayButton = XCUIApplication().buttons["Let's Play"]
        XCTAssert(letSPlayButton.isEnabled == true, "Play button should be enabled after succesfull login")
    }
}
