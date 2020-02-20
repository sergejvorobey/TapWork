//
//  FilterController.swift
//  TapWork
//
//  Created by Sergey Vorobey on 16/02/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit

class CategoriesController: UIViewController {

    @IBOutlet weak var applyFilterLabel: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    private var categories:[Category] = []
    private var specializations: [Specialization] = []
    private let categoryProvider: CategoriesProvider = CategoriesProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        
        categories = categoryProvider.categories
        specializations = categoryProvider.specializations
        
        
        if let button = applyFilterLabel {
            
            button.layer.cornerRadius = 10
            button.layer.backgroundColor = UIColor.red.cgColor
            button.setTitle("Применить фильтр", for: .normal)
            button.setTitleColor(.white, for: .normal)
        }
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
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
   
}

