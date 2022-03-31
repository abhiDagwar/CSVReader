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
            
                issuesData.append(Issue(firstName: firstName, lastName: lastName, issueCount: issueCount, issueDate: dateOfBirth))
            }
            issues = issuesData
        }
    }
}
