//
//  DetailViewController.swift
//  TapWork
//
//  Created by Sergey Vorobey on 12/05/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit
import Firebase

class DetailVacansyViewController: UIViewController {
    
    @IBOutlet weak var headingVacancyLbl: UILabel!
    @IBOutlet weak var categotyVacancyLbl: UILabel!
    @IBOutlet weak var cityVacancyLbl: UILabel!
    @IBOutlet weak var contentVacancyLbl: UILabel!
    @IBOutlet weak var paymentVacancyLbl: UILabel!
    @IBOutlet weak var publicationDateVacancyLbl: UILabel!
    @IBOutlet weak var countViewVacancyLbl: UILabel!
    @IBOutlet weak var responseButtonLabel: UIButton!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var detailVacancyMenuButton: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var backView: UIView!

    var detailVacancy: Vacancy?
    var checkVacancy: String?
    var countViewsVacancy: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupItems()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateCountViewsVacancy(views: countViewsVacancy,
                                userId: detailVacancy?.userId,
                                city: detailVacancy?.city,
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
        } else {
            detailVacancyMenuButton.isHidden = true
        }
    }
    
    private func setupItems() {
        
        checkStatusUser()
        backView.addCorner()
        backView.addShadow()
       
        detailVacancyMenuButton.addShadow()
        guard let detailVacancy = detailVacancy,
            let heading = headingVacancyLbl,
            let category = categotyVacancyLbl,
            let city = cityVacancyLbl,
            let content = contentVacancyLbl,
            let payment = paymentVacancyLbl,
            let publicationDate = publicationDateVacancyLbl,
            let response = responseButtonLabel,
            let countViews = countViewVacancyLbl,
            let countViewsVacancy = countViewsVacancy else {return}
        
         
        heading.text = detailVacancy.heading
        city.text = detailVacancy.city
        category.text = "not input"
        content.text = detailVacancy.content
        payment.text = detailVacancy.payment + " ₽ "
        let datePublic = detailVacancy.timestamp
        let date = Date(timeIntervalSince1970: datePublic / 1000)
        publicationDate.text = date.publicationDate(withDate: date)
        navigationBar.topItem?.title = "Вакансия от: \(date.publicationDate(withDate: date))"
        
        countViews.text = "\(countViewsVacancy)"
        
        response.changeStyleButton(with: "Откликнуться")
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    @IBAction func responseButton(_ sender: UIButton) {
        
        response()
        
     }
    
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    //TODO
    private func response() {
        
        let delay = 5
        
        self.errorAlert(title: "Успешно",
                       message: "Вы откликнулись на вакансию: Название вакансии, если работодателя заинтересует ваша кандидатура, с вами свяжуться!")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
}

//MARK: Collection view delegate, datasource
extension DetailVacansyViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCollectionCell", for: indexPath) as! MenuCollectionCell
        
        let index = indexPath.row
        
        switch index {
        case 0:
//            cell.imageMenu.image = UIImage(systemName: "star")
            cell.favoriteButtonLbl.setImage(UIImage(named: "FavoriteStar"), for: .normal)
//            cell.favoriteButtonLbl.setImage(UIImage(named: "FavoriteStarFill"), for: .selected)
            cell.favoriteButtonLbl.contentMode = .center
            cell.desriptionMenuLbl.text = "В избранное"
            cell.favoriteButtonLbl.addTarget(self, action: #selector(handleFavoritePressed), for: .touchUpInside)
        default:
            cell.favoriteButtonLbl.setImage(UIImage(named: "Share"), for: .normal)
//            cell.imageMenu.image = UIImage(systemName: "arrowshape.turn.up.right")
            cell.desriptionMenuLbl.text = "Поделиться"
            cell.favoriteButtonLbl.addTarget(self, action: #selector(handleSharePressed), for: .touchUpInside)
        }
        
        return cell
    }
    
    @objc func handleFavoritePressed() {
        print("added")
        addingFavoriteVacancy()
    }
    
    @objc func handleSharePressed() {
        let ac = UIActivityViewController(activityItems: [detailVacancy?.heading as Any], applicationActivities: nil)
        ac.popoverPresentationController?.sourceView = self.view
        ac.excludedActivityTypes = [.airDrop]
        self.present(ac, animated: true)
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        let index = indexPath.row
////        let arrayData = [detailVacancy?.heading, detailVacancy?.city, detailVacancy?.content, detailVacancy?.payment]
//        switch index {
//        case 0:
//        default:
//            let ac = UIActivityViewController(activityItems: [detailVacancy?.heading as Any], applicationActivities: nil)
//            ac.popoverPresentationController?.sourceView = self.view
//            ac.excludedActivityTypes = [.airDrop]
//            self.present(ac, animated: true)
//        }
//    }
}

//MARK: Firebase
extension DetailVacansyViewController {
    //MARK: update count views in Firebase
    private func updateCountViewsVacancy(views: Int?,
                                         userId: String?,
                                         city: String?,
                                         heading: String?,
                                         content: String?,
                                         phoneNumber: String?,
                                         payment: String?,
                                         completion: @escaping (AuthResult) -> Void) {
        
        guard let views = views,
            let userId = userId,
            let city = city,
            let heading = heading,
            let content = content,
            let phoneNumber = phoneNumber,
            let payment = payment,
            let timestamp = detailVacancy?.timestamp,
            let favoritesVacancies = detailVacancy?.favoritesVacancies else {
                completion(.failure(AuthError.unknownError))
                return}

        let ref = Database.database().reference(withPath: "vacancies")
        let values = [heading: [
            "userId": userId,
            "city": city,
            "heading": heading,
            "content": content,
            "phoneNumber": phoneNumber,
            "payment": payment,
            "timestamp": timestamp,
            "countViews": views,
            "favoritesVacancies": favoritesVacancies]
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
//
//        let vacancyRef = ref.child(detailVacancy!.heading)
//        vacancyRef.setValue(["userId": detailVacancy!.userId,
//                             "city": detailVacancy!.city,
//                             "heading": detailVacancy!.heading,
//                             "content": detailVacancy!.content,
//                             "phoneNumber": detailVacancy!.phoneNumber,
//                             "payment": detailVacancy!.payment,
//                             "timestamp": detailVacancy!.timestamp,
//                             "countViews": detailVacancy!.countViews])
        
        guard let views = detailVacancy?.countViews,
            let userId = detailVacancy?.userId,
            let city = detailVacancy?.city,
            let heading = detailVacancy?.heading,
            let content = detailVacancy?.content,
            let phoneNumber = detailVacancy?.phoneNumber,
            let payment = detailVacancy?.payment,
            let timestamp = detailVacancy?.timestamp,
            var favoritesVacancies = detailVacancy?.favoritesVacancies else {
                //                       completion(.failure(AuthError.unknownError))
                return}
        
        guard let currentUsers = Auth.auth().currentUser else { return }
        let infoUser = Users(user: currentUsers)
        let ref = Database.database().reference(withPath: "vacancies")
        favoritesVacancies.append(infoUser.userId)
        let values = [heading: [
            "userId": userId,
            "city": city,
            "heading": heading,
            "content": content,
            "phoneNumber": phoneNumber,
            "payment": payment,
            "timestamp": timestamp,
            "countViews": views + 1,
            "favoritesVacancies": favoritesVacancies
            ]
        ]
        ref.updateChildValues(values, withCompletionBlock: { (error, ref) in
            if(error != nil){
                print(error?.localizedDescription ?? "")
                return
            }
        })
    }
    
    private func deleteFavoriteVacancy() {
        
    }
}

