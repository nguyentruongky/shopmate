//
//  PasswordValidation.swift
//  SnapShop
//
//  Created by Ky Nguyen Coinhako on 11/17/18.
//  Copyright © 2018 Ky Nguyen. All rights reserved.
//

import Foundation

struct knPasswordValidation {
    func checkCharCount(_ password: String) -> Bool {
        let regexCharCount = "^.{6,}$"
        let passwordTest1 = NSPredicate(format: "SELF MATCHES %@", regexCharCount)
        return passwordTest1.evaluate(with: password)
    }
    
    func checkUpperCase(_ password: String) -> Bool {
        let regexUpperCase = ".*[A-Z]+.*"
        let passwordTest2 = NSPredicate(format: "SELF MATCHES %@", regexUpperCase)
        return passwordTest2.evaluate(with: password)
    }
    
    func checkNumberDigit(_ password: String) -> Bool {
        let regexNumber = ".*[0-9]+.*"
        let passwordTest3 = NSPredicate(format: "SELF MATCHES %@", regexNumber)
        return passwordTest3.evaluate(with: password)
    }
}
