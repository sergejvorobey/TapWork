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
        tabBar.items![0].title = "Лента"
        tabBar.items![1].title = "Предложить работу"
        tabBar.items![2].title = "Сообщения"
        tabBar.items![3].title = "Избранное"
        tabBar.items![4].title = "Личный кабинет"
        navigationController?.navigationBar.isHidden = true
       
        
//        tabBar.isTranslucent = true
//        tabBar.frame.size.height = .greatestFiniteMagnitude
        
    }
}
