//
//  GetShippingAreasWorker.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/19/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import Foundation

struct Region: Decodable {
    var shipping_region_id: Int
    var shipping_region: String
}

struct GetShippingAreasWorker {
    private let api = "/shipping/regions"
    private var successAction: (([Region]) -> Void)?

    init(successAction: (([Region]) -> Void)?) {
        self.successAction = successAction
    }

    func execute() {
        ApiConnector.get(api, returnData: successResponse)
    }

    private func successResponse(returnData: Data) {
        guard var results = try? JSONDecoder().decode([Region].self, from: returnData) else {
            successAction?([])
            return
        }
        if let index = results.firstIndex(where: { $0.shipping_region.lowercased() == "please select" }) {
            results.remove(at: index)
        }
        successAction?(results)
    }
}

