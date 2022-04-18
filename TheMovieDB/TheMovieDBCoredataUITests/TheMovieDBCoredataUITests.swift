//
//  TheMovieDBCoredataUITests.swift
//  TheMovieDBCoredataUITests
//
//  Created by jianli on 4/12/22.
//

import XCTest

class TheMovieDBCoredataUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

        func testExample() throws {
        // UI tests must launch the application that they test.
            let app = XCUIApplication()
            app.launch()
            
            let mainTableViewTable = XCUIApplication().tables["Main.Table.View"]
            mainTableViewTable/*@START_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"Sonic the Hedgehog 2").element/*[[".cells.containing(.staticText, identifier:\"After settling in Green Hills, Sonic is eager to prove he has what it takes to be a true hero. His test comes when Dr. Robotnik returns, this time with a new partner, Knuckles, in search for an emerald that has the power to destroy civilizations. Sonic teams up with his own sidekick, Tails, and together they embark on a globe-trotting journey to find the emerald before it falls into the wrong hands.\").element",".cells.containing(.staticText, identifier:\"Sonic the Hedgehog 2\").element"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
            
            XCTAssert(true)
            // Use XCTAssert and related functions to verify your tests produce the correct results.
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
