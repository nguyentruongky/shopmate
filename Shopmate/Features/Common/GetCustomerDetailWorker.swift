//
//  GetCustomerDetailWorker.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/13/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import Foundation

struct GetCustomerWorker {
    private let api = "/customer"
    private var success: ((Customer) -> Void)?
    private var fail: ((knError) -> Void)?

    init(success: ((Customer) -> Void)?,
         fail: ((knError) -> Void)?) {
        self.fail = fail
        self.success = success
    }

    func execute() {
        ApiConnector.get(api,
                          success: successResponse,
                          fail: failResponse)
    }

    private func successResponse(returnData: AnyObject) {
        if let message = returnData.value(forKeyPath: "error.message") as? String {
            let err = knError(code: "login_fail", message: message)
            failResponse(err: err)
            return
        }

        let user = Customer(raw: returnData as AnyObject)
        user.token = returnData["accessToken"] as? String
        success?(user)
    }

    private func failResponse(err: knError) {
        fail?(err)
    }
}
