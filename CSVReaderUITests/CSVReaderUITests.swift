//
//  CSVReaderUITests.swift
//  CSVReaderUITests
//
//  Created by Siya Dagwar on 30/03/22.
//

import XCTest
@testable import CSVReader

class CSVReaderUITests: XCTestCase {

    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        app.launch()
        app.accessibilityTraits = UIAccessibilityTraits.searchField

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSearchBar() throws {
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let searchfield = app.searchFields.element(boundBy: 0)
        searchfield.tap()
        app.searchFields["Search"].typeText("allen")
        app.buttons["Clear text"].tap()
        app.buttons["Cancel"].tap()
    }
    
    func testClearSearchResult() {
        let searchfield = app.searchFields.element(boundBy: 0)
        searchfield.tap()
        app.searchFields["Search"].typeText("nick")
        app.buttons["Clear text"].tap()
    }
    
    func testCancelSearchResult() {
        let searchfield = app.searchFields.element(boundBy: 0)
        searchfield.tap()
        app.buttons["Cancel"].tap()
    }
    
    func testShowNoSearchResultFound() throws {
        let searchfield = app.searchFields.element(boundBy: 0)
        searchfield.tap()
        app.searchFields["Search"].typeText("xavier")
        app.buttons["OK"].tap()
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
