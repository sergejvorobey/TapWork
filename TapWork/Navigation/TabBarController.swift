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
        tabBar.items![0].title = "" //Лента
        tabBar.items![0].tag = 0
        tabBar.items![1].title = ""//"Предложить работу"
        tabBar.items![1].tag = 1
        tabBar.items![2].title = ""//"Сообщения"
        tabBar.items![2].tag = 2
        tabBar.items![3].title = ""//"Избранное"
        tabBar.items![3].tag = 3
        tabBar.items![4].title = ""//"Личный кабинет"
        tabBar.items![4].tag = 4
        navigationController?.navigationBar.isHidden = true
//        self.tabBarController?.delegate = self
        
//        tabBar.isTranslucent = true
//        tabBar.frame.size.height = .greatestFiniteMagnitude
        
        tabBar.items![3].isEnabled = false
        
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case 0:
            print("lenta")
        case 1:
            print("Предложить работу")
        case 2:
            print("Сообщения")
        case 3:
            print("Избранное")
        case 4:
            print("Личный кабинет")
        default:
            break
        }
    }
}
