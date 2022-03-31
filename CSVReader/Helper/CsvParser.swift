//
//  CsvParser.swift
//  CSVReader
//
//  Created by Siya Dagwar on 31/03/22.
//

import Foundation

class CsvParser {
    func parseCSV(with fileName: String, completion: ([[String]]?, Error?) -> Void) {
        guard let csvPath = Bundle.main.path(forResource: fileName, ofType: "csv") else { return }

        do {
            let csvData = try String(contentsOfFile: csvPath, encoding: String.Encoding.utf8)
            let csv = csv(data: csvData)
            print(csv.count)
            completion(csv, nil)
        } catch{
            completion(nil, error)
            print(error)
        }
    }
    
    private func csv(data: String) -> [[String]] {
        var result: [[String]] = []
        let rows = data.components(separatedBy: "\n").dropFirst(1)
        for row in rows {
            let columns = row.components(separatedBy: ",")
            if columns.count >= 4 {
                let newArray = Array(columns[0...3])
                result.append(newArray)
            }
        }
        return result
    }
}
