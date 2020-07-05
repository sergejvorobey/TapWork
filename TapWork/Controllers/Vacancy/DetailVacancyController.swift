//
//  DetailVacancyController.swift
//  TapWork
//
//  Created by Sergey Vorobey on 30.06.2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit

class DetailVacancyController: UIViewController {
    
    @IBOutlet weak var headingVacancyLbl: UILabel!
    @IBOutlet weak var categotyVacancyLbl: UILabel!
    @IBOutlet weak var cityVacancyLbl: UILabel!
    @IBOutlet weak var contentVacancyLbl: UILabel!
    @IBOutlet weak var paymentVacancyLbl: UILabel!
    @IBOutlet weak var publicationDateVacancyLbl: UILabel!
    @IBOutlet weak var countViewVacancyLbl: UILabel!
    @IBOutlet weak var responseButtonLabel: UIButton!
    
    @IBOutlet weak var favoriteVacancyBtn: UIBarButtonItem!
    @IBOutlet weak var shareVacancyBtn: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupItems()
    }
    
    private func setupItems() {
        guard
//            let detailVacancy = detailVacancy,
        let heading = headingVacancyLbl,
        let category = categotyVacancyLbl,
        let city = cityVacancyLbl,
        let content = contentVacancyLbl,
        let payment = paymentVacancyLbl,
        let publicationDate = publicationDateVacancyLbl,
        let response = responseButtonLabel,
        let countViews = countViewVacancyLbl
//        let countViewsVacancy = countViewsVacancy
            else {return}
        
        heading.text = "Бармен на лайнер"//detailVacancy.heading
        city.text = "Москва"//detailVacancy.city
        category.text = "Бармен"
        content.text = "ОООООООООООООООООООООООООООООООООООООО"//detailVacancy.content
        payment.text = "1000 ₽"//detailVacancy.payment + " ₽ "
//        let datePublic = "24 августа, 12:00"//detailVacancy.timestamp
//        let date = Date(timeIntervalSince1970: datePublic / 1000)
        publicationDate.text = "24 августа, 12:00"//date.publicationDate(withDate: date)
        //        navigationBar.topItem?.title = "Вакансия от: \(date.publicationDate(withDate: date))"
        
        countViews.text = "12"//"\(countViewsVacancy)"
        
        response.changeStyleButton(with: "Откликнуться")
    }
}

