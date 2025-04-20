//
//  ListViewUITests.swift
//  OrbitNewsUITests
//
//  Created by Christians bonilla on 20/04/25.
//

import XCTest


final class HomeViewUITests: XCTestCase {

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
    

    func testHomeViewLoadsSuccessfully() throws {
        
        let homeView = app.otherElements["HomeView"]
              XCTAssertTrue(homeView.waitForExistence(timeout: 15))
        
        let homeViewElements = app.descendants(matching: .any).matching(identifier: "HomeView")
        XCTAssertTrue(homeViewElements.count > 0, "No elements with HomeView identifier found")
        
        let noNewsText = app.staticTexts["No hay noticias disponibles"]
        XCTAssertFalse(noNewsText.waitForExistence(timeout: 10))
        
        // Test tab buttons
        let newsTab = app.buttons[NSLocalizedString("News", comment: "")]
        let searchTab = app.buttons[NSLocalizedString("Search", comment: "")]
        let favoritesTab = app.buttons[NSLocalizedString("Favorites", comment: "")]
        
        XCTAssertTrue(newsTab.exists, "News tab button not found")
        XCTAssertTrue(searchTab.exists, "Search tab button not found")
        XCTAssertTrue(favoritesTab.exists, "Favorites tab button not found")
        
        // Test retry button if it's showing the empty state
        let retryButton = app.buttons["Reintentar"]
        if retryButton.exists {
            XCTAssertTrue(retryButton.isHittable, "Retry button exists but is not hittable")
        }
    }
    
    func testTabSwitching() throws {
        
        let homeView = app.otherElements["HomeView"]
              XCTAssertTrue(homeView.waitForExistence(timeout: 15))
        
        // Tap on Favorites tab
        let favoritesTab = app.buttons[NSLocalizedString("Favorites", comment: "")]
        XCTAssertTrue(favoritesTab.waitForExistence(timeout: 5))
        favoritesTab.tap()
        
        sleep(2)
        
        let favoritesIndicator = app.staticTexts.containing(NSPredicate(format: "label CONTAINS %@", NSLocalizedString("Favorites", comment: "")))
        XCTAssertTrue(favoritesIndicator.firstMatch.waitForExistence(timeout: 5))
    }
    
}

