//
//  CsvContentSearchTest.swift
//  CSVReaderTests
//
//  Created by Siya Dagwar on 15/04/22.
//

import XCTest
@testable import CSVReader

class CsvContentSearchTest: XCTestCase {
    
    var systemUnderTest: CsvReaderViewController!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        //get the storyboard the ViewController under test is inside
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        //get the ViewController we want to test from the storyboard (note the identifier is the id explicitly set in the identity inspector)
        systemUnderTest = storyboard.instantiateViewController(withIdentifier: "CsvReaderViewController") as? CsvReaderViewController
        
        //load view hierarchy
        _ = systemUnderTest.view
        
        //load defalut data
        let issues = [Issue(fullName: "Nick Novak", issueCount: "5", dateOfBirth: "14 Jan 2001, 12:00 AM"), Issue(fullName: "Jim Green", issueCount: "6", dateOfBirth: "4 Jul 1988, 12:00 AM"), Issue(fullName: "Barry French", issueCount: "10", dateOfBirth: "1 Mar 1987, 12:00 AM"), Issue(fullName: "Clay Rozendal", issueCount: "1", dateOfBirth: "20 Sep 1990, 12:00 AM"), Issue(fullName: "Carlos Soltero", issueCount: "0", dateOfBirth: "5 Dec 1986, 12:00 AM"), Issue(fullName: "Carl Jackson", issueCount: "12", dateOfBirth: "28 May 1975, 12:00 AM"), Issue(fullName: "Monica Federle", issueCount: "4", dateOfBirth: "11 Jul 1989, 12:00 AM"), Issue(fullName: "Dorothy Badders", issueCount: "9", dateOfBirth: "2 Feb 2000, 12:00 AM"), Issue(fullName: "Neola Schneider", issueCount: "11", dateOfBirth: "9 Aug 1988, 12:00 AM"), Issue(fullName: "Carlos Daly", issueCount: "2", dateOfBirth: "9 Nov 1983, 12:00 AM"), Issue(fullName: "Allen Rosenblatt", issueCount: "2", dateOfBirth: "22 Jan 1983, 12:00 AM"), Issue(fullName: "Sylvia Foulston", issueCount: "6", dateOfBirth: "11 Mar 1985, 12:00 AM"), Issue(fullName: "Jim Radford", issueCount: "9", dateOfBirth: "30 Apr 1982, 12:00 AM"), Issue(fullName: "Don Miller", issueCount: "100", dateOfBirth: "2 Oct 1980, 12:00 AM")]
        systemUnderTest.csvDecoder.issues = issues
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCanBeInstantiated() {
        
        XCTAssertNotNil(systemUnderTest)
    }
    // MARK: - SearchBar
    
    func testHasSearchBar() {
        
        XCTAssertNotNil(systemUnderTest.searchController.searchBar)
    }
    
    func testSUT_ShouldSetSearchBarDelegate() {
        
        XCTAssertNotNil(systemUnderTest.searchController.searchBar.delegate)
    }
    
    func testConformsToSearchBarDelegateProtocol() {
        
        XCTAssert(systemUnderTest.conforms(to: UISearchBarDelegate.self))
        XCTAssertTrue(self.systemUnderTest.responds(to: #selector(systemUnderTest.searchBar(_:textDidChange:))))
        XCTAssertTrue(self.systemUnderTest.responds(to: #selector(systemUnderTest.searchBarSearchButtonClicked(_:))))
        XCTAssertTrue(self.systemUnderTest.responds(to: #selector(systemUnderTest.searchBarCancelButtonClicked(_:))))
    }
    
    func testConformsToSearchResultsUpdatingProtocol() {
        XCTAssertTrue(self.systemUnderTest.responds(to: #selector(systemUnderTest.updateSearchResults(for:))))
    }
    
    func testFilteredContent() {
        systemUnderTest.csvDecoder.filteredContentForSearchText("car")
        XCTAssertEqual(systemUnderTest.csvDecoder.issues.count, 3)
        XCTAssertEqual(systemUnderTest.csvDecoder.issues[1].fullName, "Carl Jackson")
        
        systemUnderTest.csvDecoder.filteredContentForSearchText("carlo")
        XCTAssertEqual(systemUnderTest.csvDecoder.issues.count, 2)
        XCTAssertEqual(systemUnderTest.csvDecoder.issues[1].fullName, "Carlos Daly")
        
        systemUnderTest.csvDecoder.filteredContentForSearchText("carlos s")
        XCTAssertEqual(systemUnderTest.csvDecoder.issues.count, 1)
        XCTAssertEqual(systemUnderTest.csvDecoder.issues[0].fullName, "Carlos Soltero")
    }
    
    func testSearchBarCancel() {
        // simulate user typing in Search text and confirm results ...
        systemUnderTest.searchBarCancelButtonClicked(systemUnderTest.searchController.searchBar)
        XCTAssertEqual(systemUnderTest.csvDecoder.issues.count, 15)
        XCTAssertEqual(systemUnderTest.csvDecoder.issues[2].fullName, "Barry French")
    }
    
    func testNoSearchResultFound() {
        systemUnderTest.csvDecoder.filteredContentForSearchText("xavier")
        XCTAssertEqual(systemUnderTest.csvDecoder.issues.count, 0)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
