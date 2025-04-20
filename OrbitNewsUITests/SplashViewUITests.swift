//
//  OrbitNewsUITests.swift
//  OrbitNewsUITests
//
//  Created by Christians bonilla on 17/04/25.
//

import XCTest

final class SplashViewUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        app.launch()
    }
    
    override func tearDown() {
        app.terminate()
        app = nil
        super.tearDown()
    }
    
    func testLottieAnimationAndNavigationToHome() {
        
            let splashScreenExists = app.otherElements["SplashView"].waitForExistence(timeout: 3)
            XCTAssertTrue(splashScreenExists, "La vista Splash debe aparecer al iniciar la aplicación.")
        
            let homeViewExists = app.otherElements["HomeView"].waitForExistence(timeout: 10)
            XCTAssertTrue(homeViewExists, "La vista Home debe aparecer después de la animación Lottie.")
        
        }
}
