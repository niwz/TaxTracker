//
//  AddTransactionController.swift
//  TaxTracker
//
//  Created by Nicholas Wong on 11/17/19.
//  Copyright © 2019 Nicholas Wong. All rights reserved.
//

import UIKit
import Stevia

protocol AddTransactionControllerDelegate: class {
    func didAddTransaction(transaction: Transaction)
}

class AddTransactionController: UIViewController {

    let addTransactionView = AddTransactionView()
    let saveButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Save", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .blue
        btn.width(80)
        btn.layer.cornerRadius = 8
        btn.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        return btn
    }()

    weak var delegate: AddTransactionControllerDelegate?
    var transactionDate = Date()

    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter
    }()


    override func viewDidLoad() {
        view.backgroundColor = .white
        view.sv(addTransactionView, saveButton)
        addTransactionView.top(16).fillHorizontally(m: 16)
        saveButton.Top == addTransactionView.Bottom + 16
        saveButton.centerHorizontally()
        setupDatePicker()
        setupTapGesture()
        addTransactionView.dateView.inputTextField.text = dateFormatter.string(from: transactionDate)
    }

    private func setupDatePicker() {

        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateSelected(datePicker:)), for: .valueChanged)
        addTransactionView.dateView.inputTextField.inputView = datePicker
    }

    @objc func dateSelected(datePicker: UIDatePicker) {
        transactionDate = datePicker.date
        addTransactionView.dateView.inputTextField.text = dateFormatter.string(from: datePicker.date)
    }

    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapped))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func handleTapped() {
        view.endEditing(true)
    }

    @objc private func handleSave() {
        let sent = TransactionUnit(currencyName: addTransactionView.sentCurrencyView.inputTextField.text ?? "", unitUSDValue: Int(addTransactionView.sentUnitValueView.inputTextField.text ?? "") ?? 0, quantity: Int(addTransactionView.sentQuantityView.inputTextField.text ?? "") ?? 0)
        let received = TransactionUnit(currencyName: addTransactionView.receivedCurrencyView.inputTextField.text ?? "", unitUSDValue: Int(addTransactionView.receivedUnitValueView.inputTextField.text ?? "") ?? 0, quantity: Int(addTransactionView.receivedQuantityView.inputTextField.text ?? "") ?? 0)
        let transaction = Transaction(sent: sent, received: received, date: transactionDate)
        dismiss(animated: true) {
            TrackingService.shared.update(transaction)
            self.delegate?.didAddTransaction(transaction: transaction)
        }
    }
}
