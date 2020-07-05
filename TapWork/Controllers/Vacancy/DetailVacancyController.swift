//
//  DetailViewController.swift
//  TapWork
//
//  Created by Sergey Vorobey on 12/05/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit
import Firebase

class DetailVacancyController: UIViewController {
    
    @IBOutlet weak var responseButtonLabel: UIButton!
    @IBOutlet weak var detailVacancyMenuButton: UIView!
    @IBOutlet weak var favoriteBtn: UIBarButtonItem!
    @IBOutlet weak var shareBtn: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var detailVacancy: Vacancy?
    var checkVacancy: String?
    var countViewsVacancy: Int?
    private var favoriteVacancies = [Favorite]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupItems()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        checkFavoriteVacancyInDB()
        
        let dataLoader = LoaderDataFirebase()
        dataLoader.getFavoritesVacancies()
        
        dataLoader.completionHandler{[weak self] (vacancy, status, message) in
            if status {
                guard let self = self else {return}
                guard let _vacancy = vacancy else {return}
                self.favoriteVacancies = _vacancy as! [Favorite]
            }
        }
        
        
        
    }
    
    //MARK: update count views vacancy
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        updateCountViewsVacancy(views: countViewsVacancy,
                                userId: detailVacancy?.userId,
                                city: detailVacancy?.city,
                                category: detailVacancy?.category,
                                heading: detailVacancy?.heading,
                                content: detailVacancy?.content,
                                phoneNumber: detailVacancy?.phoneNumber,
                                payment: detailVacancy?.payment) { (result) in
                                    
                                    switch result {
                                    case .success:
                                        break
                                    case .failure(let error):
                                        print(error.localizedDescription)
                                    }
        }
    }
    
    private func checkStatusUser() {
        if checkVacancy == nil {
            detailVacancyMenuButton.isHidden = false
            favoriteBtn.isEnabled = true
        } else {
            detailVacancyMenuButton.isHidden = true
            favoriteBtn.isEnabled = false
        }
    }
    
    private func setupItems() {
        checkStatusUser()
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        guard let topItem = navigationController?.navigationBar.topItem else {return}
        topItem.backBarButtonItem = UIBarButtonItem(title: "",
                                                    style: .plain,
                                                    target: nil, action: nil)
        
        navigationItem.title = "Вакансия"
        detailVacancyMenuButton.addShadow()
        responseButtonLabel.changeStyleButton(with: "Откликнуться")
        
//        shareBtn.action = #selector(handleSharePressed(sender:))
//        shareBtn.target = self
//        favoriteBtn.action = #selector(handleFavoritePressed(sender:))
//        favoriteBtn.target = self
    }
//
//    @objc func handleFavoritePressed(sender: UIBarButtonItem) {
//        addingFavoriteVacancy()
//    }
    
//    @objc func handleSharePressed(sender: UIBarButtonItem) {
//        let ac = UIActivityViewController(activityItems: [detailVacancy?.heading as Any], applicationActivities: nil)
//        ac.popoverPresentationController?.sourceView = self.view
//        ac.excludedActivityTypes = [.airDrop]
//        self.present(ac, animated: true)
//    }

    @IBAction func responseButton(_ sender: UIButton) {
        response()
     }
    
    @IBAction func shareBtnPressed(_sender: UIBarButtonItem) {
        let ac = UIActivityViewController(activityItems: [detailVacancy?.heading as Any], applicationActivities: nil)
        ac.popoverPresentationController?.sourceView = self.view
        ac.excludedActivityTypes = [.airDrop]
        self.present(ac, animated: true)
    }
    
    @IBAction func favoriteBtnPressed(_sender: UIBarButtonItem) {
        addingFavoriteVacancy()
    }
    
    //TODO
    private func response() {
        let delay = 3
        self.errorAlert(title: "Успешно",
                        message: "")
//                       message: "Вы откликнулись на вакансию: Название вакансии, если работодателя заинтересует ваша кандидатура, с вами свяжуться!")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
}

extension DetailVacancyController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let indexCell = indexPath.row
        switch indexCell {
        case 0:
            let headingCell = tableView.dequeueReusableCell(withIdentifier: "DetailVacancyCell", for: indexPath) as! DetailVacancyCell
            headingCell.headingLbl.text = detailVacancy?.heading
            headingCell.cityVacancyLbl.text = detailVacancy?.city
            headingCell.categoryVacancyLbl.styleLabel(with: detailVacancy!.category)
            headingCell.selectionStyle = .none
            return headingCell
        case 1:
            let contentCell = tableView.dequeueReusableCell(withIdentifier: "DetailVacancyContentCell", for: indexPath) as! DetailVacancyContentCell
            contentCell.contentLbl.text = detailVacancy?.content
            contentCell.paymentLbl.text = detailVacancy!.payment + " ₽ "
            contentCell.selectionStyle = .none
            return contentCell
        case 2:
            let countViewsCell = tableView.dequeueReusableCell(withIdentifier: "DetailCountViewCell", for: indexPath) as! DetailCountViewCell
            if let datePublic = detailVacancy?.timestamp {
            let date = Date(timeIntervalSince1970: datePublic / 1000)
            countViewsCell.publicationDateLbl.text = date.publicationDate(withDate: date)
            }
            countViewsCell.countViewsLbl.text = "\(countViewsVacancy ?? 0)"
            countViewsCell.selectionStyle = .none
            return countViewsCell
        default:
           break
        }
        return UITableViewCell()
    }
}


//MARK: Firebase
extension DetailVacancyController {
    //MARK: update count views in Firebase
    private func updateCountViewsVacancy(views: Int?,
                                         userId: String?,
                                         city: String?,
                                         category: String?,
                                         heading: String?,
                                         content: String?,
                                         phoneNumber: String?,
                                         payment: String?,
                                         completion: @escaping (AuthResult) -> Void) {
        
        guard let views = views,
            let userId = userId,
            let city = city,
            let category = category,
            let heading = heading,
            let content = content,
            let phoneNumber = phoneNumber,
            let payment = payment,
            let timestamp = detailVacancy?.timestamp
            else {
                completion(.failure(AuthError.unknownError))
                return }

        let ref = Database.database().reference(withPath: "vacancies")
        let values = [detailVacancy?.key: [
            "userId": userId,
            "city": city,
            "category": category,
            "heading": heading,
            "content": content,
            "phoneNumber": phoneNumber,
            "payment": payment,
            "timestamp": timestamp,
            "countViews": views
            ]
        ]
        ref.updateChildValues(values, withCompletionBlock: { (error, ref) in
            if(error != nil){
                print(error?.localizedDescription ?? "")
                return
            }
        })
        completion(.success)
    }
    
    private func addingFavoriteVacancy() {
        
//        guard let currentUsers = Auth.auth().currentUser else { return }
//        let infoUser = Users(user: currentUsers)
//        let ref = Database.database().reference(withPath: "favorites_vacancies")
//        guard let keyCurrentVacancy = detailVacancy?.key else { return }
//        let vacancyRef = ref.child(infoUser.userId)
//        var transformed = favoriteVacancies.compactMap { $0.keys }
//
//        var action = [String]()
//        print("текущий ключ вакансии: \(keyCurrentVacancy)")
//        for currentKey in 0..<transformed.count {
//            if transformed[currentKey] != keyCurrentVacancy {
//                action = transformed
//                action.append(keyCurrentVacancy)
//                vacancyRef.setValue(action)
//            } else {
////                action =
//            }
//        }
    }
    
    private func checkFavoriteVacancyInDB() {
        //  если мой ИД уже есть в массиве "избранное" -- тогда кнопка заполнена
        //  если НЕТ -- кнопка пустая
//        guard let currentUsers = Auth.auth().currentUser else { return }
//        let infoUser = Users(user: currentUsers)
//        //
//        //        guard let favorites = detailVacancy?.favoritesVacancies else {return}
//        //
//        for (key, value) in favoriteVacancies.enumerated() {
//            let keys = "\(value)"
//            if infoUser.userId == keys {
//                ////                print("ID detected")
////                print(key,value)
//
//                favoriteBtn.image = UIImage(systemName: "star.fill")
//            } else {
//                print("ID not found")
//                favoriteBtn.image = UIImage(systemName: "star")
//            }
//        }
    }
    
    
    private func deleteFavoriteVacancy() {
        
    }
}

