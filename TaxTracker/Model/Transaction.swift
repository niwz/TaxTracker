//
//  Transaction.swift
//  TaxTracker
//
//  Created by Nicholas Wong on 11/17/19.
//  Copyright © 2019 Nicholas Wong. All rights reserved.
//

import Foundation

struct Transaction: Codable {
    let sent: TransactionUnit
    let received: TransactionUnit
    let date: Date
}

struct TransactionUnit: Codable {
    let currencyName: String
    let unitUSDValue: Int
    var quantity: Float
}
