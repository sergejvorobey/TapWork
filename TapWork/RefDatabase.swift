//
//  RefDatabase.swift
//  TapWork
//
//  Created by Sergey Vorobey on 06/05/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import Foundation
import Firebase

class RefDatabase {
    
    var ref: DatabaseReference! {
        return refDatabase
    }
    
    private var queryRef: DatabaseQuery!
    private var refDatabase = Database.database().reference(withPath: "vacancies")
    
}
