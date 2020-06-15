//
//  ProfessionController.swift
//  TapWork
//
//  Created by Sergey Vorobey on 02/06/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit

class ProfessionController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
//    private var profUserData = [Professions]()
    private var profData = [ProfessionModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self

//        tableView.isScrollEnabled = false
        tableView.backgroundColor = UIColor.clear
        view.backgroundColor = UIColor.clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        getUserProfData { (result) in
            switch result {
                
            case .success:
                break
            case .failure(let error):
                self.errorAlert(title: "Ошибка", message: error.localizedDescription)
                
            }
        }
    }

    //MARK: Get data
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

// MARK: - Table view data source
extension ProfessionController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
        let index = indexPath.row
//        cell.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.white

        for item in profData {
            switch index {
            case 0:
                cell.professionLabel.text = "Профессия"
                cell.iconCell.image = #imageLiteral(resourceName: "Specialization")
                if item.profession!.isEmpty {
                    cell.descriptionLabel.text = "Расскажите, кем вы хотите работать"
                } else {
                    cell.descriptionLabel.text = item.profession
                }
            case 1:
                cell.professionLabel.text = "Опыт работы"
                cell.iconCell.image = #imageLiteral(resourceName: "timeWork")
                if (item.experience?.places.isEmpty)! {
                    cell.descriptionLabel.text = "Расскажите, про ваш опыт работы"
                } else {
                    cell.descriptionLabel.text = "Вы указали: \(item.experience?.places.count ?? 0) места"
                }
            case 2:
                cell.professionLabel.text = "О себе"
                cell.iconCell.image = #imageLiteral(resourceName: "info")
                if item.aboutMe!.isEmpty {
                    cell.descriptionLabel.text = "Есть еще что-нибудь, что стоит рассказать?"
                } else {
                    cell.descriptionLabel.text = item.aboutMe
                }
            default:
                break
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let index = indexPath.row
        
        switch index {
        case 0:
            let categoriesController = self.storyboard?.instantiateViewController(withIdentifier: "CategoriesController") as! CategoriesController
            let navController = UINavigationController(rootViewController: categoriesController)
            navigationController?.present(navController, animated: true, completion: nil)
        case 1:
            performSegue(withIdentifier: "ExperienceUserController", sender: nil)
        case 2:
            performSegue(withIdentifier: "AdditionaInfolUserController", sender: nil)
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
//        guard let indexPath = tableView.indexPathForSelectedRow else { return }
//        let professionData = profUserData[indexPath.row]
//
        switch segue.identifier {
            
        case "AdditionaInfolUserController":
            let additionalInfoVC = segue.destination as! AdditionaInfolUserController
            for index in profData {
                additionalInfoVC.aboutMeText = index.aboutMe
            }
        case "ExperienceUserController":
            let experienceVC = segue.destination as! ExperienceUserController
            for data in profData {
                guard let dataExp = data.experience else {
                    return
                }
                experienceVC.experienceUser = dataExp.places as! [Places]
            }
        default:
            break
//        if segue.identifier == "AdditionaInfolUserController" {
//            let additionalInfoVC = segue.destination as! AdditionaInfolUserController
//            for index in profData {
//                additionalInfoVC.aboutMeText = index.aboutMe
//            }
        }
    }
}
    


