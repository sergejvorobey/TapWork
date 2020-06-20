//
//  FavoritesVacanciesController.swift
//  TapWork
//
//  Created by Sergey Vorobey on 20/06/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit

class FavoritesVacanciesController: UIViewController {

    @IBOutlet weak var noticeStackView: UIStackView!
    @IBOutlet weak var headerNoticeLbl: UILabel!
    @IBOutlet weak var descriptionNoticeLbl: UILabel!
    @IBOutlet weak var laterButtonLbl: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       setupItems()
    }
    
    private func setupItems() {
        navigationItem.title = "Избранное"
        headerNoticeLbl.text = "Добавьте вакансии в избранное"
        descriptionNoticeLbl.text = "Вы можете вернуться к ним позже, что бы откликнуться"
        laterButtonLbl.changeStyleButton(with: "Искать вакансии")
    }
    
    @IBAction func laterButton(_ sender: UIButton) {
        tabBarController?.selectedIndex = 0
    }
}
