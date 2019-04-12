//
//  GetColorsWorker.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/12/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import Foundation

struct Color: Decodable {
    let attribute_value_id: Int
    let value: String
}


struct GetColorsWorker {
    private let api = "/attributes/values/2"
    private var successAction: (([Color]) -> Void)?

    init(successAction: (([Color]) -> Void)?) {
        self.successAction = successAction
    }

    func execute() {
        ApiConnector.get(api, returnData: successResponse)
    }

    private func successResponse(returnData: Data) {
        guard let results = try? JSONDecoder().decode([Color].self, from: returnData) else {
            successAction?([])
            return
        }
        successAction?(results)
    }
}

