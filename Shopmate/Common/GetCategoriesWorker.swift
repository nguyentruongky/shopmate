//
//  GetCategoriesWorker.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/19/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit
struct Category {
    let department_id: Int
    let name: String
    let description: String
    let category_id: Int
    var color: UIColor {
        return UIColor(r: randomizeNumber(),
                       g: randomizeNumber(),
                       b: randomizeNumber())
    }

    init(raw: AnyObject) {
        department_id = raw["department_id"] as? Int ?? 0
        name = raw["name"] as? String ?? ""
        description = raw["description"] as? String ?? ""
        category_id = raw["category_id"] as? Int ?? 0

    }

    private func randomizeNumber() -> CGFloat {
        return CGFloat.random(in: 50...255)
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


