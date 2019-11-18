//
//  MainController.swift
//  TaxTracker
//
//  Created by Nicholas Wong on 11/17/19.
//  Copyright © 2019 Nicholas Wong. All rights reserved.
//

import UIKit
import Stevia

class MainController: UIViewController {

    private let cellId = "cellId"

    var shortTermCapitalGains: Int = 0 {
        didSet {
            gainsView.shortTermGainsLabel.text = "\(shortTermCapitalGains)"
        }
    }

    var longTermCapitalGains: Int = 0 {
        didSet {
            gainsView.longTermGainsLabel.text = "\(longTermCapitalGains)"
        }
    }

    let gainsView = GainsView()
    let tableView = UITableView()

    var transactions = [Transaction]()

    let transactionsQueue: [String: [Transaction]] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupObservers()
        view.backgroundColor = .white
        title = "Tax Tracker"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(handleAddTransaction))
        tableView.dataSource = self
        tableView.register(TransactionCell.self, forCellReuseIdentifier: cellId)
        view.sv(gainsView, tableView)
        gainsView.Top == view.safeAreaLayoutGuide.Top + 16
        gainsView.centerHorizontally()
        gainsView.Width == view.Width - 32
        tableView.Top == gainsView.Bottom + 16
        tableView.fillHorizontally().bottom(0)
    }

    @objc func handleAddTransaction() {
        let addTransactionController = AddTransactionController()
        addTransactionController.delegate = self
        present(addTransactionController, animated: true)
    }
}

extension MainController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! TransactionCell
        let transaction = transactions[indexPath.row]
        cell.transaction = transaction
        return cell
    }

    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleAddShortTermCapitalGain), name: NSNotification.shortTermCapitalGain, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleAddLongTermCapitalGain), name: NSNotification.longTermCapitalGain, object: nil)
    }

    @objc private func handleAddShortTermCapitalGain(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let gain = userInfo["gain"] as? Int else { return }
        shortTermCapitalGains += gain
    }

    @objc private func handleAddLongTermCapitalGain(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let gain = userInfo["gain"] as? Int else { return }
        longTermCapitalGains += gain
    }
}

extension MainController: AddTransactionControllerDelegate {
    func didAddTransaction(transaction: Transaction) {
        transactions.append(transaction)
        tableView.reloadData()
    }
}
