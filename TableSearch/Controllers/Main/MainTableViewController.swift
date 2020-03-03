//
//  MainTableViewController.swift
//  TableSearch
//
//  Created by Lucas Nascimento on 02/03/20.
//  Copyright © 2020 Lucas Nascimento. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    let tableViewCellIdentifier = "cellID"
    
    // MARK: - Properties
    
    var products = [Product]()
    var searchController: UISearchController!
    var resultsTableController: ResultsTableController!
    var restoredState = SearchControllerRestorableState()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        let nib = UINib(nibName: "TableCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: tableViewCellIdentifier)
        
        resultsTableController = storyboard?.instantiateViewController(withIdentifier: "ResultsTableController") as? ResultsTableController
        resultsTableController.tableView.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsTableController)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.scopeButtonTitles = [
            Product.productTypeName(forType: .all),
            Product.productTypeName(forType: .birthdays),
            Product.productTypeName(forType: .weddings),
            Product.productTypeName(forType: .funerals)
        ]


        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
        setupDataSource()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if restoredState.wasActive {
            searchController.isActive = restoredState.wasActive
            restoredState.wasActive = false
            
            if restoredState.wasFirstResponder {
                searchController.searchBar.becomeFirstResponder()
                restoredState.wasFirstResponder = false
            }
        }
    }

}

// MARK: - UITableViewDelegate

extension MainTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedProduct: Product!
        
        if tableView === self.tableView {
            selectedProduct = product(forIndexPath: indexPath)
        } else {
            selectedProduct = resultsTableController.filteredProducts[indexPath.row]
        }
        
        let detailViewController = DetailViewController.detailViewControllerForProduct(selectedProduct)
        navigationController?.pushViewController(detailViewController, animated: true)

        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}

// MARK: - UITableViewDataSource

extension MainTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return searchController.searchBar.scopeButtonTitles!.count - 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String {
        var title = ""
        switch section {
        case 0:
            title = Product.productTypeName(forType: .birthdays)
        case 1:
            title = Product.productTypeName(forType: .weddings)
        case 2:
            title = Product.productTypeName(forType: .funerals)
        default: break
        }
        return title
    }
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numInSection = 0
        switch section {
        case 0:
            numInSection = quantity(forType: Product.ProductType.birthdays)
        case 1:
            numInSection = quantity(forType: Product.ProductType.weddings)
        case 2:
            numInSection = quantity(forType: Product.ProductType.funerals)
        default: break
        }
        return numInSection
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentifier, for: indexPath)
        let cellProduct = product(forIndexPath: indexPath)
        
        cell.textLabel?.text = cellProduct.title
        
        let priceString = cellProduct.formattedIntroPrice()
        cell.detailTextLabel?.text = "\(priceString!) | \(cellProduct.yearIntroduced)"
        
        return cell
    }
    
}

// MARK: - UISearchBarDelegate

extension MainTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        updateSearchResults(for: searchController)
    }
    
}

// MARK: - UISearchControllerDelegate

extension MainTableViewController: UISearchControllerDelegate {
    
    func presentSearchController(_ searchController: UISearchController) {
        //Swift.debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        //Swift.debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        //Swift.debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        //Swift.debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        //Swift.debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }
    
}


