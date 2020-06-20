//
//  DetailViewController.swift
//  TapWork
//
//  Created by Sergey Vorobey on 12/05/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit

class DetailVacansyViewController: UIViewController {
    
    @IBOutlet weak var headingVacansyLabel: UILabel!
//    @IBOutlet weak var categotyVacansyLabel: UILabel!
//    @IBOutlet weak var cityVacansyLabel: UILabel!
//    @IBOutlet weak var contentVacansyLabel: UILabel!
    @IBOutlet weak var paymentVacansyLabel: UILabel!
    @IBOutlet weak var responseButtonLabel: UIButton!
    
    @IBOutlet weak var complainButtonLabel: UIButton!
    @IBOutlet weak var navigationBar: UINavigationBar!

    var detailVacansy: Vacancy?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeStyle()
        
    }
    
    private func changeStyle() {

        guard let detailVacansy = detailVacansy,
            let heading = headingVacansyLabel,
//            let category = categotyVacansyLabel,
//            let city = cityVacansyLabel,
//            let content = contentVacansyLabel,
            let payment = paymentVacansyLabel,
            let response = responseButtonLabel,
            let complain = complainButtonLabel else {return}
        
        heading.text = detailVacansy.heading
//        category.styleLabel(with: " Категория ") // TODO: dodelati
//        city.text = "Город" //TODO
//        content.text = detailVacansy.content
        payment.text = detailVacansy.payment + " ₽ "
        response.changeStyleButton(with: "Откликнуться")
        complain.setTitle("Пожаловаться на вакансию", for: .normal)
        
        let datePublic = detailVacansy.timestamp
        let date = Date(timeIntervalSince1970: datePublic / 1000)
        navigationBar.topItem?.title = "Москва, \(date.publicationDate(withDate: date))"
    }
    
    @IBAction func favoriteVacansy(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func responseButton(_ sender: UIButton) {
        
        response()
        
     }
    
    @IBAction func complainButton(_ sender: UIButton) {
        
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
