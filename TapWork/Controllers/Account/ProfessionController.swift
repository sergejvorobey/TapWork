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
    
    private var profUserData = [Professions]()
    
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
                self.showAlert(title: "Ошибка", message: error.localizedDescription)
                
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
        dataLoader.getProfessionDataUser()
        
        dataLoader.completionHandler { [weak self] (user, status, message) in
            
            if status {
                guard let self = self else {return}
                guard let _user = user else {return}
                self.profUserData = _user as! [Professions]
                
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
        cell.backgroundColor = UIColor.clear
        
        for item in profUserData {
            switch index {
            case 0:
                cell.professionLabel.text = "Профессия"
                cell.descriptionLabel.text = item.profession
                cell.iconCell.image = #imageLiteral(resourceName: "Specialization")
            case 1:
                cell.professionLabel.text = "Опыт работы"
                cell.descriptionLabel.text = item.experience
                cell.iconCell.image = #imageLiteral(resourceName: "timeWork")
            case 2:
                cell.professionLabel.text = "О себе"
                cell.descriptionLabel.text = item.aboutMe
                cell.iconCell.image = #imageLiteral(resourceName: "info")
            default:
                break
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            let categoriesController = self.storyboard?.instantiateViewController(withIdentifier: "CategoriesController") as! CategoriesController
            let navController = UINavigationController(rootViewController: categoriesController)
            navigationController?.present(navController, animated: true, completion: nil)
        }
    }
}
    


