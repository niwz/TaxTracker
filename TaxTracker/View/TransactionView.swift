//
//  TransactionView.swift
//  TaxTracker
//
//  Created by Nicholas Wong on 11/17/19.
//  Copyright © 2019 Nicholas Wong. All rights reserved.
//

import UIKit
import Stevia

class TransactionView: UIView {

    let currencyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17.0)
        return label
    }()

    let amountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13.0)
        label.textColor = .lightGray
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        let stackView = UIStackView(arrangedSubviews: [currencyLabel, amountLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        sv(stackView)
        stackView.fillContainer()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func configure(_ transactionUnit: TransactionUnit) {
        currencyLabel.text = "\(transactionUnit.quantity) \(transactionUnit.currencyName)"
        amountLabel.text = "\(transactionUnit.quantity) × $\(transactionUnit.unitUSDValue)"
    }
}
