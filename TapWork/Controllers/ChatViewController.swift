//
//  ChatViewController.swift
//  TapWork
//
//  Created by Sergey Vorobey on 02/04/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase


class ChatViewController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInputComponents()

        tabBarController?.tabBar.isHidden = true
        
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "",
                                                        style: .plain,
                                                        target: nil, action: nil)
        }
    }
    
    private lazy var messageTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    func setupInputComponents() {
        
        //container view with chat content
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        //send button
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(sendButton)
        
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        
        //message content with send button
        containerView.addSubview(messageTextField)
        messageTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10).isActive = true
        messageTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        messageTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        messageTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        //separator line chats to message text field
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLineView)
        
        separatorLineView.heightAnchor.constraint(equalToConstant: 0.3).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
    }
    
    //logic send message to Firebase
    @objc func handleSend() {
        
        var ref: DatabaseReference!
        let db = Firestore.firestore()
        var infoUser: Users!
        
        guard let currentUsers = Auth.auth().currentUser else { return }
        infoUser = Users(user: currentUsers)

        db.collection("users").document(infoUser.userId).addSnapshotListener {[weak self] querySnapshot, error in
            
            guard let querySnapshot = querySnapshot, querySnapshot.exists else {return}
            
            guard let userData = querySnapshot.data() else {return}
            
            if error != nil {
//                completion(.failure(error!))
                print(error!.localizedDescription)
                return
                
            } else {
                let firstName = userData["firstName"]
                //                let email = userData["email"]
                let lastName = userData["lastName"]

                ref = Database.database().reference().child("messages")
                let childRef = ref.childByAutoId()
                let text = ["text": self?.messageTextField.text,
                            "firstName": firstName,
                            "lastName": lastName]
                childRef.updateChildValues(text as [AnyHashable : Any])
                
            }
//            completion(.success)
        }
    }
}

