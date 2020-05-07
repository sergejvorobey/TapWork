//
//  Validators.swift
//  TapWork
//
//  Created by Sergey Vorobey on 07/05/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import Foundation

class Validators {
    
    static func isFailed(firstname: String?, lastName: String?, email: String?, password: String?) -> Bool {
        guard !(firstname ?? "").isEmpty,
            !(lastName ?? "").isEmpty,
            !(email ?? "").isEmpty,
            !(password ?? "").isEmpty else {
                return false
        }
        return true
    }
    
    static func isFailedEmailOrPassword(email: String?, password: String?) -> Bool {
           guard
               !(email ?? "").isEmpty,
               !(password ?? "").isEmpty else {
                   return false
           }
           return true
       }
    
    
    static func isSimpleEmail(_ email: String) -> Bool {
        let emailRegEx = "^.+@.+\\..{2,}$"
        return check(text: email, regEx: emailRegEx)
    }
    
    private static func check(text: String, regEx: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regEx)
        return predicate.evaluate(with: text)
    }
}
