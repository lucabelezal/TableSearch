//
//  SearchTableViewModel.swift
//  TableSearch
//
//  Created by Lucas Nascimento on 02/03/20.
//  Copyright © 2020 Lucas Nascimento. All rights reserved.
//

import UIKit

internal protocol SearchTableViewModelProtocol {
    var numberOfSections: Int { get }
    var numberOfRowsInSection: Int { get }
    var products: [Product] { get }
    var product: (_ forIndexPath: IndexPath) -> Product { get }
    var quantity: (_ forType: Product.ProductType) -> Int { get }
}

internal struct SearchTableViewModel: SearchTableViewModelProtocol {
 
    internal var numberOfSections: Int
    internal var numberOfRowsInSection: Int
    internal var products: [Product]
    internal var product: (IndexPath) -> Product
    internal var quantity: (Product.ProductType) -> Int
    
    internal init(products: [Product]) {
        self.numberOfSections = products.count
        self.numberOfRowsInSection = products.count
        self.products = products
        
        self.quantity = { forType in
            var quantity = 0
            
            for product in products where product.type == forType.rawValue {
                quantity += 1
            }
            
            return quantity
        }
        
        self.product = { forIndexPath in
            
            var product: Product!
                    
            let quantityForBirthdays = SearchTableView.quantity(forType: Product.ProductType.birthdays, products: products)

            switch forIndexPath.section {
            case Product.ProductType.birthdays.rawValue - 1:
                product = products[forIndexPath.row]
                
            case Product.ProductType.weddings.rawValue - 1:
                product = products[forIndexPath.row + quantityForBirthdays]
                
            case Product.ProductType.funerals.rawValue - 1:
                let quantityForWeddings = SearchTableView.quantity(forType: Product.ProductType.weddings, products: products)
                product = products[forIndexPath.row + quantityForBirthdays + quantityForWeddings]
                
            default: break
            }
            
            return product
        }
    }
    
}

extension SearchTableView {
    
    static func quantity(forType: Product.ProductType, products: [Product]) -> Int {
        var quantity = 0
        for product in products
            where product.type == forType.rawValue {
                quantity += 1
        }
        return quantity
    }
    
}
