//
//  Service.swift
//  TaxTracker
//
//  Created by Nicholas Wong on 11/17/19.
//  Copyright © 2019 Nicholas Wong. All rights reserved.
//

import Foundation

extension NSNotification {
    static let shortTermCapitalGain = NSNotification.Name("shortTermCapitalGain")
    static let longTermCapitalGain = NSNotification.Name("longTermCapitalGain")
}

class TrackingService {
    static let shared = TrackingService()
    typealias CurrencyQueueTuple = (transactionUnit: TransactionUnit, date: Date)
    var currencyQueues: [String: [CurrencyQueueTuple]] = [:]

    func update(_ transaction: Transaction) {
        updateSent(transaction.sent, transaction.date)
        updateReceived(transaction.received, transaction.date)
    }

    func updateSent(_ sent: TransactionUnit, _ date: Date) {
        let sentCurrency = sent.currencyName
        let longTermThreshold: TimeInterval = 60 * 60 * 24 * 366
        guard var sentCurrencyQueue = currencyQueues[sentCurrency] else { return }

        var shortTermProceeds: Float = 0.0
        var shortTermCostBasis: Float = 0.0
        var shortTermCapitalGains: Float = 0.0

        var longTermProceeds: Float = 0.0
        var longTermCostBasis: Float = 0.0
        var longTermCapitalGains: Float = 0.0

        var sentQuantity = sent.quantity
        while sentQuantity > 0 {
            guard sentCurrencyQueue.count > 0 else { return }
            var firstIn = sentCurrencyQueue[0]
            let timeDelta = date - firstIn.date
            if firstIn.transactionUnit.quantity > sentQuantity {
                if timeDelta < longTermThreshold {
                    shortTermProceeds += Float(sent.unitUSDValue) * sentQuantity
                    shortTermCostBasis += Float(firstIn.transactionUnit.unitUSDValue) * sentQuantity
                    shortTermCapitalGains += Float(sent.unitUSDValue) * sentQuantity - Float(firstIn.transactionUnit.unitUSDValue) * sentQuantity
                } else {
                    longTermProceeds += Float(sent.unitUSDValue) * sentQuantity
                    longTermCostBasis += Float(firstIn.transactionUnit.unitUSDValue) * sentQuantity
                    longTermCapitalGains += Float(sent.unitUSDValue) * sentQuantity - Float(firstIn.transactionUnit.unitUSDValue) * sentQuantity
                }
                firstIn.transactionUnit.quantity -= sentQuantity
                sentCurrencyQueue[0] = firstIn
                sentQuantity = 0
            } else {
                if timeDelta < longTermThreshold {
                    shortTermProceeds += Float(sent.unitUSDValue) *  firstIn.transactionUnit.quantity
                    shortTermCostBasis += Float(firstIn.transactionUnit.unitUSDValue) * firstIn.transactionUnit.quantity
                    shortTermCapitalGains += Float(sent.unitUSDValue) *  firstIn.transactionUnit.quantity - Float(firstIn.transactionUnit.unitUSDValue) * firstIn.transactionUnit.quantity
                } else {
                    longTermProceeds += Float(sent.unitUSDValue) *  firstIn.transactionUnit.quantity
                    longTermCostBasis += Float(firstIn.transactionUnit.unitUSDValue) * firstIn.transactionUnit.quantity
                    longTermCapitalGains += Float(sent.unitUSDValue) *  firstIn.transactionUnit.quantity - Float(firstIn.transactionUnit.unitUSDValue) * firstIn.transactionUnit.quantity
                }
                sentCurrencyQueue.removeFirst()
                sentQuantity -= firstIn.transactionUnit.quantity
            }
        }
        currencyQueues[sentCurrency] = sentCurrencyQueue
        if shortTermCapitalGains != 0 {
            NotificationCenter.default.post(name: NSNotification.shortTermCapitalGain, object: nil, userInfo: ["proceeds": shortTermProceeds, "basis": shortTermCostBasis, "gain": shortTermCapitalGains])
        }
        if longTermCapitalGains != 0 {
            NotificationCenter.default.post(name: NSNotification.longTermCapitalGain, object: nil, userInfo: ["proceeds": longTermProceeds, "basis": longTermCostBasis, "gain": longTermCapitalGains])
        }
    }

    func updateReceived(_ received: TransactionUnit, _ date: Date) {
        let currencyName = received.currencyName
        if var currencyQueue = currencyQueues[currencyName] {
            currencyQueue.append((received, date))
            currencyQueues[currencyName] = currencyQueue
        } else {
            let newCurrencyQueue = [(received, date)]
            currencyQueues[currencyName] = newCurrencyQueue
        }
    }
}
