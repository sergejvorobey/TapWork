//
//  ExperienceUserController.swift
//  TapWork
//
//  Created by Sergey Vorobey on 08/06/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit
import Firebase

class ExperienceUserController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createExperianceButtonLbl: UIButton!
    @IBOutlet weak var buttonView: UIView!
    
    var experienceUser = [Places]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        checkData()
        navigationItem.title = "Опыт работы"
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "",
                                                        style: .plain,
                                                        target: nil, action: nil)
        }
        createExperianceButtonLbl.changeStyleButton(with: "Добавить опыт работы")
        tableView.delegate = self
        tableView.dataSource = self
        buttonView.addShadow()
    }
    
    @IBAction func createExperiancePressed(_ sender: UIButton) {
//        performSegue(withIdentifier: "CreateExperianceController", sender: nil)
    }
    
    private func checkData() {
//        print(experienceUser.count)
//        if experienceUser.isEmpty  {
//            tableView.isHidden = true
//        } else {
//            tableView.isHidden = false
//        }

    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
     override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(true)
         
//        tableView.reloadData()
     }
}

extension ExperienceUserController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return experienceUser.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExperienceUserCell", for: indexPath) as! ExperienceUserCell
        let data = experienceUser[indexPath.row]
        cell.namePlaceLabel.text = data.namePlace
        cell.professionLabel.text = data.profession
        cell.responsibilityLabel.text = data.responsibility
        cell.durationLabel.text = data.duration
  
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditExperience" {
            let editExperience = segue.destination as! CreateExperianceController
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let place = experienceUser[indexPath.row]
            editExperience.expDataUser = place
            editExperience.indexArray = indexPath.row
        }
        
        switch segue.identifier {
        case "EditExperience":
            let editExperience = segue.destination as! CreateExperianceController
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let place = experienceUser[indexPath.row]
            editExperience.expDataUser = place
            editExperience.indexArray = indexPath.row
            editExperience.transitionStatus = "EDIT_EXPERIENCE"
        case "CreateExperianceController":
            let editExperience = segue.destination as! CreateExperianceController
            editExperience.transitionStatus = "CREATE_EXPERIENCE"
        default:
            break
        }
    }
}
