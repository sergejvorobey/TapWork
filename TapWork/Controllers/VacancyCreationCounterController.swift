//
//  VacancyCreationCounterController.swift
//  TapWork
//
//  Created by Sergey Vorobey on 17/06/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit
import Firebase

class VacancyCreationCounterController: UIViewController {
    
    @IBOutlet weak var headerCountVacancyLbl: UILabel!
    @IBOutlet weak var descriptionMenuLbl: UILabel!
    @IBOutlet weak var createVacancyButtonLbl: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    
    private var currentUserVacancy = [Vacancy]()
    private var userProfileID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupItems()
        getProfileUserID()
        
        getVacancies {[weak self] (result) in
            switch result {
            case .success:
                //                self?.showActivityIndicator()
                break
            case .failure(let error):
                self?.errorAlert(title: "Ошибка", message: error.localizedDescription)
                
            }
        }
    }
    
    private func checkActiveVacanciesUser() {
        if currentUserVacancy.isEmpty {
            stackView.isHidden = false
            tableView.isHidden = true
            titleLbl.isHidden = true
        } else {
            stackView.isHidden = true
            tableView.isHidden = false
            titleLbl.isHidden = false
        }
    }
    
    private func setupItems() {
        //        tableView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        view.changeColorView()
        tableView.backgroundColor = UIColor.clear
        createVacancyButtonLbl.changeStyleButton(with: "Создать вакансию")
        headerCountVacancyLbl.text = "У вас пока нет активных вакасний"
        descriptionMenuLbl.text = "Создайте вакансию и найдите исполнителя"
        titleLbl.text = "Ваши активные вакансии"
    }
    
    @IBAction func createdVacancyButton(_ sender: UIButton) {
        performSegue(withIdentifier: "AddingVacansy", sender: nil)
    }
}

extension VacancyCreationCounterController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currentUserVacancy.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActiveVacanciesUserCell", for: indexPath) as! ActiveVacanciesUserCell
        
        let colorGray = UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1)
        let vacancy = currentUserVacancy[indexPath.row]
        
        cell.cellCurrentUser(color: colorGray)
        cell.headingVacancyLbl.text = vacancy.heading
        cell.cityVacancyLbl.text = vacancy.city
        //        cell.categoryVacancyLbl.text = vacancy.
        cell.contentVacancyLbl.text = vacancy.content
        cell.paymenVacancyLbl.text = vacancy.payment + " ₽ "
        
        let datePublic = vacancy.timestamp
        let date = Date(timeIntervalSince1970: datePublic / 1000)
        
        //                vacanciesCell.publicationDateLabel.text = date.calenderTimeSinceNow()
        cell.publicationDateLbl.text = date.publicationDate(withDate: date)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: Firebase services
extension VacancyCreationCounterController {
    
    //MARK: get vacancies
    private func getVacancies(completion: @escaping (AuthResult) -> Void) {
        guard Validators.isConnectedToNetwork()  else {
            completion(.failure(AuthError.serverError))
            return
        }
        
        let dataLoader = LoaderDataFirebase()
        dataLoader.getDataVacancies()
        
        dataLoader.completionHandler{[weak self] (vacansy, status, message) in
            var array = [Vacancy]()
            if status {
                guard let self = self else {return}
                guard let _vacansy = vacansy else {return}
                for item in _vacansy as! [Vacancy] {
                    if item.userId == self.userProfileID {
                        array.append(item)
                    }
                }
                self.currentUserVacancy = array
                self.checkActiveVacanciesUser()
            }
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        completion(.success)
    }
    
    //MARK: get user id
    private func getProfileUserID() {
        let dataLoader = LoaderDataFirebase()
        dataLoader.getProfileUserID()
        dataLoader.completionHandler {[weak self](userProfileID, status, message) in
            if status {
                
                guard let self = self else {return}
                guard let _userProfileID = userProfileID else {return}
                self.userProfileID = _userProfileID as? String
            }
        }
    }
}
