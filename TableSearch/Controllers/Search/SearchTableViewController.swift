//
//  SearchTableViewController.swift
//  TableSearch
//
//  Created by Lucas Nascimento on 02/03/20.
//  Copyright © 2020 Lucas Nascimento. All rights reserved.
//

import UIKit

internal class SearchTableViewController: UIViewController {
        
    // MARK: - Private Property
    
    private var products: [Product]? {
        didSet {
            updateView()
        }
    }
    
    // MARK: - Life Cicle
    
    internal init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    internal required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Methods
    
    internal override func loadView() {
        self.view = SearchTableView(frame: UIScreen.main.bounds)
    }
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureViewState()
        loadData()
    }
    
    // MARK: - Private methods
    
    private func configureViewState() {
        
    }
    
    private func configureNavigationBar() {
        
    }
    
    private func loadData() {
        products = DataSourceProvider().setupDataSource()
    }
    
    private func updateView() {
        
        if let view = self.view as? SearchTableView, let data = products {
            view.viewModel = SearchTableViewModel(products: data)
        }
    }
    
    // MARK: - Action Button
    
    @objc private func pressBackButton() {
        
    }
    
}
