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
    
//    private let categories = DataLoader().categoryData
    private var categories = [CategoriesList]()
    var markerForSelectProfession = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        
        navigationItem.title = "Категория"
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "",
                                                        style: .plain,
                                                        target: nil, action: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
         getCategories()
    }
}

extension CategoriesController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories.count
//        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let categoryCell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        
        let category = categories[indexPath.row]

        categoryCell.categoryLabel.text = category.category
        
        categoryCell.accessoryType = .disclosureIndicator
        
        return categoryCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SpecializationController" {
            
            guard let indexPath = tableView.indexPathForSelectedRow else { return }

            let category = categories[indexPath.row]
            let categoryInfoVC = segue.destination as! SpecializationController
            categoryInfoVC.markerForSelectProfession = markerForSelectProfession

            for specializations in [category] {
                categoryInfoVC.specializations = specializations.specialization!
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

//MARK: get categories
extension CategoriesController {
    
    private func getCategories() {
        
        let dataLoader = CategoriesLoaderAPI()
        dataLoader.getCategoriesList()
        dataLoader.completionHandler {[weak self](categories, status, message) in
            if status {
                
                guard let self = self else {return}
                guard let _categories = categories else {return}
                self.categories = _categories
                
            }
            self?.tableView.reloadData()
        }
    }
}
