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
        var shortTermCapitalGains = 0
        var longTermCapitalGains = 0
        var sentQuantity = sent.quantity
        while sentQuantity > 0 {
            guard sentCurrencyQueue.count > 0 else { return }
            var firstIn = sentCurrencyQueue[0]
            let timeDelta = date - firstIn.date
            if firstIn.transactionUnit.quantity > sentQuantity {
                if timeDelta < longTermThreshold {
                    shortTermCapitalGains += sent.unitUSDValue * sentQuantity - firstIn.transactionUnit.unitUSDValue * sentQuantity
                } else {
                    longTermCapitalGains += sent.unitUSDValue * sentQuantity - firstIn.transactionUnit.unitUSDValue * sentQuantity
                }
                firstIn.transactionUnit.quantity -= sentQuantity
                sentCurrencyQueue[0] = firstIn
                sentQuantity = 0
            } else {
                if timeDelta < longTermThreshold {
                    shortTermCapitalGains += sent.unitUSDValue *  firstIn.transactionUnit.quantity - firstIn.transactionUnit.unitUSDValue * firstIn.transactionUnit.quantity
                } else {
                    longTermCapitalGains += sent.unitUSDValue *  firstIn.transactionUnit.quantity - firstIn.transactionUnit.unitUSDValue * firstIn.transactionUnit.quantity
                }
                sentCurrencyQueue.removeFirst()
                sentQuantity -= firstIn.transactionUnit.quantity
            }
        }
        currencyQueues[sentCurrency] = sentCurrencyQueue
        if shortTermCapitalGains != 0 {
            NotificationCenter.default.post(name: NSNotification.shortTermCapitalGain, object: nil, userInfo: ["gain": shortTermCapitalGains])
        }
        if longTermCapitalGains != 0 {
            NotificationCenter.default.post(name: NSNotification.longTermCapitalGain, object: nil, userInfo: ["gain": longTermCapitalGains])
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
