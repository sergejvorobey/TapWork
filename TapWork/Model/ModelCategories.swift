//
//  ModelCategories.swift
//  TapWork
//
//  Created by Sergey Vorobey on 17/02/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import Foundation

struct CategoriesList: Decodable {

    var category: String?
    var specialization: [Specializations]?

    enum CodingKeys: String, CodingKey {

        case category = "category"
        case specialization = "specializations"
    }
}

struct Specializations: Decodable {

    var name: String?
    var professions: [String?]

    enum CodingKeys: String, CodingKey {

        case name = "name"
        case professions = "professions"
    }
}

//struct CategoriesList: Decodable {
//
//    var category: String?
//    var specializations: [Specializations]?
//
//    enum CodingKeys: String, CodingKey {
//
//        case category = "category"
//        case specializations = "specializations"
//    }
//}
//struct Specializations: Decodable {
//
//    var name: String?
//    var specializations: [String?]
//
//    enum CodingKeys: String, CodingKey {
//
//        case name = "name"
//        case specializations = "specializations"
//    }
//}
