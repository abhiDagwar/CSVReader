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
    private let dateFormatter: DateFormatter = {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "EEEE, MMM d"
      return dateFormatter
    }()
    
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
                
            
                issuesData.append(Issue(fullName: fullName, issueCount: issueCount, issueDate: dateOfBirth))
            }
            issues = issuesData
        }
    }
}
