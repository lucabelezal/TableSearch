//
//  ResultsTableViewModel.swift
//  TableSearch
//
//  Created by Lucas Nascimento on 03/03/20.
//  Copyright © 2020 Lucas Nascimento. All rights reserved.
//

import Foundation

protocol ResultsTableViewModelProtocol {
    var filteredItems: Int { get }
    var resultsText: String { get }
    var filteredProducts: ((Int) -> Product) { get }
}

struct ResultsTableViewModel: ResultsTableViewModelProtocol {
    
    var filteredItems: Int
    var resultsText: String
    var filteredProducts: ((Int) -> Product)
    
    init() {
        filteredItems = 0
        resultsText = String()
        filteredProducts = { _ in return Product(title: String(), yearIntroduced: 0, introPrice: 0, type: .all) }
    }
    
    init(filtered products: [Product]) {
        let successText = String(format: NSLocalizedString("Items found: %ld", comment: ""), products.count)
        let failureText = NSLocalizedString("NoItemsFoundTitle", comment: "")
        
        resultsText = products.isEmpty ? failureText : successText
        filteredItems = products.count
        filteredProducts = { products[$0] }
    }
}
