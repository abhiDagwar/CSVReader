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
    @IBOutlet weak var resultsLabel: UILabel!
    var csvDecoder = CsvDecoder()
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupSearchBar()
        
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
    
    func setupSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self
    }
    
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    fileprivate func filteredIssue(for searchText: String) {
        if isFiltering {
            //load default array
            csvDecoder.filteredContentForSearchText(searchText)
        } else {
            //load filtered array
            csvDecoder.getDefaultIssues()
        }
        
        reloadIssuesTable()
    }
    
    fileprivate func reloadIssuesTable() {
        csvDecoder.reloadTableView = { [weak self] in
            self?.csvTableView.reloadData()
        }
    }
    
    fileprivate func showAlert(with title: String = "Alert", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: TableViewDataSource
extension CsvReaderViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if csvDecoder.issues.count == 0 {
            //showAlert(with: "Error", message: "No data found.")
            resultsLabel.text = "No Issue Found"
        } else {
            if csvDecoder.issues.count == 1 {
                resultsLabel.text = "Found \(csvDecoder.issues.count) Issue"
            } else {
                resultsLabel.text = "Found \(csvDecoder.issues.count) Issues"
            }
        }
        
        return csvDecoder.issues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CsvTableViewCell", for: indexPath) as? CsvDetailsTableViewCell else {
            fatalError("Error to create cell")
        }
        
        let cellData = csvDecoder.getIssueCellView(at: indexPath)
        cell.issueCellModel = cellData
        
        return cell
    }
}

// MARK: TableViewDelegate
extension CsvReaderViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: SearchResultsUpdating
extension CsvReaderViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let searchText = searchBar.text ?? ""
        filteredIssue(for: searchText)
    }
}

// MARK: SearchBarDelegate
extension CsvReaderViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchBar = searchController.searchBar
        let searchText = searchBar.text ?? ""
        filteredIssue(for: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //load default array
        csvDecoder.getDefaultIssues()
        reloadIssuesTable()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchBar = searchController.searchBar
        if let searchBarText = searchBar.text, searchBarText.count > 0 {
            filteredIssue(for: searchBarText)
        }
      searchBar.resignFirstResponder()
    }
}
