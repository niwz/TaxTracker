//
//  AddTransactionInputView.swift
//  TaxTracker
//
//  Created by Nicholas Wong on 11/17/19.
//  Copyright © 2019 Nicholas Wong. All rights reserved.
//

import UIKit
import Stevia

class AddTransactionInputView: UIView {

    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 17)
        return label
    }()

    let inputTextField: UITextField = {
        let tf = UITextField()
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.layer.borderWidth = 1
        return tf
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        let stackView = UIStackView(arrangedSubviews: [nameLabel, inputTextField])
        stackView.distribution = .fillEqually
        sv(stackView)
        stackView.fillContainer(8)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    convenience init(name: String) {
        self.init(frame: .zero)
        nameLabel.text = name
    }
}
