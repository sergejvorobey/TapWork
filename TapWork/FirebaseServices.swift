//
//  FirebaseServices.swift
//  TapWork
//
//  Created by Sergey Vorobey on 10/05/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import Foundation
import Firebase
import UIKit


class RefDatabase {
    
    var infoUser: Users!
    private var ref: DatabaseReference!
    let db = Firestore.firestore()
    
    func refDatabase() {
        guard let currentUsers = Auth.auth().currentUser else { return }
        
        infoUser = Users(user: currentUsers)
        ref = Database.database().reference(withPath: "users").child(String(infoUser.userId))
    }
}
