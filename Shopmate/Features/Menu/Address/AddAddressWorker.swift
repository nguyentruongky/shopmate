//
//  AddAddressWorker.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/13/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import Foundation

struct AddAddressWorker {
    private let api = "/customers/address"
    private var address: Address
    private var success: (() -> Void)?
    private var fail: ((knError) -> Void)?

    init(address: Address,
         success: (() -> Void)?,
         fail: ((knError) -> Void)?) {
        self.address = address
        self.fail = fail
        self.success = success
    }

    func execute() {
        guard let address1 = address.address1,
            let city = address.city,
            let region = address.region,
            let code = address.postalCode,
            let country = address.country,
            let shippingRegionId = address.shippingRegionId else { return }

        let params = [
            "address_1": address1,
            "city": city,
            "region": region,
            "postal_code": code,
            "country": country,
            "shipping_region_id": shippingRegionId
            ] as [String : Any]
        ApiConnector.put(api, params: params,
                         success: successResponse,
                         fail: failResponse)
    }

    func successResponse(returnData: AnyObject) {
        success?()
    }

    func failResponse(err: knError) {
        fail?(err)
    }
}


