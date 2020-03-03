//
//  DetailViewModel.swift
//  TableSearch
//
//  Created by Lucas Nascimento on 03/03/20.
//  Copyright © 2020 Lucas Nascimento. All rights reserved.
//

import Foundation

protocol DetailViewModelProtocol {
    var title: String? { get }
    var yearText: String? { get }
    var priceText: String? { get }
    var product: Product { get }
}

struct DetailViewModel: DetailViewModelProtocol {
    
    var yearText: String?
    var priceText: String?
    var title: String?
    var product: Product
    
    init(product: Product) {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.formatterBehavior = .default
        let priceString = numberFormatter.string(from: NSNumber(value: product.introPrice))
        self.priceText = priceString
        self.yearText = "\(product.yearIntroduced)"
        self.title = product.title
        self.product = product
    }
    
}
