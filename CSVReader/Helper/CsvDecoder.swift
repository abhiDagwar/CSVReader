//
//  CsvDecoder.swift
//  CSVReader
//
//  Created by Siya Dagwar on 31/03/22.
//

import Foundation

class CsvDecoder {
    var reloadTableView: (() -> Void)?
    var issues = Issues() {
        didSet {
            reloadTableView?()
        }
    }
    var defaultIssues: Issues = []
    var filteredIssues: Issues = []
    
    private func formatteDateOfBirth(from dateString: String, dateFormateString: String = "d MMM yyyy, h:mm a") -> String? {
        
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date = dateFormatter.date(from: dateString)
        
        guard date != nil else {
            assert(false, "no date found from string")
            return nil
        }
        
        dateFormatter.dateFormat = dateFormateString
        dateFormatter.locale = tempLocale // reset the locale
        let dateString = dateFormatter.string(from: date!)
        print("EXACT_DATE : \(dateString)")
        return dateString
    }
    
    func decodeCsvToObject(with csvArray: [[String]]?) {
        guard let csvArray = csvArray else {
            return
        }

        var issuesData = Issues()
        for row in csvArray {
            if !row.isEmpty {
                print(row)
                print(row.count)
                let firstName = row[0]
                let lastName = row[1]
                let issueCount = row[2]
                let dateOfBirth = row[3]
                var fullName = ""
                if !(firstName.isEmpty) && !(lastName.isEmpty) {
                    fullName = firstName + " " + lastName
                } else if (firstName.isEmpty) && !(lastName.isEmpty) {
                    fullName = lastName
                } else if !(firstName.isEmpty) && (lastName.isEmpty) {
                    fullName = firstName
                } else {
                    fullName = "-"
                }
                
                let formattedDateOfBirth = formatteDateOfBirth(from: dateOfBirth) ?? dateOfBirth
            
                issuesData.append(Issue(fullName: fullName, issueCount: issueCount, dateOfBirth: formattedDateOfBirth))
            }
            defaultIssues = issuesData
            issues = issuesData
        }
    }
    
    func getDefaultIssues() {
        issues = defaultIssues
    }
    
    func getIssuesSectionCount() -> Int {
        return 1
    }
    
    func getIssuesRowCount() -> Int {
        return issues.count
    }
    
    func filteredContentForSearchText(_ searchText: String) {
        filteredIssues = issues.filter { (issue: Issue) -> Bool in
            return issue.fullName.lowercased().contains(searchText.lowercased())
        }
        
        issues = filteredIssues
    }
    
    func getIssueCellView(at indexPath: IndexPath) -> Issue {
        return issues[indexPath.row]
    }
}