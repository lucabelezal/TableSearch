//
//  MainTableViewController.swift
//  TableSearch
//
//  Created by Lucas Nascimento on 02/03/20.
//  Copyright © 2020 Lucas Nascimento. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var provider: DataSourceProvider = DataSourceProvider()
    
    lazy var viewModel: MainTableViewModelProtocol = {
        return MainTableViewModel(products: products)
    }()
    
    lazy var products: [Product] = {
        return provider.setupDataSource()
    }()
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: resultsTableController)
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
        return searchController
    }()
    
    lazy var resultsTableController: ResultsTableController = {
        let resultsTableController = ResultsTableController()
        resultsTableController.tableView.delegate = self
        return resultsTableController
    }()
    
    lazy var restoredState: SearchControllerRestorableState = {
        return SearchControllerRestorableState()
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
        registerCell()
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
    
    fileprivate func registerCell() {
        tableView.register(cellType: TableCellView.self)
    }
    
}

// MARK: - UITableViewDelegate

extension MainTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedProduct: Product
                
        if tableView === self.tableView {
            selectedProduct = viewModel.didSelectRowAt(indexPath)
        } else {
            selectedProduct = resultsTableController.viewModel.filteredProducts(indexPath.row)
        }
        
        let detailViewController = DetailViewController()
        detailViewController.viewModel = DetailViewModel(product: selectedProduct)
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
        return viewModel.titleForHeaderInSection(section)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableCellView = tableView.dequeueReusableCell(for: indexPath)
        cell.viewModel = TableCellViewModel(product: viewModel.cellForRowAt(indexPath))
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


