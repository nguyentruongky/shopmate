//
//  GetShippingDetailWorker.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/19/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import Foundation

struct ShippingMethod {
    var shippingID: Int?
    var shippingType: String?
    var shippingCost: String?
    var shippingRegionID: Int?

    init(raw: AnyObject) {
        shippingID = raw["shipping_id"] as? Int
        shippingType = raw["shipping_type"] as? String
        shippingCost = raw["shipping_cost"] as? String
        shippingRegionID = raw["shipping_region_id"] as? Int
    }
}

struct GetShippingDetailWorker {
    private var api = "/shipping/regions/"
    private var successAction: (([ShippingMethod]) -> Void)?

    init(regionID: Int, successAction: (([ShippingMethod]) -> Void)?) {
        api += String(regionID)
        self.successAction = successAction
    }

    func execute() {
        ApiConnector.get(api, success: successResponse)
    }

    private func successResponse(returnData: AnyObject) {
        guard let results = returnData as? [AnyObject] else {
            successAction?([])
            return
        }
        let methods = results.map({ return ShippingMethod(raw: $0) })
        successAction?(methods)
    }
}

