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

//=========================================//

struct ProfessionModel: Codable {
    
    var aboutMe: String?
    var profession: String?
    var experience: Experience?
    
    enum CodingKeys: String, CodingKey {
        case aboutMe = "aboutMe"
        case profession = "profession"
        case experience = "experience"
    }
}

struct Experience: Codable {
    var places: [Places?]
    
    enum CodingKeys: String, CodingKey {
        case places = "places"
    }
}

struct Places: Codable {
    var namePlace: String?
    var duration: String?
    var profession: String?
    var responsibility: String?
    
    enum CodingKeys: String, CodingKey {
        case namePlace = "namePlace"
        case duration = "duration"
        case profession = "profession"
        case responsibility = "responsibility"
    }
}

