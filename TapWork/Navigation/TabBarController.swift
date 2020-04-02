//
//  TabBarController.swift
//  TapWork
//
//  Created by Sergey Vorobey on 16/02/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.tintColor = .red
        tabBar.unselectedItemTintColor = .black
        tabBar.barTintColor = .white
        tabBar.items![0].title = "Вакансии"
        tabBar.items![1].title = "Опубликовать вакансию"
        tabBar.items![2].title = "Сообщения"
//        tabBar.items![2].isEnabled = false //доработать 

        navigationController?.navigationBar.isHidden = true
    }
}
