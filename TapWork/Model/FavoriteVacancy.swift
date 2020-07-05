//
//  FavoriteVacancy.swift
//  TapWork
//
//  Created by Sergey Vorobey on 01.07.2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import Foundation
import Firebase

struct Favorite {
    
    let keys: String?
    
    init(snapshot: DataSnapshot) {

//    let snapshotValue = snapshot.value as! [String: AnyObject]
        
        keys = snapshot.value as? String
    }
}
