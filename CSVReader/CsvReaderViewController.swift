//
//  CsvReaderViewController.swift
//  CSVReader
//
//  Created by Siya Dagwar on 30/03/22.
//

import UIKit

class CsvReaderViewController: UIViewController {

    @IBOutlet weak var csvTableView: UITableView!
    var csvDecoder = CsvDecoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let csv = CsvParser()
        csv.parseCSV(with: "issue") { csv, error in
            guard error == nil else {
                print(error?.localizedDescription as Any)
                return
            }

            guard let csv = csv else {
                return
            }

            csvDecoder.decodeCsvToObject(with: csv)
        }
    }
}

extension CsvReaderViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return csvDecoder.issues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CsvTableView", for: indexPath)
        
        let cellData = csvDecoder.issues[indexPath.row]
        cell.textLabel?.text = cellData.firstName
        cell.detailTextLabel?.text = cellData.lastName
        
        return cell
    }
    
    
}
