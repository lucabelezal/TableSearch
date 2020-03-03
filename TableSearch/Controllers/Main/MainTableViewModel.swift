//
//  MainTableViewModel.swift
//  TableSearch
//
//  Created by Lucas Nascimento on 03/03/20.
//  Copyright © 2020 Lucas Nascimento. All rights reserved.
//

import Foundation

protocol MainTableViewModelProtocol {
    var titleForHeaderInSection: ((Int) -> String) { get }
    var numberOfRowsInSection: ((Int) -> Int) { get }
    var cellForRowAt: ((IndexPath) -> Product) { get }
    var didSelectRowAt: ((IndexPath) -> Product) { get }
}

struct MainTableViewModel: MainTableViewModelProtocol {
    
    var titleForHeaderInSection: ((Int) -> String)
    var numberOfRowsInSection: ((Int) -> Int)
    var cellForRowAt: ((IndexPath) -> Product)
    var didSelectRowAt: ((IndexPath) -> Product)
    
    init(products: [Product]) {
        titleForHeaderInSection = { MainTableViewModel.titleForHeaderInSection(section: $0, products: products) }
        numberOfRowsInSection = { MainTableViewModel.numberOfRowsIn(section: $0, products: products) }
        cellForRowAt = { MainTableViewModel.product(forIndexPath: $0, products: products) }
        didSelectRowAt = { MainTableViewModel.product(forIndexPath: $0, products: products) }
    }
    
}

extension MainTableViewModel {
    
    private static func titleForHeaderInSection(section: Int, products: [Product]) -> String {
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
    
    private static func numberOfRowsIn(section: Int, products: [Product]) -> Int {
        switch section {
        case 0:
            return MainTableViewModel.quantity(forType: Product.ProductType.birthdays, products: products)
        case 1:
            return MainTableViewModel.quantity(forType: Product.ProductType.weddings, products: products)
        case 2:
            return MainTableViewModel.quantity(forType: Product.ProductType.funerals, products: products)
        default:
            return 0
        }
    }
    
    private static func quantity(forType: Product.ProductType, products: [Product]) -> Int {
        var quantity = 0
        
        for product in products where product.type == forType.rawValue {
            quantity += 1
        }
        
        return quantity
    }
    
    private static func product(forIndexPath: IndexPath, products: [Product]) -> Product {
        
        let quantityForBirthdays = MainTableViewModel.quantity(forType: Product.ProductType.birthdays, products: products)
        
        switch forIndexPath.section {
        case Product.ProductType.birthdays.rawValue - 1:
            return products[forIndexPath.row]
            
        case Product.ProductType.weddings.rawValue - 1:
            return products[forIndexPath.row + quantityForBirthdays]
            
        case Product.ProductType.funerals.rawValue - 1:
            let quantityForWeddings = MainTableViewModel.quantity(forType: Product.ProductType.weddings, products: products)
            return products[forIndexPath.row + quantityForBirthdays + quantityForWeddings]
            
        default:
            return Product(title: String(), yearIntroduced: 0, introPrice: 0, type: .all)
        }
    }
    
}
