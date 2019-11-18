//
//  TransactionCell.swift
//  TaxTracker
//
//  Created by Nicholas Wong on 11/17/19.
//  Copyright © 2019 Nicholas Wong. All rights reserved.
//

import UIKit

class TransactionCell: UITableViewCell {

    var transaction: Transaction! {
        didSet {
            sentView.configure(transaction.sent)
            receivedView.configure(transaction.received)
            let dateString = dateFormatter.string(from: transaction.date)
            dateLabel.text = dateString
        }
    }

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy"
        return formatter
    }()

    let sentView = TransactionView()
    let receivedView = TransactionView()

    let arrowLabel: UILabel = {
        let label = UILabel()
        label.text = "⟶"
        label.font = .systemFont(ofSize: 28.0)
        label.textColor = .lightGray
        return label
    }()

    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17.0)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let stackView = UIStackView(arrangedSubviews: [sentView, arrowLabel, receivedView, UIView(), dateLabel])
        stackView.spacing = 8
        sv(stackView)
        stackView.fillContainer(16)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}
