//
//  ResultsTableController.swift
//  TableSearch
//
//  Created by Lucas Nascimento on 02/03/20.
//  Copyright © 2020 Lucas Nascimento. All rights reserved.
//

import UIKit

protocol ResultsTableViewModelProtocol {
    var filteredProducts: [Product] { get }
}

struct ResultsTableViewModel: ResultsTableViewModelProtocol {
    
    var filteredProducts: [Product]
    
    init() {
        self.filteredProducts = []
    }
    
    init(filteredProducts: [Product]) {
        self.filteredProducts = filteredProducts
    }
}

class ResultsTableController: UITableViewController {
        
    // MARK: - Properties
    
    var viewModel: ResultsTableViewModelProtocol {
        didSet {
            updateView()
        }
    }
    
    private var resultsLabel: UILabel = UILabel()
    
    // MARK: - Initialization
    
    override init(style: UITableView.Style = .plain) {
        viewModel = ResultsTableViewModel()
        super.init(style: style)
    }
         
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView?.frame.size.height = 44
        tableView.tableHeaderView = resultsLabel
        
        registerTableCell()
    }
    
    func registerTableCell() {
        tableView.register(cellType: TableCellView.self)
    }
    
    func updateView() {
        let successText = String(format: NSLocalizedString("Items found: %ld", comment: ""), viewModel.filteredProducts.count)
        
        let failureText = NSLocalizedString("NoItemsFoundTitle", comment: "")
        
        resultsLabel.text = viewModel.filteredProducts.isEmpty ? failureText : successText
            
        tableView.reloadData()
    }
    
}

// MARK: - UITableViewDataSource

extension ResultsTableController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredProducts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableCellView = tableView.dequeueReusableCell(for: indexPath)
        cell.viewModel = TableCellViewModel(product: viewModel.filteredProducts[indexPath.row])
        return cell
    }
    
}
