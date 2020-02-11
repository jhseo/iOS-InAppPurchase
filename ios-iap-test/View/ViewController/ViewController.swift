//
//  ViewController.swift
//  ios-iap-test
//
//  Created by jhseo on 2020/02/11.
//  Copyright © 2020 jhseo. All rights reserved.
//

import UIKit
import StoreKit

class ViewController: UIViewController {

    let iapObserver = StoreObserver()
    var productRequest: SKProductsRequest?

    var validProductArray = [SKProduct]()

    override func viewDidLoad() {
        super.viewDidLoad()

        SKPaymentQueue.default().add(iapObserver)

        // 등록한 상품의 ID 또는 서버에서 가져옴
        let pIDs = Set(["iap100", "iap200"])
        productRequest = SKProductsRequest(productIdentifiers: pIDs)
        if let productRequest = self.productRequest {
            productRequest.delegate = self
            productRequest.start()
        }
    }

    @IBAction func checkPaymentAble(_ sender: Any) {
        if SKPaymentQueue.canMakePayments() {
            print("결제 요청 가능")
        } else {
            print("결제 요청 불가")
        }
    }

    @IBAction func tryPaymentQueue(_ sender: Any) {
        guard let product = validProductArray.first else { return }
        let payment = SKMutablePayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
}

extension ViewController: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {

        print("상품갯수 \(response.products.count)")
        print("확인하지 못한 상품 갯수 : \(response.invalidProductIdentifiers.count)")

        for product in response.products {
            print("상품명: \(product.localizedTitle), 가격: \(product.price)")
            validProductArray.append(product)
        }
    }
}

