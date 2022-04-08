//
//  CsvParserTest.swift
//  CSVReaderTests
//
//  Created by Siya Dagwar on 08/04/22.
//

import XCTest
@testable import CSVReader

class CsvParserTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCsvParser() {
        let promise = expectation(description: "Parsing Csv file.")
        let csv = CsvParser()
        csv.parseCSV(with: "issue") { (csv, error) in
            guard error == nil else {
                print(error?.localizedDescription as Any)
                XCTFail("Error: \(error!.localizedDescription)")
                return
            }
            
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 30)
    }
    
}
