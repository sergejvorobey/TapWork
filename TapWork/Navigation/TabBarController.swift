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
        tabBar.items![1].title = "Фильтр"
        tabBar.items![2].title = "Добавить вакансию"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
