//
//  TableCellView.swift
//  TableSearch
//
//  Created by Lucas Nascimento on 03/03/20.
//  Copyright © 2020 Lucas Nascimento. All rights reserved.
//

import Common
import UIKit

internal class TableCellView: UITableViewCell, Reusable {

    // MARK: - Internal Properties
        
    internal var viewModel: TableCellViewModelProtocol? {
        didSet {
            update()
        }
    }

    // MARK: - Private Properties

    private let containerView: UIView

    // MARK: - Initialize Methods

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        containerView = UIView()
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    @available(*, unavailable)
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods

    private func update() {
        textLabel?.text = viewModel?.text
        detailTextLabel?.text = viewModel?.detailText
    }

}

extension TableCellView: ViewCodable {

    internal func configure() {
        accessoryType = .disclosureIndicator
    }

    internal func buildHierarchy() {
        addView(containerView)
    }

    internal func buildConstraints() {

        containerView.layout.makeConstraints { make in
            make.top.equalTo(self.layout.top)
            make.bottom.equalTo(self.layout.bottom)
            make.left.equalTo(self.layout.left)
            make.right.equalTo(self.layout.right)
        }

    }

    internal func render() {

    }

}
