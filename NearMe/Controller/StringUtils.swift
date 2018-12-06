//
//  StringUtils.swift
//  NearMe
//
//  Created by MedAmine on 12/6/18.
//  Copyright © 2018 amine. All rights reserved.
//

import Foundation

class StringUtils {
    
    static let shared = StringUtils()
    
    func verifyPasswordFormat(password: String) -> Bool {
        return password.count >= 8
    }
    
    func verifyEmailFormat(email: String) -> Bool{
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
}
