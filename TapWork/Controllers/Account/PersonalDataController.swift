//
//  PersonalDataController.swift
//  TapWork
//
//  Created by Sergey Vorobey on 16/05/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit
import Firebase

class PersonalDataController: UITableViewController {
    
//    let sectionHeaderHeight: CGFloat = 25
    private var userData = [CurrentUser]()
    private var userStatus: String?
//    private var currentData = LoaderUserData().userDataArray

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Личный кабинет"
        tableView.tableFooterView = UIView()
        tableView.addSubview(refreshControll)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        getCurrentUserData { (result) in
            switch result {

            case .success:
                break
            case .failure(let error):
                self.showAlert(title: "Ошибка", message: error.localizedDescription)

            }
        }
    }
    
    @IBAction func menuAccount(_ sender: UIBarButtonItem) {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "Назад", style: .default) { _ in }
        let signOutAcc = UIAlertAction(title: "Выйти из аккаунта", style: .destructive) {[weak self] _ in
            
            do {
                try Auth.auth().signOut()
                
            } catch {
                print(error.localizedDescription)
            }
            let launchScreenVC = self?.storyboard?.instantiateViewController(withIdentifier: "LaunchScreen")
            
            guard let launchSVC = launchScreenVC else { return }
            
            self?.navigationController?.pushViewController(launchSVC, animated: true)
        }
        
        actionSheet.addAction(signOutAcc)
        actionSheet.addAction(cancel)
        present(actionSheet, animated: true)
    }
    
    
    // refresh spinner
       private lazy var refreshControll: UIRefreshControl = {
           let refreshControll = UIRefreshControl()
           refreshControll.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControl.Event.valueChanged)
           refreshControll.tintColor = UIColor.red
           return refreshControll
           
       }()
       
       @objc func handleRefresh(_ refreshControll: UIRefreshControl) {
           self.tableView.reloadData()
           let deadline = DispatchTime.now() + .milliseconds(700)
           DispatchQueue.main.asyncAfter(deadline: deadline, execute: {
               refreshControll.endRefreshing()
           })
       }
    
    //MARK: parse user data
    private func getCurrentUserData(completion: @escaping (AuthResult) -> Void) {
        
        guard Validators.isConnectedToNetwork()  else {
            completion(.failure(AuthError.serverError))
            return
        }
        
        let dataLoader = LoaderDataFirebase()
        dataLoader.refDatebase()
        
        dataLoader.completionHandler { [weak self] (user, status, message) in
            
            if status {
                guard let self = self else {return}
                guard let _user = user else {return}
                self.userData = _user
//                print(self.userData)
                for status in self.userData {
                    self.userStatus = status.roleUser
                }
                self.tableView.reloadData()
            }
        }
        completion(.success)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {

        if userStatus == "Соискатель" {
            return 2
        } else {
            return 3
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = userData[indexPath.row]

        if indexPath.section == 0 {
            
            let personalCell = tableView.dequeueReusableCell(withIdentifier: "PersonalDataCell", for: indexPath) as! PersonalDataCell
            
            personalCell.fullNameUser.text = data.fullName
            personalCell.emailUser.text = data.email
            personalCell.ageAndCityUser.text = data.birth//TODO

            let dateRegister = data.dateRegister!

            personalCell.dateRegister.text = "На сайте с: \(dateRegister.dateRegister())"
            
            personalCell.imageUser.changeStyleImage()
            
            if data.profileImageUrl == "" {
                personalCell.imageUser.image = #imageLiteral(resourceName: "userImage")
            } else {
                let url = URL(string: data.profileImageUrl!)
                ImageService.getImage(withURL: url!) { (image) in
                    personalCell.imageUser.image = image
                }
            }
            
            personalCell.accessoryType = .disclosureIndicator
            
            return personalCell
            
        } else if indexPath.section == 1 {
            
            let profPersonalCell = tableView.dequeueReusableCell(withIdentifier: "ProfPersonalDataCell", for: indexPath) as! ProfPersonalDataCell
            profPersonalCell.accessoryType = .disclosureIndicator
            return profPersonalCell
        } else {
            
            let employerCell = tableView.dequeueReusableCell(withIdentifier: "EmployerCell", for: indexPath) as! EmployerTableCell
            employerCell.accessoryType = .disclosureIndicator
            return employerCell
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Персональные данные"
        } else if section == 1 {
            return "Профессиональные данные и навыки"
        } else {
            return "Сервисы для работодателя"
        }
        
//        switch section {
//        case 0:
//            return "Персональные данные"
//        case 1:
//            return "Обо мне"
//        case 2:
//            return "Для работодателя"
//        default:
//            break
//        }
    
    }
    
      
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditProfileController" {
            //                segue.destination.transitioningDelegate = self
            //                segue.destination.modalPresentationStyle = .custom
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let user = userData[indexPath.row]
            let editProfileVC = segue.destination as! EditAccountViewController
            editProfileVC.user = user
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
