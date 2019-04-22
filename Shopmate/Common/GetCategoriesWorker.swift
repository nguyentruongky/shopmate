//
//  GetCategoriesWorker.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/19/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit
enum CategoryType {
    case category, department
}
struct Category {
    let department_id: Int
    let name: String
    let description: String
    let category_id: Int
    var type: CategoryType

    init(raw: AnyObject) {
        department_id = raw["department_id"] as? Int ?? 0
        name = raw["name"] as? String ?? ""
        description = raw["description"] as? String ?? ""
        category_id = raw["category_id"] as? Int ?? 0
        type = .category
    }

    init(departmentRaw: AnyObject) {
        department_id = departmentRaw["department_id"] as? Int ?? 0
        name = departmentRaw["name"] as? String ?? ""
        description = departmentRaw["description"] as? String ?? ""
        type = .department
        category_id = 0
    }
}



struct GetCategoriesWorker {
    private let api = "/categories"
    private var successAction: (([Category]) -> Void)?

    init(successAction: (([Category]) -> Void)?) {
        self.successAction = successAction
    }

    func execute() {
        ApiConnector.get(api, success: successResponse)
    }

    private func successResponse(returnData: AnyObject) {
        guard let rawData = returnData["rows"] as? [AnyObject] else {
            successAction?([])
            return
        }
        let results = rawData.map({ return Category(raw: $0) })
        successAction?(results)
    }
}


