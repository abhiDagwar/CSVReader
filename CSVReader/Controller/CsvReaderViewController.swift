//
//  CsvReaderViewController.swift
//  CSVReader
//
//  Created by Siya Dagwar on 30/03/22.
//

import UIKit

class CsvReaderViewController: UIViewController {

    @IBOutlet weak var csvTableView: UITableView!
    @IBOutlet weak var csvStatusLable: UILabel!
    var csvDecoder = CsvDecoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let csv = CsvParser()
        csv.parseCSV(with: "issue") { (csv, error) in
            guard error == nil else {
                print(error?.localizedDescription as Any)
                showAlert(with: "Error", message: "Error parsing file.")
                return
            }

            guard let csv = csv else {
                return
            }

            csvDecoder.decodeCsvToObject(with: csv)
        }
    }
    
    fileprivate func showAlert(with title: String = "Alert", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension CsvReaderViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if csvDecoder.issues.count == 0 {
            showAlert(with: "Error", message: "No data found.")
        }
        return csvDecoder.issues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CsvTableViewCell", for: indexPath) as? CsvDetailsTableViewCell else {
            fatalError("Error to create a cell`")
        }
        
        let cellData = csvDecoder.getIssueCellView(at: indexPath)
        cell.issueCellModel = cellData
        
        return cell
    }
}

extension CsvReaderViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
