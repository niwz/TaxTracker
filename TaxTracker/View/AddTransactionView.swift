//
//  AddTransactionView.swift
//  TaxTracker
//
//  Created by Nicholas Wong on 11/17/19.
//  Copyright © 2019 Nicholas Wong. All rights reserved.
//

import UIKit
import Stevia

class AddTransactionView: UIView {
    let sentCurrencyView = AddTransactionInputView(name: "Sent Currency")
    let sentUnitValueView = AddTransactionInputView(name: "Unit Value (USD)")
    let sentQuantityView = AddTransactionInputView(name: "Sent Quantity")

    let receivedCurrencyView = AddTransactionInputView(name: "Received Currency")
    let receivedUnitValueView = AddTransactionInputView(name: "Unit Value (USD)")
    let receivedQuantityView = AddTransactionInputView(name: "Received Quantity")
    
    let dateView = AddTransactionInputView(name: "Date")

    override init(frame: CGRect) {
        super.init(frame: frame)
        let sentStackView = VStack(arrangedSubviews: [sentCurrencyView, sentUnitValueView, sentQuantityView], spacing: 8)
        let receivedStackView = VStack(arrangedSubviews: [receivedCurrencyView, receivedUnitValueView, receivedQuantityView], spacing: 8)
        sv(sentStackView, receivedStackView, dateView)
        sentStackView.top(0).fillHorizontally()
        receivedStackView.Top == sentStackView.Bottom + 32
        receivedStackView.fillHorizontally()
        dateView.Top == receivedStackView.Bottom + 16
        dateView.fillHorizontally().bottom(0)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}
