//
//  DetailViewController.swift
//  TableSearch
//
//  Created by Lucas Nascimento on 02/03/20.
//  Copyright © 2020 Lucas Nascimento. All rights reserved.
//

import Common
import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - Properties

    private static let restoreProduct = "restoreProductKey"
    
    var product: Product? {
        didSet {
            updateView()
        }
    }
    
    var contentView: UIView = UIView()
    var yearTitleLabel: UILabel = UILabel()
    var priceTitleLabel: UILabel = UILabel()
    var yearLabel: UILabel = UILabel()
    var priceLabel: UILabel = UILabel()
    
    // MARK: - Initialization
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(product: Product) {
        self.init()
        self.product = product
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    // MARK: - View Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupView()
    }
    
    func updateView() {
        if let product = self.product {
            
            title = product.title
            
            yearLabel.text = "\(product.yearIntroduced)"
            
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .currency
            numberFormatter.formatterBehavior = .default
            let priceString = numberFormatter.string(from: NSNumber(value: product.introPrice))
            priceLabel.text = priceString
        }
    }
    
}

// MARK: - UIStateRestoration

extension DetailViewController {
    
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        
        coder.encode(product, forKey: DetailViewController.restoreProduct)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        
        if let decodedProduct = coder.decodeObject(forKey: DetailViewController.restoreProduct) as? Product {
            product = decodedProduct
        } else {
            fatalError("A product did not exist. In your app, handle this gracefully.")
        }
    }
    
}

extension DetailViewController: ViewCodable {
    
    func configure() {
        yearTitleLabel.text = "Year:"
        priceTitleLabel.text = "Price:"
        yearLabel.text = "Text"
        priceLabel.text = "Text"
    }
    
    func buildHierarchy() {
        contentView.addView(yearTitleLabel, priceTitleLabel, yearLabel, priceLabel)
        view.addView(contentView)
    }
    
    func buildConstraints() {
        
        contentView.layout.makeConstraints { make in
            make.top.equalTo(view.layout.top)
            make.bottom.equalTo(view.layout.bottom)
            make.left.equalTo(view.layout.left)
            make.right.equalTo(view.layout.right)
        }
        
        yearTitleLabel.layout.makeConstraints { make in
            make.top.equalTo(contentView.layout.safeArea.top, constant: 16)
            make.left.equalTo(contentView.layout.left, constant: 16)
        }
        
        yearLabel.layout.makeConstraints { make in
            make.top.equalTo(contentView.layout.safeArea.top, constant: 16)
            make.left.equalTo(yearTitleLabel.layout.right, constant: 16)
            make.right.lessThanOrEqualTo(contentView.layout.right, constant: -16)
        }
        
        priceTitleLabel.layout.makeConstraints { make in
            make.top.equalTo(yearTitleLabel.layout.bottom, constant: 16)
            make.left.equalTo(contentView.layout.left, constant: 16)
        }
                
        priceLabel.layout.makeConstraints { make in
            make.top.equalTo(yearLabel.layout.bottom, constant: 16)
            make.left.equalTo(priceTitleLabel.layout.right, constant: 16)
            make.right.lessThanOrEqualTo(contentView.layout.right, constant: -16)
        }
        
    }
    
    func render() {
        view.backgroundColor = .white
    }
    
    func configureAccessibility() {
        
    }
    
}
