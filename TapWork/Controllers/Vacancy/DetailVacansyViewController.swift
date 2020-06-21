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
    @IBOutlet weak var responseButtonLabel: UIButton!
    
    @IBOutlet weak var deleteVacancyButtonLbl: UIButton!
    @IBOutlet weak var navigationBar: UINavigationBar!

    var detailVacancy: Vacancy?
    var checkVacancy: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupItems()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
    }
    
    private func checkStatusUser() {
        if checkVacancy == nil {
            responseButtonLabel.isHidden = false
            deleteVacancyButtonLbl.isHidden = true
        } else {
            responseButtonLabel.isHidden = true
            deleteVacancyButtonLbl.isHidden = false
        }
    }
    
    private func setupItems() {
        
        deleteVacancyButtonLbl.isHidden = true
        checkStatusUser()
        guard let detailVacancy = detailVacancy,
            let heading = headingVacancyLbl,
            let category = categotyVacancyLbl,
            let city = cityVacancyLbl,
            let content = contentVacancyLbl,
            let payment = paymentVacancyLbl,
            let publicationDate = publicationDateVacancyLbl,
            let response = responseButtonLabel,
            let complain = deleteVacancyButtonLbl else {return}
        
        heading.text = detailVacancy.heading
        city.text = detailVacancy.city
        category.text = "not input"
        content.text = detailVacancy.content
        payment.text = detailVacancy.payment + " ₽ "
        let datePublic = detailVacancy.timestamp
        let date = Date(timeIntervalSince1970: datePublic / 1000)
        publicationDate.text = date.publicationDate(withDate: date)
        response.changeStyleButton(with: "Откликнуться")
        complain.changeStyleButton(with: "Удалить вакаснию")
    }
    
    @IBAction func favoriteVacansy(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func responseButton(_ sender: UIButton) {
        
        response()
        
     }
    
    @IBAction func deleteVacancyButton(_ sender: UIButton) {
         
        deleteVacancy(title: detailVacancy!.heading, userID: detailVacancy!.userId) { (result) in
            switch result {
                
            case .success:
                self.successAlert(title: "Удалено!", message: "Вакансия удалена успешно")
//                self.view.activityStopAnimating()
                break
            case .failure(_):
                self.errorAlert(title: "Ошибка!", message: "Ошибка удаления")
            }
        }
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

//MARK: Firebase
extension DetailVacansyViewController {
    
    private func deleteVacancy(title: String, userID: String, completion: @escaping (AuthResult) -> Void) {
        
       
        //check empty
        //check network
        guard Validators.isConnectedToNetwork() else {
            completion(.failure(AuthError.serverError))
            return
        }
        
        if title == detailVacancy?.heading && userID == detailVacancy?.userId {
//            print("delete")
            let db = Database.database()
            guard let titleVacancy = detailVacancy?.heading else {return}
            db.reference().child("vacancies").child(titleVacancy).removeValue()
//            self.view.activityStartAnimating(activityColor: UIColor.red, backgroundColor: UIColor.black.withAlphaComponent(0.1))
            completion(.success)
        } else {
            
//            print("error")
            completion(.failure(AuthError.unknownError))
        }
    }
}
