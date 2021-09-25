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
    }

}
//MARK: - SEARCH BAR DELEGATE
extension SearchViewController: UISearchBarDelegate {
    //This method shows the results from the search bar into the Table View Cell
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchResults = []
        if searchBar.text! != "justin bieber" {
        for i in 0...2 {
            let searchResult = SearchResult()
            searchResult.name = String( format: "Fake Result %d for", i)
                searchResult.artistName = searchBar.text!
                searchResults.append(searchResult)
        }
    }
        hasSearched = true
        tableView.reloadData()
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
        let cellIdentifier = "SearchResultCell"
        
        var cell: UITableViewCell! = tableView.dequeueReusableCell(
            withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(
                style: .subtitle, reuseIdentifier: cellIdentifier)
        }
        //This boolean places text inside the cell where there is not search results
        if searchResults.count == 0 {
            cell.textLabel!.text = "(Nothing found)"
            cell.detailTextLabel!.text = ""
        } else {
            let searchResult = searchResults[indexPath.row]
            cell.textLabel!.text = searchResult.name
            cell.detailTextLabel!.text = searchResult.artistName
        }
        return cell
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

