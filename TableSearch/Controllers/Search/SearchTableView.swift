//
//  SearchTableView.swift
//  TableSearch
//
//  Created by Lucas Nascimento on 02/03/20.
//  Copyright © 2020 Lucas Nascimento. All rights reserved.
//

import UIKit
import Common

internal class SearchTableView: UIView {
    
    // MARK: - Internal Properties
        
    internal var viewModel: SearchTableViewModelProtocol? {
        didSet {
            update()
        }
    }
    
    // MARK: - Private Properties
    
    private let contentView: UIView
    private let tableView: UITableView
    private var searchController: UISearchController
    private var resultsTableController: ResultsTableController
    private var restoredState: SearchControllerRestorableState
    
    // MARK: - Initialize Methods
    
    internal override init(frame: CGRect) {
        contentView = UIView()
        tableView = UITableView()
        resultsTableController = ResultsTableController()
        searchController = UISearchController(searchResultsController: resultsTableController)
        restoredState = SearchControllerRestorableState()
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func update() {
        self.tableView.reloadData()
    }
    
}

extension SearchTableView: ViewCodable {
    
    internal func configure() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: TableCellView.self)
        
        resultsTableController.tableView.delegate = self
        
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
    }
    
    internal func buildHierarchy() {
        contentView.addView(tableView)
        addView(contentView)
    }
    
    internal func buildConstraints() {
        
        contentView.layout.makeConstraints { make in
            make.top.equalTo(self.layout.top)
            make.bottom.equalTo(self.layout.bottom)
            make.left.equalTo(self.layout.left)
            make.right.equalTo(self.layout.right)
        }
        
        tableView.layout.makeConstraints { make in
            make.top.equalTo(contentView.layout.safeArea.top)
            make.bottom.equalTo(contentView.layout.safeArea.bottom)
            make.left.equalTo(contentView.layout.left)
            make.right.equalTo(contentView.layout.right)
        }
    }
    
    internal func render() {
        backgroundColor = .white
    }
    
}

// MARK: - UITableViewDelegate

extension SearchTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
}

// MARK: - UITableViewDataSource

extension SearchTableView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return searchController.searchBar.scopeButtonTitles!.count - 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
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
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numInSection = 0
        
        switch section {
        case 0:
            numInSection = viewModel?.quantity(Product.ProductType.birthdays) ?? 0
        case 1:
            numInSection = viewModel?.quantity(Product.ProductType.weddings) ?? 0
        case 2:
            numInSection = viewModel?.quantity(Product.ProductType.funerals) ?? 0
        default: break
        }
        
        return numInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableCellView = tableView.dequeueReusableCell(for: indexPath)
        
        let cellProduct = viewModel?.product(indexPath)
        let priceString = cellProduct?.formattedIntroPrice()
        
        let text = cellProduct?.title
        let detailText = "\(priceString!) | \(String(describing: cellProduct.unsafelyUnwrapped.yearIntroduced))"
        
        cell.viewModel = TableCellViewModel(text: text, detailText: detailText)
        return cell
    }
    
}

// MARK: - UISearchBarDelegate

extension SearchTableView: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        //updateSearchResults(for: searchController)
    }
    
}

// MARK: - UISearchControllerDelegate

extension SearchTableView: UISearchControllerDelegate {
    
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

extension SearchTableView {
    
    /// State restoration values.
    enum RestorationKeys: String {
        case viewControllerTitle
        case searchControllerIsActive
        case searchBarText
        case searchBarIsFirstResponder
        case selectedScope
    }
    
    // State items to be restored in viewDidAppear().
    struct SearchControllerRestorableState {
        var wasActive = false
        var wasFirstResponder = false
    }
    
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        
        // Encode the view state so it can be restored later.
        
        // Encode the title.
        //coder.encode(navigationItem.title!, forKey: RestorationKeys.viewControllerTitle.rawValue)

        // Encode the search controller's active state.
        coder.encode(searchController.isActive, forKey: RestorationKeys.searchControllerIsActive.rawValue)
        
        // Encode the first responser status.
        coder.encode(searchController.searchBar.isFirstResponder, forKey: RestorationKeys.searchBarIsFirstResponder.rawValue)
        
        // Encode the first responser status.
        coder.encode(searchController.searchBar.selectedScopeButtonIndex, forKey: RestorationKeys.selectedScope.rawValue)
        
        // Encode the search bar text.
        coder.encode(searchController.searchBar.text, forKey: RestorationKeys.searchBarText.rawValue)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        
        // Restore the title.
        guard let decodedTitle = coder.decodeObject(forKey: RestorationKeys.viewControllerTitle.rawValue) as? String else {
            fatalError("A title did not exist. In your app, handle this gracefully.")
        }
        //navigationItem.title! = decodedTitle
        
        /** Restore the active and first responder state:
            We can't make the searchController active here since it's not part of the view hierarchy yet, instead we do it in viewDidAppear.
        */
        restoredState.wasActive = coder.decodeBool(forKey: RestorationKeys.searchControllerIsActive.rawValue)
        restoredState.wasFirstResponder = coder.decodeBool(forKey: RestorationKeys.searchBarIsFirstResponder.rawValue)
        
        // Restore the scope bar selection.
        searchController.searchBar.selectedScopeButtonIndex = coder.decodeInteger(forKey: RestorationKeys.selectedScope.rawValue)
        
        // Restore the text in the search field.
        searchController.searchBar.text = coder.decodeObject(forKey: RestorationKeys.searchBarText.rawValue) as? String
    }
    
}

extension SearchTableView: UISearchResultsUpdating {
    
    private func findMatches(searchString: String) -> NSCompoundPredicate {
        /** Each searchString creates an OR predicate for: name, yearIntroduced, introPrice.
            Example if searchItems contains "Gladiolus 51.99 2001":
                name CONTAINS[c] "gladiolus"
                name CONTAINS[c] "gladiolus", yearIntroduced ==[c] 2001, introPrice ==[c] 51.99
                name CONTAINS[c] "ginger", yearIntroduced ==[c] 2007, introPrice ==[c] 49.98
        */
        var searchItemsPredicate = [NSPredicate]()
        
        /** Below we use NSExpression represent expressions in our predicates.
            NSPredicate is made up of smaller, atomic parts:
            two NSExpressions (a left-hand value and a right-hand value).
        */
        
        // Product title matching.
        let titleExpression = NSExpression(forKeyPath: Product.ExpressionKeys.title.rawValue)
        let searchStringExpression = NSExpression(forConstantValue: searchString)
        
        let titleSearchComparisonPredicate =
        NSComparisonPredicate(leftExpression: titleExpression,
                              rightExpression: searchStringExpression,
                              modifier: .direct,
                              type: .contains,
                              options: [.caseInsensitive, .diacriticInsensitive])
        
        searchItemsPredicate.append(titleSearchComparisonPredicate)
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .none
        numberFormatter.formatterBehavior = .default
        
        // The `searchString` may fail to convert to a number.
        if let targetNumber = numberFormatter.number(from: searchString) {
            // Use `targetNumberExpression` in both the following predicates.
            let targetNumberExpression = NSExpression(forConstantValue: targetNumber)
            
            // The `yearIntroduced` field matching.
            let yearIntroducedExpression = NSExpression(forKeyPath: Product.ExpressionKeys.yearIntroduced.rawValue)
            let yearIntroducedPredicate =
                NSComparisonPredicate(leftExpression: yearIntroducedExpression,
                                      rightExpression: targetNumberExpression,
                                      modifier: .direct,
                                      type: .equalTo,
                                      options: [.caseInsensitive, .diacriticInsensitive])
            
            searchItemsPredicate.append(yearIntroducedPredicate)
            
            // The `price` field matching.
            let lhs = NSExpression(forKeyPath: Product.ExpressionKeys.introPrice.rawValue)
            
            let finalPredicate =
                NSComparisonPredicate(leftExpression: lhs,
                                      rightExpression: targetNumberExpression,
                                      modifier: .direct,
                                      type: .equalTo,
                                      options: [.caseInsensitive, .diacriticInsensitive])
            
            searchItemsPredicate.append(finalPredicate)
        }
                
        var finalCompoundPredicate: NSCompoundPredicate!
    
        // Handle the scoping.
        let selectedScopeButtonIndex = searchController.searchBar.selectedScopeButtonIndex
        if selectedScopeButtonIndex > 0 {
            // We have a scope type to narrow our search further.
            if !searchItemsPredicate.isEmpty {
                /** We have a scope type and other fields to search on -
                    so match up the fields of the Product object AND its product type.
                */
                let compPredicate1 = NSCompoundPredicate(orPredicateWithSubpredicates: searchItemsPredicate)
                let compPredicate2 = NSPredicate(format: "(SELF.type == %ld)", selectedScopeButtonIndex)

                finalCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [compPredicate1, compPredicate2])
            } else {
                // Match up by product scope type only.
                finalCompoundPredicate = NSCompoundPredicate(format: "(SELF.type == %ld)", selectedScopeButtonIndex)
            }
        } else {
            // No scope type specified, just match up the fields of the Product object
            finalCompoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: searchItemsPredicate)
        }

        //Swift.debugPrint("search predicate = \(String(describing: finalCompoundPredicate))")
        return finalCompoundPredicate
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        // Update the filtered array based on the search text.
        let searchResults = viewModel.unsafelyUnwrapped.products

        // Strip out all the leading and trailing spaces.
        let whitespaceCharacterSet = CharacterSet.whitespaces
        let strippedString =
            searchController.searchBar.text!.trimmingCharacters(in: whitespaceCharacterSet)
        let searchItems = strippedString.components(separatedBy: " ") as [String]

        // Build all the "AND" expressions for each value in searchString.
        let andMatchPredicates: [NSPredicate] = searchItems.map { searchString in
            findMatches(searchString: searchString)
        }

        // Match up the fields of the Product object.
        let finalCompoundPredicate =
            NSCompoundPredicate(andPredicateWithSubpredicates: andMatchPredicates)

        let filteredResults = searchResults.filter { finalCompoundPredicate.evaluate(with: $0) }

        // Apply the filtered results to the search results table.
        if let resultsController = searchController.searchResultsController as? ResultsTableController {
            resultsController.viewModel = ResultsTableViewModel(filteredProducts: filteredResults)
        }
    }
    
}
