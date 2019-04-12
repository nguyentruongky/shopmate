//
//  GetExpiryDateWorker.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/12/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import Foundation

class GetExpiryDateWorker {
    func execute() -> [String] {
        let today = Date()
        let month = today.month
        let year = today.year

        var slots = [String]()
        let format = "%02d/%02d"
        for i in month ... 12 {
            slots.append(String(format: format, i, year))
        }

        for y in year + 1 ..< year + 4 {
            for m in 1 ... 12 {
                slots.append(String(format: format, m, y))
            }
        }
        return slots
    }
}
