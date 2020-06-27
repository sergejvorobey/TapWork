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
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var detailVacancyMenuButton: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var backView: UIView!

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
            let response = responseButtonLabel else {return}
        
         
        heading.text = detailVacancy.heading
        city.text = detailVacancy.city
        category.text = "not input"
        content.text = detailVacancy.content
        payment.text = detailVacancy.payment + " ₽ "
        let datePublic = detailVacancy.timestamp
        let date = Date(timeIntervalSince1970: datePublic / 1000)
        publicationDate.text = date.publicationDate(withDate: date)
        navigationBar.topItem?.title = "Вакансия от: \(date.publicationDate(withDate: date))"
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
            cell.imageMenu.image = UIImage(systemName: "star")
            cell.desriptionMenuLbl.text = "В избранное"
        default:
            cell.imageMenu.image = UIImage(systemName: "arrowshape.turn.up.right")
            cell.desriptionMenuLbl.text = "Поделиться"
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let index = indexPath.row
        switch index {
        case 0:
            print("favorite")
        default:
            print("share")
        }
    }
}
