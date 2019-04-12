//
//  GetSizesWorker.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/12/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import Foundation

struct Size: Decodable {
    let attribute_value_id: Int
    let value: String
}


struct GetSizesWorker {
    private let api = "/attributes/values/1"
    private var successAction: (([Size]) -> Void)?

    init(successAction: (([Size]) -> Void)?) {
        self.successAction = successAction
    }

    func execute() {
        ApiConnector.get(api, returnData: successResponse)
    }

    private func successResponse(returnData: Data) {
        guard let results = try? JSONDecoder().decode([Size].self, from: returnData) else {
            successAction?([])
            return
        }
        successAction?(results)
    }
}

