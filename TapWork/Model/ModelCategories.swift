//
//  ModelCategories.swift
//  TapWork
//
//  Created by Sergey Vorobey on 17/02/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import Foundation

struct CategoriesList: Decodable {
    
    var nameCategory: String?
    var listOfSpecializations: [String?]
    
    enum CodingKeys: String, CodingKey {

        case nameCategory = "nameCategory"
        case listOfSpecializations = "listOfSpecializations"
    }
}
