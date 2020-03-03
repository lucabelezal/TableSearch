//
//  ResultsTableController.swift
//  TableSearch
//
//  Created by Lucas Nascimento on 02/03/20.
//  Copyright © 2020 Lucas Nascimento. All rights reserved.
//

import Common
import UIKit

class ResultsTableController: UITableViewController {
        
    // MARK: - Properties
    
    var viewModel: ResultsTableViewModelProtocol {
        didSet {
            updateView()
        }
    }
    
    private var tableHeaderView: UIView
    private var resultsLabel: UILabel
    
    // MARK: - Initialization
    
    override init(style: UITableView.Style = .plain) {
        tableHeaderView = UIView()
        resultsLabel = UILabel()
        viewModel = ResultsTableViewModel()
        super.init(style: style)
    }
         
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        registerTableCell()
    }
    
    func registerTableCell() {
        tableView.register(cellType: TableCellView.self)
    }
    
    func updateView() {
        resultsLabel.text = viewModel.resultsText
        tableView.reloadData()
    }
    
}

// MARK: - UITableViewDataSource

extension ResultsTableController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredItems
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableCellView = tableView.dequeueReusableCell(for: indexPath)
        cell.viewModel = TableCellViewModel(product: viewModel.filteredProducts(indexPath.row))
        return cell
    }
}

extension ResultsTableController: ViewCodable {
        
    func configure() {
        tableView.delegate = self
        tableView.dataSource = self
        resultsLabel.textAlignment = .center
    }
    
    func buildHierarchy() {
        view.addView(tableHeaderView)
        tableHeaderView.addView(resultsLabel)
        tableView.tableHeaderView = tableHeaderView
    }
    
    func buildConstraints() {
        
        tableHeaderView.layout.makeConstraints { make in
            make.height.equalTo(constant: 44)
            make.width.equalTo(constant: tableView.bounds.width)
        }
        
        resultsLabel.layout.makeConstraints { make in
            make.height.equalTo(constant: 21)
            make.centerY.equalTo(tableHeaderView.layout.centerY)
            make.centerX.equalTo(tableHeaderView.layout.centerX)
        }
    }
    
    func render() {
        tableView.tableHeaderView?.backgroundColor = .secondarySystemBackground
    }
    
    func configureAccessibility() {
        
    }
    
}
