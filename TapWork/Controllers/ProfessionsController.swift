//
//  ProfessionsController.swift
//  TapWork
//
//  Created by Sergey Vorobey on 05/05/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit
import Firebase

class ProfessionsController: UITableViewController {
    
    @IBOutlet weak var saveButtonForProfile: UIBarButtonItem!
    @IBOutlet weak var saveButtonForCreateVacancy: UIBarButtonItem!
    
    var professions = [String]()
    var checkItem: String = ""
    var markerForSelectProfession = ""
    private var infoUser: Users!
    private let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        navigationItem.title = "Профессия"
        //        print(markerForSelectProfession)
        checkMarker()
    }
    
    private func checkMarker() {
        if markerForSelectProfession == "" {
            saveButtonForCreateVacancy.isEnabled = false
            saveButtonForProfile.isEnabled = true
        } else {
            saveButtonForProfile.isEnabled = false
            saveButtonForCreateVacancy.isEnabled = true
        }
    }
    
    @IBAction func okPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        // TODO
        guard let currentUsers = Auth.auth().currentUser else { return }
        infoUser = Users(user: currentUsers)
        
        db.collection("users")
            .document(infoUser.userId)
            .collection("userData")
            .document("profession").updateData(["profession": checkItem])
        dismiss(animated: true, completion: nil)
    }
    
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return professions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let professionCell = tableView.dequeueReusableCell(withIdentifier: "ProfessionCell", for: indexPath) as! ProfessionCell
        
        let profession = professions[indexPath.row]
        
        professionCell.professionLabel.text = profession
        
        return professionCell
    }
    
    //    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //
    //        guard let indexPath = tableView.indexPathForSelectedRow,
    //            let selectedRow: UITableViewCell = tableView.cellForRow(at: indexPath) else { return }
    //
    //        let profName = professions[indexPath.row]
    ////
    ////        if selectedRow.accessoryType == .checkmark {
    ////            checkItem.removeLast()
    ////            selectedRow.accessoryType = .none
    ////
    ////        } else {
    ////
    ////            selectedRow.accessoryType = .checkmark
    ////            //            print("Выбрано: \(String(describing: profName)) \(indexPath)")
    ////            checkItem.append(profName)
    ////            selectedRow.tintColor = UIColor.red
    ////        }
    ////        print("Выбрано: \(String(describing: profName)) \(indexPath)")
    //
    //
    //        tableView.deselectRow(at: indexPath, animated: true)
    //
    //    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .checkmark
        let profName = professions[indexPath.row]
        checkItem = profName
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .none
        checkItem = ""
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
