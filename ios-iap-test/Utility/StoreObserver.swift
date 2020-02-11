//
//  StoreObserver.swift
//  ios-iap-test
//
//  Created by jhseo on 2020/02/11.
//  Copyright © 2020 jhseo. All rights reserved.
//

import StoreKit

class StoreObserver: NSObject, SKPaymentTransactionObserver {
    var purchased = [SKPaymentTransaction]()

    override init() {
        super.init()
    }

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                print("결제 진행 중")
            case .deferred:
                print("결제 창을 띄우는 데 실패")
            case .purchased:
                print("결제 성공")
                handlePurchased(transaction)
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed:
                print("결제 실패")
                SKPaymentQueue.default().finishTransaction(transaction)
            case .restored:
                print("상품 검증 완료")
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                print("알 수 없는 오류")
                SKPaymentQueue.default().finishTransaction(transaction)
            }
        }
    }

    func handlePurchased(_ transaction: SKPaymentTransaction) {
        purchased.append(transaction)

        SKPaymentQueue.default().restoreCompletedTransactions()

        print("영수증 주소: \(Bundle.main.appStoreReceiptURL)")

        let receiptData = NSData(contentsOf: Bundle.main.appStoreReceiptURL!)
        print(receiptData)

        let receiptString = receiptData!.base64EncodedString(options: NSData.Base64EncodingOptions())

        print("구매 성공 트랜잭션 아이디 : \(transaction.transactionIdentifier)")
        print("상품 아이디 : \(transaction.payment.productIdentifier)")
        print("구매 영수증 : \(receiptString)")

        SKPaymentQueue.default().finishTransaction(transaction)
    }
}
