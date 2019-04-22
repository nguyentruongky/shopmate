//
//  GetDepartmentsWorker.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/19/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import Foundation

struct GetDepartmentsWorker {
    private let api = "/departments"

    private var successAction: (([Category]) -> Void)?
    init(successAction: (([Category]) -> Void)?) {
        self.successAction = successAction
    }

    func execute() {
        ApiConnector.get(api, success: successResponse)
    }

    private func successResponse(returnData: AnyObject) {
        guard let rawData = returnData as? [AnyObject] else {
            successAction?([])
            return
        }
        let results = rawData.map({ return Category(departmentRaw: $0) })
        successAction?(results)
    }
}


