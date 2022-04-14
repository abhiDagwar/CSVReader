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
            fatalError("Error to create cell")
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

extension CsvReaderViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        if isFiltering {
            //load default array
            csvDecoder.filteredContentForSearchText(searchBar.text ?? "")
        } else {
            //load filtered array
            csvDecoder.getDefaultIssues()
        }
        
        csvDecoder.reloadTableView = { [weak self] in
            self?.csvTableView.reloadData()
        }
    }
}

extension CsvReaderViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchBar = searchController.searchBar
        if isFiltering {
            //load default array
            csvDecoder.filteredContentForSearchText(searchBar.text ?? "")
        } else {
            //load filtered array
            csvDecoder.getDefaultIssues()
        }
        
        csvDecoder.reloadTableView = { [weak self] in
            self?.csvTableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //load default array
        csvDecoder.getDefaultIssues()
        csvDecoder.reloadTableView = { [weak self] in
            self?.csvTableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchBar = searchController.searchBar
        if let searchBarText = searchBar.text, searchBarText.count > 0 {
            csvDecoder.filteredContentForSearchText(searchBar.text ?? "")
            //Reload tableview closure
            csvDecoder.reloadTableView = { [weak self] in
                self?.csvTableView.reloadData()
            }
        }
      searchBar.resignFirstResponder()
    }
}
