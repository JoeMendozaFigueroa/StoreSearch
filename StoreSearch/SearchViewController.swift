//
//  ViewController.swift
//  StoreSearch
//
//  Created by Josue Mendoza on 9/24/21.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    var searchResults = [SearchResult]()
    var hasSearched = false


    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(
            top: 56,
            left: 0,
            bottom: 0,
            right: 0)
        //This local constant loads the "Search Result Cell" view
        var cellNib = UINib(nibName: TableView.CellIdentifiers.searchResultCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.searchResultCell)
        
        cellNib = UINib(nibName: TableView.CellIdentifiers.nothingFoundCell, bundle: nil)
        tableView.register(cellNib,forCellReuseIdentifier: TableView.CellIdentifiers.nothingFoundCell)
        
        searchBar.becomeFirstResponder()
    }
    //This method subtitutes the tableView cell with the custom ".XIB" files
    struct TableView {
        struct CellIdentifiers {
            static let searchResultCell = "SearchResultCell"
            static let nothingFoundCell = "NothingFoundCell"
        }
    }
    
    //This method is for the pop-up alert screen when there's no connection to the iTunes Store
    func showNetworkError() {
        let alert = UIAlertController(
            title: "Whoops...",
            message: "There was an error accessing the iTunes Store." +
            "Please try again.",
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    //MARK: - HELPER METHODS
    //This method reads from the ITunes URL
    func iTunesURL(searchText: String) -> URL {
        let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlString = String(format: "https://itunes.apple.com/search?term=%@", encodedText)
        let url = URL(string: urlString)
        return url!
    }
    
    //This method reads out the contents of the ITune URL
    func performStoreRequest(with url: URL) -> Data? {
        do {
            return try Data(contentsOf: url)
        } catch {
            print("Download Error: \(error.localizedDescription)")
            
            showNetworkError()
            return nil
        }
    }
    
    func parse(data: Data) -> [SearchResult] {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(
                ResultArray.self, from: data)
            return result.results
        } catch {
            print("JSON Error: \(error)")
            return []
        }
    }
}
//MARK: - SEARCH BAR DELEGATE
extension SearchViewController: UISearchBarDelegate {
    
    //This method shows the results from the search bar into the Table View Cell
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !searchBar.text!.isEmpty {
            searchBar.resignFirstResponder()
            
            hasSearched = true
            searchResults = []

            let url = iTunesURL(searchText: searchBar.text!)
            print("URL: '\(url)'")
            
            if let data = performStoreRequest(with: url) {
                searchResults = parse(data: data)
                
                //This sorts the items in alphabeticall order
                searchResults.sort(by: <)
            }
            tableView.reloadData()
        }

    }
    
    //This method extends the layout of the search bar to the top
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}


//MARK: - TABLE VIEW DELEGATE
//This method will handle all the tableView delegate methods
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !hasSearched {
            return 0
        } else if searchResults.count == 0 {
            return 1
        } else {
            return searchResults.count
        }
    }
    
    //This method enters the text inside the cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if searchResults.count == 0 {
            return tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.nothingFoundCell, for: indexPath)
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.searchResultCell, for: indexPath) as! SearchResultCell
            
            let searchResult = searchResults[indexPath.row]
            cell.nameLabel.text = searchResult.name
            if searchResult.artist.isEmpty {
                cell.artistNameLabel.text = "Unknown"
            } else { //This boolean places the item type next to the Artist Name
                cell.artistNameLabel.text = String(format: "%@ (%@)",
                                                   searchResult.artist,
                                                   searchResult.type)
            }
            return cell
        }
    }
    
    // LOOK AT THE NOTES FROM PREVIOUS PROJECTS FOR THE BOTTOM METHODS
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if searchResults.count == 0 {
            return nil
        } else {
            return indexPath
        }
    }
}

