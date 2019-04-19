//
//  UpdateProfileWorker.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/19/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import Foundation
struct UpdateProfileWorker {
    private let api = "/customer"
    var user: Customer
    var success: (() -> Void)?
    var fail: ((knError) -> Void)?
    init(user: Customer,
         success: (() -> Void)?,
         fail: ((knError) -> Void)?) {
        self.user = user
        self.success = success
        self.fail = fail
    }

    func execute() {
        var params = [String: Any]()
        if let data = user.name {
            params["name"] = data
        }
        if let data = user.phone {
            params["mob_phone"] = data
        }
        if let data = user.email {
            params["email"] = data
        }
        ApiConnector.put(api, params: params, success: successResponse, fail: failResponse)
    }

    private func successResponse(returnData: AnyObject) {
        print(returnData)
        success?()
    }

    private func failResponse(_ err: knError) {
        print(err)
        success?()
    }
}
