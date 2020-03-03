//
//  ResultsTableController.swift
//  TableSearch
//
//  Created by Lucas Nascimento on 02/03/20.
//  Copyright © 2020 Lucas Nascimento. All rights reserved.
//

import UIKit

class ResultsTableController: UITableViewController {
        
    var filteredProducts = [Product]()
    
    var resultsLabel: UILabel = UILabel()
    
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
    
}

// MARK: - UITableViewDataSource

extension ResultsTableController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredProducts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableCellView = tableView.dequeueReusableCell(for: indexPath)
        cell.viewModel = TableCellViewModel(product: filteredProducts[indexPath.row])
        return cell
    }
    
}
