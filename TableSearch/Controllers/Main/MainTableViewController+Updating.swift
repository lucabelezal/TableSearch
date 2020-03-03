//
//  MainTableViewController+Updating.swift
//  TableSearch
//
//  Created by Lucas Nascimento on 02/03/20.
//  Copyright © 2020 Lucas Nascimento. All rights reserved.
//

import UIKit

extension MainTableViewController: UISearchResultsUpdating {
    
    private func findMatches(searchString: String) -> NSCompoundPredicate {
        
        var searchItemsPredicate = [NSPredicate]()
        
        let titleExpression = NSExpression(forKeyPath: Product.ExpressionKeys.title.rawValue)
        let searchStringExpression = NSExpression(forConstantValue: searchString)
        
        let titleSearchComparisonPredicate = NSComparisonPredicate(leftExpression: titleExpression,
                                                                   rightExpression: searchStringExpression,
                                                                   modifier: .direct,
                                                                   type: .contains,
                                                                   options: [.caseInsensitive, .diacriticInsensitive])
        
        searchItemsPredicate.append(titleSearchComparisonPredicate)
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .none
        numberFormatter.formatterBehavior = .default
        
        if let targetNumber = numberFormatter.number(from: searchString) {
            
            let targetNumberExpression = NSExpression(forConstantValue: targetNumber)
            
            let yearIntroducedExpression = NSExpression(forKeyPath: Product.ExpressionKeys.yearIntroduced.rawValue)
            
            let yearIntroducedPredicate = NSComparisonPredicate(leftExpression: yearIntroducedExpression,
                                                                rightExpression: targetNumberExpression,
                                                                modifier: .direct,
                                                                type: .equalTo,
                                                                options: [.caseInsensitive, .diacriticInsensitive])
            
            searchItemsPredicate.append(yearIntroducedPredicate)
            
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
        
        let selectedScopeButtonIndex = searchController.searchBar.selectedScopeButtonIndex
        if selectedScopeButtonIndex > 0 {
            
            if !searchItemsPredicate.isEmpty {
                let compPredicate1 = NSCompoundPredicate(orPredicateWithSubpredicates: searchItemsPredicate)
                let compPredicate2 = NSPredicate(format: "(SELF.type == %ld)", selectedScopeButtonIndex)
                
                finalCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [compPredicate1, compPredicate2])
            } else {
                finalCompoundPredicate = NSCompoundPredicate(format: "(SELF.type == %ld)", selectedScopeButtonIndex)
            }
        } else {
            finalCompoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: searchItemsPredicate)
        }
        
        //Swift.debugPrint("search predicate = \(String(describing: finalCompoundPredicate))")
        return finalCompoundPredicate
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchResults = products
        
        let whitespaceCharacterSet = CharacterSet.whitespaces
        let strippedString = searchController.searchBar.text!.trimmingCharacters(in: whitespaceCharacterSet)
        let searchItems = strippedString.components(separatedBy: " ") as [String]
        
        let andMatchPredicates: [NSPredicate] = searchItems.map { searchString in
            findMatches(searchString: searchString)
        }
        
        let finalCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: andMatchPredicates)
        
        let filteredResults = searchResults.filter { finalCompoundPredicate.evaluate(with: $0) }
        
        if let resultsController = searchController.searchResultsController as? ResultsTableController {
            resultsController.viewModel = ResultsTableViewModel(filtered: filteredResults)
        }
    }
    
}
