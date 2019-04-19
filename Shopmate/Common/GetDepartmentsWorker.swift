//
//  GetDepartmentsWorker.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/19/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import Foundation
struct Department: Decodable {
    let department_id: Int
    let name: String
    let description: String
}



struct GetDepartmentsWorker {
    private let api = "/departments"
    private var successAction: (([Department]) -> Void)?

    init(successAction: (([Department]) -> Void)?) {
        self.successAction = successAction
    }

    func execute() {
        ApiConnector.get(api, returnData: successResponse)
    }

    private func successResponse(returnData: Data) {
        guard let results = try? JSONDecoder().decode([Department].self, from: returnData) else {
            successAction?([])
            return
        }
        successAction?(results)
    }
}


