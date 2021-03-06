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

class LoaderDataFirebase {
    
    private var infoUser: Users!
    private var ref: DatabaseReference!
    
    typealias callBack = (_ data: Any?, _ status: Bool, _ message: String) -> Void
    private var callBack: callBack?
    
    func getProfileUserID() {
        guard let currentUsers = Auth.auth().currentUser else { return }
        infoUser = Users(user: currentUsers)
        
        let db = Firestore.firestore()
        db.collection("users")
            .document(infoUser.userId)
            .collection("userData")
            .document("basic")
            .addSnapshotListener { (snapshot, _)  in
                
                guard let snapshot = snapshot, snapshot.exists else {return}
                
                guard let data = snapshot.data()!["uid"] as? String  else {return}
                self.callBack?(data, true,"")
        }
    }
    
    func getDatabaseUserBasic()  {
        
        var dataUser = [CurrentUser]()
        
        guard let currentUsers = Auth.auth().currentUser else { return }
        infoUser = Users(user: currentUsers)
        
        let db = Firestore.firestore()
        db.collection("users")
            .document(infoUser.userId)
            .collection("userData")
            .document("basic")
            .addSnapshotListener { (snapshot, _) in
                
                guard let snapshot = snapshot, snapshot.exists else {return}
                
                guard let data = snapshot.data() else {return}
                if let timestamp = data["dateRegister"] as? Timestamp {
                    
                    let dateRegister = timestamp.dateValue()
                    dataUser = [CurrentUser(dateRegister: dateRegister,
                                            city: data["city"] as? String,
                                            firstName: data["firstName"] as? String,
                                            lastName: data["lastName"] as? String,
                                            birth: data["birth"] as? String,
                                            profileImageUrl: data["profileImageUrl"] as? String,
                                            roleUser: data["roleUser"] as? String,
                                            uid: data["uid"] as? String)]

                    self.callBack?(dataUser , true,"")
            }
        }
    }
//
//    func getProfessionDataUser() {
//
//        var profDataUser = [Professions]()
//
//        guard let currentUsers = Auth.auth().currentUser else { return }
//        infoUser = Users(user: currentUsers)
//
//        let db = Firestore.firestore()
//
//        db.collection("users")
//            .document(infoUser.userId)
//            .collection("userData")
//            .document("profession")
//            .addSnapshotListener { (snapshot, _) in
//
//                guard let snapshot = snapshot, snapshot.exists else {return}
//
//                guard let data = snapshot.data() else {return}
//                profDataUser = [Professions(aboutMe: data["aboutMe"] as? String,
//                                            experience: data["experience"] as? String,
//                                            profession: data["profession"] as? String)]
//
////                print(profDataUser)
//
//             self.callBack?(profDataUser , true,"")
//        }
//    }
    
    func getProfessionUserData() {
        
        var profDataUser = [ProfessionModel]()
        
        guard let currentUsers = Auth.auth().currentUser else { return }
        infoUser = Users(user: currentUsers)
        
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(infoUser.userId)
            .collection("userData")
            .document("profession")
            .addSnapshotListener { (snapshot, _) in
                
                guard let snapshot = snapshot, snapshot.exists else {return}
                
                guard let data = snapshot.data() else {return}
                
                do {
                    let json = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                    let reqJSONStr = String(data: json, encoding: .utf8)
                    let data = reqJSONStr?.data(using: .utf8)
                    let decoder = JSONDecoder()
                    let user = try decoder.decode(ProfessionModel.self, from: data!)
                    profDataUser.append(user)
                    self.callBack?(profDataUser, true,"")
                    
                } catch {
                    print(error.localizedDescription)
            }
        }
    }
    
    func getDataVacancies() {
        
        ref = Database.database().reference(withPath: "vacancies")
        
        ref.observe(.value) {(snapshot) in
            
            var _vacancies = Array<Vacancy>()
            for item in snapshot.children {
                let vacansy = Vacancy(snapshot: item as! DataSnapshot)
//                print(item)
                _vacancies.append(vacansy)
            }
            _vacancies.sort(by: {$0.timestamp > $1.timestamp})
            //            self.vacansyCallBack?(_vacancies, true,"")
            self.callBack?(_vacancies, true, "")
        }
    }
    
    func getFavoritesVacancies() {
        guard let currentUsers = Auth.auth().currentUser else { return }
        infoUser = Users(user: currentUsers)
        ref = Database.database().reference(withPath: "favorites_vacancies").child(infoUser.userId)
        
        ref.observe(.value) {(snapshot) in

            var _vacancies = Array<Favorite>()

            for item in snapshot.children {
                let vacancy = Favorite(snapshot: item as! DataSnapshot)
                _vacancies.append(vacancy)
            }
            self.callBack?(_vacancies, true, "")
        }
    }
    
    
    func completionHandler(callBack: @escaping callBack) {
        self.callBack = callBack
    }
}
