//
//  1.Setting.swift
//  knCollection
//
//  Created by Ky Nguyen Coinhako on 7/3/18.
//  Copyright © 2018 Ky Nguyen. All rights reserved.
//

import UIKit

var appSetting = AppSetting()
struct AppSetting {
    var token: String? {
        get { return UserDefaults.get(key: "token") as String? }
        set {
            didLogin = newValue != nil
            UserDefaults.set(key: "token", value: newValue)
        }
    }
    var didLogin: Bool {
        get { return UserDefaults.get(key: "didLogin") as Bool? ?? false }
        set { UserDefaults.set(key: "didLogin", value: newValue) }
    }
}

let gap: CGFloat = 16
