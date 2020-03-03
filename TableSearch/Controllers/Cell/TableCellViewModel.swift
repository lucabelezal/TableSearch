//
//  TableCellViewModel.swift
//  TableSearch
//
//  Created by Lucas Nascimento on 03/03/20.
//  Copyright © 2020 Lucas Nascimento. All rights reserved.
//

import UIKit

internal protocol TableCellViewModelProtocol {
    var text: String? { get }
    var detailText: String? { get }
}

internal struct TableCellViewModel: TableCellViewModelProtocol {

    internal var text: String?
    internal var detailText: String?

    internal init(text: String?, detailText: String?) {
        self.text = text
        self.detailText = detailText
    }

}

extension TableCellViewModel {
    
    init(product: Product) {
        let priceString: String? = product.formattedIntroPrice()
        
        self.text = product.title
        self.detailText = "\(priceString.unsafelyUnwrapped) | \(product.yearIntroduced)"
    }
}
