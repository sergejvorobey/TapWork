//
//  Validators.swift
//  TapWork
//
//  Created by Sergey Vorobey on 07/05/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import Foundation
import SystemConfiguration

class Validators {
    
    //MARK: check filled multiple texts fields
    static func isFilledMultipleTextFields(firstText: String?, secondText: String?) -> Bool {
        
        guard !(firstText ?? "").isEmpty,
            !(secondText ?? "").isEmpty else {return false}
        
        return true
    }
    
    //MARK: check one text field
    static func isFilledTextField(text: String?) -> Bool {
        
        guard !(text ?? "").isEmpty else {return false}
        
        return true
    }
    
    //MARK: Max/min count element TextField
    static func checkLengthField(text: String?, minCount: Int, maxCount: Int) -> Bool {
     
        guard !(text!.count > maxCount || text!.count < minCount) else {return false}
        return true
    }
    
    
    
    //checking text fields for spaces
    static func isFilledRegister(firstname: String?,
                                 lastName: String?,
                                 birth: String?,
                                 city: String?,
                                 email: String?,
                                 password: String?) -> Bool {
        guard !(firstname ?? "").isEmpty,
            !(lastName ?? "").isEmpty,
            !(birth ?? "").isEmpty,
            !(city ?? "").isEmpty,
            !(email ?? "").isEmpty,
            !(password ?? "").isEmpty else {
                return false
        }
        return true
    }
    static func isFilledRegisterEmployer(firstname: String?,
                                         lastName: String?,
                                         city: String?,
                                         email: String?,
                                         password: String?) -> Bool {
        guard !(firstname ?? "").isEmpty,
            !(lastName ?? "").isEmpty,
            !(city ?? "").isEmpty,
            !(email ?? "").isEmpty,
            !(password ?? "").isEmpty else {
                return false
        }
        return true
    }
    
    static func isFilledUser(firstname: String?,
                             lastName: String?,
                             city: String?,
                             birth: String?) -> Bool {
        guard !(firstname ?? "").isEmpty,
            !(lastName ?? "").isEmpty,
            !(city ?? "").isEmpty,
            !(birth ?? "").isEmpty else {
                return false
        }
        return true
    }
    
    static func isFilledVacansy(headingVacansy: String?,
                                cityVacansy: String?,
                                contentVacansy: String?,
                                paymentVacansy: String?,
                                phoneNumber: String?) -> Bool {
        guard !(headingVacansy ?? "").isEmpty,
            !(cityVacansy ?? "").isEmpty,
            !(contentVacansy ?? "").isEmpty,
            !(paymentVacansy ?? "").isEmpty,
            !(phoneNumber ?? "").isEmpty else {
                return false
        }
        return true
    }
    
    //checking email and password fields for spaces
    static func isFilledEmailOrPassword(email: String?, password: String?) -> Bool {
        guard
            !(email ?? "").isEmpty,
            !(password ?? "").isEmpty else {
                return false
        }
        return true
    }
    //check valid email
    static func isSimpleEmail(_ email: String) -> Bool {
        let emailRegEx = "^.+@.+\\..{2,}$"
        return check(text: email, regEx: emailRegEx)
    }
    
    private static func check(text: String, regEx: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regEx)
        return predicate.evaluate(with: text)
    }
    
    // Max/min count element TextField
    static func checkLengthFiedls(headingVacansy: String?,
                                  contentVacansy: String?,
                                  paymentVacansy: String?,
                                  phoneNumber: String?) -> Bool {
        let maxCountHeading = 30
        let minCountHeading = 5
        let maxCountContent = 200
        let minCountContent = 20
        let maxCountPayment = 5
        let minCountPayment = 3
        let maxCountPhone = 12
        let minCountPhone = 11
        
        guard !(headingVacansy!.count > maxCountHeading || headingVacansy!.count < minCountHeading),
            !(contentVacansy!.count > maxCountContent || contentVacansy!.count < minCountContent),
            !(paymentVacansy!.count > maxCountPayment || paymentVacansy!.count < minCountPayment),
            !(phoneNumber!.count > maxCountPhone || phoneNumber!.count < minCountPhone) else {
                return false
        }
        return true
    }
    
    //check network connection
    static func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        /* Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired
         
         return isReachable && !needsConnection
         */
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
        
    }
}
