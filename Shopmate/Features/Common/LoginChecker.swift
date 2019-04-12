//
//  LoginChecker.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/12/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit

struct LoginChecker {
    func didLogin() -> Bool {
        return appSetting.didLogin
    }

    func showLogin() {
        let controller = LandingController()
        UIApplication.present(wrap(controller))
    }
}
