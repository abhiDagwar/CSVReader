//
//  CsvDecoderTest.swift
//  CSVReaderTests
//
//  Created by Siya Dagwar on 08/04/22.
//

import XCTest
@testable import CSVReader

class CsvDecoderTest: XCTestCase {

    let csvDecoder = CsvDecoder()
    let csvArray = [["Nick", "Novak", "5", "2001-1-14T00:00:00"], ["Jim", "Green", "6", "1988-7-4T00:00:00"], ["Barry", "French", "10", "1987-3-1T00:00:00"], ["Clay", "Rozendal", "1", "1990-9-20T00:00:00"], ["Carlos", "Soltero", "0", "1986-12-5T00:00:00"], ["Carl", "Jackson", "12", "1975-5-28T00:00:00"], ["Monica", "Federle", "4", "1989-7-11T00:00:00"], ["Dorothy", "Badders", "9", "2000-2-2T00:00:00"], ["Neola", "Schneider", "11", "1988-8-9T00:00:00"], ["Carlos", "Daly", "2", "1983-11-9T00:00:00"], ["Allen", "Rosenblatt", "2", "1983-1-22T00:00:00"], ["Sylvia", "Foulston", "6", "1985-3-11T00:00:00"], ["Jim", "Radford", "9", "1982-4-30T00:00:00"], ["Don", "Miller", "100", "1980-10-2T00:00:00"]]
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        csvDecoder.decodeCsvToObject(with: csvArray)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDecodeCsvArray() {
        XCTAssertEqual(csvDecoder.issues[0].fullName, "Nick Novak")
        XCTAssertEqual(csvDecoder.issues.count, 14)
    }
    
    func testCsvDataAtIndexpath() {
        let indexPath = IndexPath(row: 3, section: 0)
        let issueData = csvDecoder.getIssueCellView(at: indexPath)
        XCTAssertEqual(issueData.fullName, "Clay Rozendal")
        XCTAssertEqual(issueData.issueCount, "1")
        XCTAssertEqual(issueData.dateOfBirth, "20 Sep 1990, 12:00 AM")
    }
}
