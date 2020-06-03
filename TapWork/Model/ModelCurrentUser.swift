//
//  ModelCurrentUser.swift
//  TapWork
//
//  Created by Sergey Vorobey on 15/05/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import Foundation
import Firebase

struct CurrentUser {
    
    var dateRegister: Date?
    var city: String?
    var firstName: String?
    var lastName: String?
    var birth: String?
    var profileImageUrl: String?
    var roleUser: String?
    var uid: String?
//    var profession: Professions?
    var fullName: String {
        return """
        \(firstName!)
        \(lastName!)
        """
    }
    var ageAndCity: String {
        return birth! + ", " + city!
    }
}

struct CheckCurrentUser {
    var basic: [Basic]?
    var profession: [Professions]?
    var emloyer: [Employer]?
}

struct Basic {
    var dateRegister: Date?
    var city: String?
    var firstName: String?
    var lastName: String?
    var birth: String?
    var profileImageUrl: String?
    var roleUser: String?
    var uid: String?

    var fullName: String {
        return """
        \(firstName!)
        \(lastName!)
        """
    }
    
    var ageAndCity: String {
//        return birth! + ", " + city!
        return """
        \(birth!)
        \(city!)
        """
    }
}

struct Professions {
    var aboutMe: String?
    var experience: String?
    var profession: String?
}

struct Employer {
    var activeVacansy: Int?
    var draft: Int?
}
