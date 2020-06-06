//
//  ProfileController.swift
//  TapWork
//
//  Created by Sergey Vorobey on 31/05/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit
import Firebase

class ProfileController: UIViewController {
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var ageAndCityLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var dateRegisterLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var editBasicLabel: UIButton!
    
    @IBOutlet weak var professionContainerView: UIView!
    @IBOutlet weak var employerContainerView: UIView!
    
    private var userData = [CurrentUser]()
    private var roleUser: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setItemsStyle()
        professionContainerView.backgroundColor = UIColor.clear
        employerContainerView.backgroundColor = UIColor.clear
        
    }
    
    //MARK: setup style items in controller
    private func setItemsStyle() {
        
//        let color = UIColor(red: 66/255, green: 103/255, blue: 178/255, alpha: 1)
   
        navigationItem.title = "Личная информация"
        navigationItem.rightBarButtonItem?.tintColor = .black
 
//        let borderAlpha : CGFloat = 0.7
        let cornerRadius : CGFloat = 5.0
        editBasicLabel.setTitle("Редактировать профиль", for: .normal)
        editBasicLabel.setTitleColor(UIColor.black, for: .normal)
        editBasicLabel.backgroundColor = UIColor.clear
        editBasicLabel.layer.borderWidth = 1.0
        editBasicLabel.layer.borderColor = UIColor.black.cgColor
        editBasicLabel.layer.cornerRadius = cornerRadius
    }
    
    @IBAction func pressedEditBasic(_ sender: UIButton) {
        performSegue(withIdentifier: "EditProfileController", sender: nil)
    }
    
    @IBAction func exitAccountPressed(_ sender: UIBarButtonItem) {
       exitAccount()
    }
    
    //MARK: check role user after login
    private func checkRoleUser() {
        if self.roleUser == "Ищу работу" {
            professionContainerView.isHidden = false
            employerContainerView.isHidden = true
            self.view.addSubview(professionContainerView)
        } else {
            professionContainerView.isHidden = true
            employerContainerView.isHidden = false
            self.view.addSubview(employerContainerView)
        }
    }
    
    //MARK: parse user data
    private func getCurrentUserData(completion: @escaping (AuthResult) -> Void) {
        
        guard Validators.isConnectedToNetwork()  else {
            completion(.failure(AuthError.serverError))
            return
        }
        
        let dataLoader = LoaderDataFirebase()
        dataLoader.getDatabaseUserBasic()
        
        dataLoader.completionHandler { [weak self] (user, status, message) in
            
            if status {
                guard let self = self else {return}
                guard let _user = user else {return}
                self.userData = _user as! [CurrentUser]
                
                for data in self.userData {
                    
                    self.fullNameLabel.text = data.fullName
                    self.statusLabel.text = data.roleUser
//                    self.statusLabel.styleLabel(with: data.roleUser!)
                    
                    if data.birth == "" {
                        self.ageAndCityLabel.text = data.city
                    } else {
                        self.ageAndCityLabel.text = data.ageAndCity
                    }
                    
                    let dateRegister = data.dateRegister!
                    let date = dateRegister.timeIntervalSince1970 * 1000
                    let newDate = Date(timeIntervalSince1970: date / 1000)
                    self.dateRegisterLabel.text = "\(newDate.calenderTimeSinceNow()) на TapWork"
                    
                    
                    self.profileImage.changeStyleImage()
                    if data.profileImageUrl == "" {
                        self.profileImage.image = #imageLiteral(resourceName: "userImage")
                    } else {
                        let url = URL(string: data.profileImageUrl!)
                        ImageService.getImage(withURL: url!) { (image) in
                            self.profileImage.image = image
                        }
                    }
                }
                for status in self.userData {
                    self.roleUser = status.roleUser
                    self.checkRoleUser()
                }
            }
        }
        completion(.success)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        getCurrentUserData { (result) in
            switch result {
                
            case .success:
                break
            case .failure(let error):
                self.errorAlert(title: "Ошибка", message: error.localizedDescription)
                
            }
        }
    }
}

extension ProfileController {
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditProfileController" {
            //            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            //            let user = userData[indexPath.row]
            let editProfileVC = segue.destination as! EditAccountViewController
            //            editProfileVC.user = (userData as? CurrentUser?)!
            for data in userData {
                editProfileVC.user = data
            }
        }
    }
}

extension ProfileController {
    
    //MARK: method exit user account
    private func exitAccount() {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "Назад", style: .default)
        
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
}
