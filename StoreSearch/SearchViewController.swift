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
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    private let search = Search()
    var landscapeVC: LandscapeViewController?

    //*/This method subtitutes the tableView cell with the custom ".XIB" files*/
    struct TableView {
        struct CellIdentifiers {
            static let searchResultCell = "SearchResultCell"
            static let nothingFoundCell = "NothingFoundCell"
            static let loadingCell = "LoadingCell"
        }
    }
    //*/The syntex inside this method is the culmination of all the classes, methods, & variables, that come together to create the Main ViewController*/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 94,left: 0,bottom: 0,right: 0)
        //*/This local constant loads the "Search Result Cell" view*/
        var cellNib = UINib(nibName: TableView.CellIdentifiers.searchResultCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.searchResultCell)
        
        cellNib = UINib(nibName: TableView.CellIdentifiers.nothingFoundCell, bundle: nil)
        tableView.register(cellNib,forCellReuseIdentifier: TableView.CellIdentifiers.nothingFoundCell)
        
        cellNib = UINib(nibName: TableView.CellIdentifiers.loadingCell, bundle: nil)
        tableView.register(cellNib,forCellReuseIdentifier: TableView.CellIdentifiers.loadingCell)

        searchBar.becomeFirstResponder()
    }
    
    //MARK: - ACTIONS
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        performSearch()
    }
    //MARK: - HELPER METHODS
    //*/This method is for the pop-up alert screen when there's no connection to the iTunes Store*/
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
    
    //This method occurs when user places phone into Landscape mode & Landscape view controller appears
    func showLandscape(with coordinator: UIViewControllerTransitionCoordinator) {
        //1
        guard landscapeVC == nil else { return }
        //2
        landscapeVC = storyboard!.instantiateViewController(withIdentifier: "LandscapeViewController") as?
        LandscapeViewController
        if let controller = landscapeVC {
            controller.search = search
            controller.view.frame = view.bounds
            controller.view.alpha = 0
            //4
            view.addSubview(controller.view)
            addChild(controller)
            coordinator.animate(alongsideTransition: {_ in controller.view.alpha = 1
                self.searchBar.resignFirstResponder() //This syntax hides the keyboard, when useer rotates device
                if self.presentedViewController != nil {
                    self.dismiss(animated: true, completion: nil)
                }
            }, completion: {_ in controller.didMove(toParent: self)
                
            })
        }
    }
    //This method occurs when user places phone back to vertical mode & Landscape view controller disappears
    func hideLandscape(with coordinator: UIViewControllerTransitionCoordinator) {
        if let controller = landscapeVC {
            controller.willMove(toParent: nil)
            coordinator.animate(alongsideTransition: {_ in controller.view.alpha = 0}, completion: {_ in controller.view.removeFromSuperview()
                controller.removeFromParent()
                self.landscapeVC = nil
            })
        }
    }
    
    //MARK: - NAVIGATION
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            //These constants populate the labels wit the information from the URL search
            let detailViewController = segue.destination as! DetailViewController
            let indexPath = sender as! IndexPath
            let searchResult = search.searchResults[indexPath.row]
            detailViewController.searchResult = searchResult
            
            segue.destination.modalPresentationStyle = .overFullScreen
        }
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        switch newCollection.verticalSizeClass {
        case .compact:
            showLandscape(with: coordinator)
        case .regular, .unspecified:
            hideLandscape(with: coordinator)
        @unknown default:
            break
        }
    }
    

}
//MARK: - SEARCH BAR DELEGATE
extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        performSearch()
    }

    func performSearch() {
        search.performSearch(
            for: searchBar.text!,
            category: segmentedControl.selectedSegmentIndex) {
            success in
            if !success {
                self.showNetworkError()
            }
            self.tableView.reloadData()
        }
        
        tableView.reloadData()
        searchBar.resignFirstResponder()
    }
    
    
    //*/This method extends the layout of the search bar to the top*/
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
}

//MARK: - TABLE VIEW DELEGATE
//*/This method will handle all the tableView delegate methods*/
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if search.isLoading {
            return 1 //Loading...
        } else if !search.hasSearched {
            return 0 //Not searched yet
        } else if search.searchResults.count == 0 {
            return 1 //Nothing found
        } else {
            return search.searchResults.count
        }
    }
    
    //*/This method enters the text inside the cells*/
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if search.isLoading {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.loadingCell, for: indexPath)
            
            let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
            spinner.startAnimating()
            return cell
        } else if search.searchResults.count == 0 {
            return tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.nothingFoundCell, for: indexPath)
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.searchResultCell, for: indexPath) as! SearchResultCell
            
            let searchResult = search.searchResults[indexPath.row]
            cell.configure(for: searchResult)
            return cell
        }
    }
    
    //This methods occurs when a user selects on a row.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //Added following
        performSegue(withIdentifier: "ShowDetail", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if search.searchResults.count == 0 || search.isLoading {
            return nil
        } else {
            return indexPath
        }
    }
}

