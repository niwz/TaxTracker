//
//  GainsView.swift
//  TaxTracker
//
//  Created by Nicholas Wong on 11/17/19.
//  Copyright © 2019 Nicholas Wong. All rights reserved.
//

import UIKit
import Stevia

class GainsView: UIView {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Capital Gains"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()

    let shortTermGainsLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.systemFont(ofSize: 32)
        return label
    }()

    let shortTermLabel: UILabel = {
        let label = UILabel()
        label.text = "Short Term"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()

    let longTermGainsLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.systemFont(ofSize: 32)
        return label
    }()

    let longTermLabel: UILabel = {
        let label = UILabel()
        label.text = "Long Term"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()


    let separatorView: UIView = {
        let v = UIView()
        v.width(100)
        return v
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 16
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.lightGray.cgColor
        let shortTermStackView = VStack(arrangedSubviews: [shortTermGainsLabel, shortTermLabel], spacing: 4)
        shortTermStackView.alignment = .center
        let longTermStackView = VStack(arrangedSubviews: [longTermGainsLabel, longTermLabel], spacing: 4)
        longTermStackView.alignment = .center
        let gainsStack = UIStackView(arrangedSubviews: [shortTermStackView, separatorView, longTermStackView])
        gainsStack.distribution = .fillEqually
        let overallStackView = VStack(arrangedSubviews: [titleLabel, gainsStack], spacing: 16)
        overallStackView.alignment = .center
        sv(overallStackView)
        overallStackView.fillVertically(m: 16).centerHorizontally()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}
