//
//  ProfileUserController.swift
//  TapWork
//
//  Created by Sergey Vorobey on 17/06/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit
import Firebase

class ProfileUserController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var userData = [CurrentUser]()
    private var profData = [ProfessionModel]()
    private var roleUser: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupItems()
    }
    
    private func setupItems() {
        navigationItem.title = "Личная информация"
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
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
        
        getUserProfData { (result) in
            switch result {
                
            case .success:
                break
            case .failure(let error):
                self.errorAlert(title: "Ошибка", message: error.localizedDescription)
                
            }
        }
    }
    
    @IBAction func exitAccountPressed(_ sender: UIBarButtonItem) {
        exitAccount()
    }
}

extension ProfileUserController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        
        switch index {
            
        case 0:
            let profileUserCell = tableView.dequeueReusableCell(withIdentifier: "ProfileUserCell", for: indexPath) as! ProfileUserCell
            profileUserCell.selectionStyle = .none
            let cornerRadius : CGFloat = 5.0
            profileUserCell.editBasicButtonLbl.setTitle("Редактировать профиль", for: .normal)
            profileUserCell.editBasicButtonLbl.setTitleColor(UIColor.black, for: .normal)
            profileUserCell.editBasicButtonLbl.backgroundColor = UIColor.clear
            profileUserCell.editBasicButtonLbl.layer.borderWidth = 1.0
            profileUserCell.editBasicButtonLbl.layer.borderColor = UIColor.black.cgColor
            profileUserCell.editBasicButtonLbl.layer.cornerRadius = cornerRadius
            
            for profile in userData {
                
                profileUserCell.fullNameLbl.text = profile.fullName
                profileUserCell.ageAndCityLbl.text = profile.ageAndCity
                profileUserCell.roleUserLbl.text = profile.roleUser
                
                let dateRegister = profile.dateRegister!
                let date = dateRegister.timeIntervalSince1970 * 1000
                let newDate = Date(timeIntervalSince1970: date / 1000)
                profileUserCell.dateRegisterLbl.text = "\(newDate.calenderTimeSinceNow()) на TapWork"
                
                profileUserCell.profileImage.changeStyleImage()
//                profileUserCell.profileImage.addShadow()
                if profile.profileImageUrl == "" {
                    profileUserCell.profileImage.image = #imageLiteral(resourceName: "userImage")
                } else {
                    let url = URL(string: profile.profileImageUrl!)
                    ImageService.getImage(withURL: url!) { (image) in
                        profileUserCell.profileImage.image = image
                    }
                }
            }
            return profileUserCell
        case 1:
            let professionUserCell = tableView.dequeueReusableCell(withIdentifier: "UserDescriptionCell", for: indexPath) as! UserDescriptionCell
            for item in profData {
                professionUserCell.professionLabel.text = "Профессия"
                professionUserCell.iconCell.image = UIImage(systemName: "person")
                if item.profession!.isEmpty {
                    professionUserCell.descriptionLabel.text = "Расскажите, кем вы хотите работать"
                } else {
                    professionUserCell.descriptionLabel.text = item.profession
                }
            }
            return professionUserCell
        case 2:
            let expUserCell = tableView.dequeueReusableCell(withIdentifier: "UserDescriptionCell", for: indexPath) as! UserDescriptionCell
            for item in profData {
                expUserCell.professionLabel.text = "Опыт работы"
                expUserCell.iconCell.image = UIImage(systemName: "bolt")
                if (item.experience?.places.isEmpty)! {
                    expUserCell.descriptionLabel.text = "Расскажите, про ваш опыт работы"
                } else {
                    if let placesCount = item.experience?.places.count {
                        switch placesCount {
                        case 1:
                            expUserCell.descriptionLabel.text = "Вы указали: \(placesCount) место"
                        case 2...4:
                            expUserCell.descriptionLabel.text = "Вы указали: \(placesCount) места"
                        default:
                            expUserCell.descriptionLabel.text = "Вы указали: \(placesCount) мест"
                        }
                    }
                }
            }
            return expUserCell
        case 3:
            let aboutMeUserCell = tableView.dequeueReusableCell(withIdentifier: "UserDescriptionCell", for: indexPath) as! UserDescriptionCell
            
            for item in profData {
                aboutMeUserCell.professionLabel.text = "О себе"
                aboutMeUserCell.iconCell.image = UIImage(systemName: "info.circle")
                if item.aboutMe!.isEmpty {
                    aboutMeUserCell.descriptionLabel.text = "Есть еще что-нибудь, что стоит рассказать?"
                } else {
                    aboutMeUserCell.descriptionLabel.text = item.aboutMe
                }
            }
            return aboutMeUserCell
        default:
            break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let index = indexPath.row
        
        switch index {
        case 1:
            let categoriesController = self.storyboard?.instantiateViewController(withIdentifier: "CategoriesController") as! CategoriesController
            let navController = UINavigationController(rootViewController: categoriesController)
            navigationController?.present(navController, animated: true, completion: nil)
        case 2:
            performSegue(withIdentifier: "ExperienceUserController", sender: nil)
        case 3:
            performSegue(withIdentifier: "AdditionaInfolUserController", sender: nil)
        default:
            break
        }
    }
}

//MARK: Navigation
extension ProfileUserController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "EditProfileController":
            let editProfileVC = segue.destination as! EditAccountViewController
            for data in userData {
                editProfileVC.user = data
            }
        case "ExperienceUserController":
            let experienceVC = segue.destination as! ExperienceUserController
            for data in profData {
                guard let dataExp = data.experience else {
                    return
                }
                experienceVC.experienceUser = dataExp.places as! [Places]
            }
        case "AdditionaInfolUserController":
            let additionalInfoVC = segue.destination as! AdditionaInfolUserController
            for index in profData {
                additionalInfoVC.aboutMeText = index.aboutMe
            }
        default:
            break
        }
    }
}

//MARK: exit user account
extension ProfileUserController {
    
    private func exitAccount() {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "Назад", style: .cancel)
        
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

//MARK: Get data in Firebase
extension ProfileUserController {
    
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
            }
            for status in self!.userData {
                self!.roleUser = status.roleUser
            }
        }
    }
    
    private func getUserProfData(completion: @escaping (AuthResult) -> Void) {
        guard Validators.isConnectedToNetwork()  else {
            completion(.failure(AuthError.serverError))
            return
        }
        let dataLoader = LoaderDataFirebase()
        //        dataLoader.getProfessionDataUser()
        dataLoader.getProfessionUserData()
        
        dataLoader.completionHandler { [weak self] (user, status, message) in
            
            if status {
                guard let self = self else {return}
                guard let _user = user else {return}
                self.profData = _user as! [ProfessionModel]
                self.tableView.reloadData()
            }
        }
        completion(.success)
    }
}
