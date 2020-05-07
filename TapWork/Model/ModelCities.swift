//
//  ModelCities.swift
//  TapWork
//
//  Created by Sergey Vorobey on 02/05/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import Foundation

struct City: Decodable {

    var response: Response?
    
    enum CodingKeys: String, CodingKey {
        case response = "response"
    }
}

struct Response: Decodable {
    
    var items: [Items]?
    
    enum CodingKeys: String, CodingKey {
        case items = "items"
    }
}

struct Items: Decodable {
    
    var title: String?

    enum CodingKeys: String, CodingKey {
        case title = "title"
    }
}
