//
//  FilterController.swift
//  TapWork
//
//  Created by Sergey Vorobey on 16/02/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit

class CategoriesController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var categories:[Category] = []
    private let categoryProvider: CategoriesProvider = CategoriesProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
    
        categories = categoryProvider.categories
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
        
        navigationItem.title = "Категории"
        guard let navigation = navigationController else {return}
        navigation.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.red,
            NSAttributedString.Key.font: UIFont(name: "Apple SD Gothic Neo", size: 20.0)!
        ]
    }
}

extension CategoriesController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let categoryCell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        
        let category = categories[indexPath.row]
        
        categoryCell.categoryLabel.text = category.nameCategories.rawValue
        
        categoryCell.accessoryType = .disclosureIndicator
        
        return categoryCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let specializationController = storyboard?.instantiateViewController(withIdentifier: "SpecializationController")
               
        guard let specializationVC = specializationController else { return }

        self.navigationController?.pushViewController(specializationVC, animated: true)
           
        self.tableView.deselectRow(at: indexPath, animated: true)
    
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

