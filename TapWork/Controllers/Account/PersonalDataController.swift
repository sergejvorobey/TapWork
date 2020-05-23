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
    
    private var userData = [CurrentUser]()
    private var userStatus: String?

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
    
    // title + info button Employer Cell
    lazy var headerView: UIView = {
        
        let frame: CGRect = tableView.frame

        var label = UILabel()
        label = UILabel(frame: CGRect(x: 10, y: 10, width: 300, height: 20))
        label.text = "СЕРВИСЫ ДЛЯ РАБОТОДАТЕЛЕЙ"
        label.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.light)
        
        var infoButton = UIButton(frame: CGRect(x: frame.size.width - 50, y: 5, width: 30, height: 30))
        infoButton.setTitle("?", for: .normal)
        infoButton.setTitleColor(.black, for: .normal)
        infoButton.layer.cornerRadius = 15
        infoButton.layer.borderWidth = 0.3
        infoButton.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        
        let headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        headerView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        
        headerView.addSubview(infoButton)
        headerView.addSubview(label)
        return headerView
    }()
    
    @objc func buttonTapped(sender: UIButton) {
        
        self.showAlert(title: "Сервисы для работодателей",
                       message: """
                                В этом меню вы можете:
                                - Cоздавать
                                - Редактировать
                                - Удалять свои публикации
                                """)
    }
    
    private func exitAccount() {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "Назад", style: .default) { _ in }
        
        let signOutAcc = UIAlertAction(title: "Выйти из аккаунта", style: .destructive) { (actionSheet) in
            
            
            let alert = UIAlertController(title: "Выйти из аккаунта",
                                          message: "Вы уверенны что хотите выйти?",
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Выйти", style: .default, handler: { _ in
                
                do {
                    try Auth.auth().signOut()
                } catch {
                    print(error.localizedDescription)
                }
                let launchScreenVC = self.storyboard?.instantiateViewController(withIdentifier: "LaunchScreen")
                
                guard let launchSVC = launchScreenVC else { return }
                
                self.navigationController?.pushViewController(launchSVC, animated: true)
            }))
            
            alert.addAction(UIAlertAction(title: "Не выходить", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
        }
         
        actionSheet.addAction(signOutAcc)
        actionSheet.addAction(cancel)
        present(actionSheet, animated: true)
    }
    
    @IBAction func menuAccount(_ sender: UIBarButtonItem) {
       exitAccount()
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
        dataLoader.getDatabaseUser()
        
        dataLoader.completionHandler { [weak self] (user, status, message) in
            
            if status {
                guard let self = self else {return}
                guard let _user = user else {return}
                self.userData = _user as! [CurrentUser]
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

        if userStatus == "Ищу работу" {
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
        let indexSection = indexPath.section

        switch indexSection {
        case 0:
            let personalCell = tableView.dequeueReusableCell(withIdentifier: "PersonalDataCell", for: indexPath) as! PersonalDataCell
            
            personalCell.fullNameUser.text = data.fullName
            personalCell.emailUser.text = data.email
            
            if data.ageAndCity.isEmpty == true {
                personalCell.ageAndCityUser.text = data.city
            } else {
                personalCell.ageAndCityUser.text = data.ageAndCity
            }
           
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
        case 1:
            let profPersonalCell = tableView.dequeueReusableCell(withIdentifier: "ProfPersonalDataCell", for: indexPath) as! ProfPersonalDataCell
            profPersonalCell.accessoryType = .disclosureIndicator
            return profPersonalCell
        case 2:
            let employerCell = tableView.dequeueReusableCell(withIdentifier: "EmployerCell", for: indexPath) as! EmployerTableCell
            employerCell.accessoryType = .disclosureIndicator
            return employerCell
        default:
            break
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch section {
        case 0:
            return view.changeHeaderCell(title: "ПЕРСОНАЛЬНЫЕ ДАННЫЕ")
        case 1:
            return view.changeHeaderCell(title: "ПРОФЕССИОНАЛЬНЫЕ ДАННЫЕ И НАВЫКИ")
        case 2:
            return headerView
        default:
            break
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(40)
    }
      
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditProfileController" {
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


