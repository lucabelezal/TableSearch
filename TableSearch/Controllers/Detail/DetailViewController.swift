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
    
    private var product: Product?
    
    var viewModel: DetailViewModelProtocol? {
        didSet {
            updateView()
        }
    }
    
    private var contentView: UIView = UIView()
    private var yearTitleLabel: UILabel = UILabel()
    private var priceTitleLabel: UILabel = UILabel()
    private var yearLabel: UILabel = UILabel()
    private var priceLabel: UILabel = UILabel()
    
    // MARK: - Initialization
    
    init() {
        super.init(nibName: nil, bundle: nil)
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
        if let model = viewModel {
            title = model.title
            yearLabel.text = model.yearText
            priceLabel.text = model.priceText
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
