//
//  FilterController.swift
//  TapWork
//
//  Created by Sergey Vorobey on 06.07.2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit

class FilterController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButtonView: UIView!
    @IBOutlet weak var applyButtonLbl: UIButton!
    @IBOutlet weak var resetButtonLbl: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupItems()
    }
    
    private func setupItems() {
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.title = "Фильтр вакансий"
        backButtonView.addShadow()
        applyButtonLbl.changeStyleButton(with: "Применить")
        resetButtonLbl.title = "Сбросить"
        tableView.tableFooterView = UIView()
        guard let topItem = navigationController?.navigationBar.topItem else {return}
        topItem.backBarButtonItem = UIBarButtonItem(title: "",
                                                    style: .plain,
                                                    target: nil, action: nil)
    }
}

//MARK: table view datasource, table view delegate
extension FilterController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let filterItemCell = tableView.dequeueReusableCell(withIdentifier: "FilterItemCell", for: indexPath) as! FilterItemCell
        filterItemCell.accessoryType = .disclosureIndicator
        let indexRow = indexPath.row
        
        switch indexRow {
        case 0:
            filterItemCell.headerForItemLbl.text = "Местоположение"
            filterItemCell.descriptionForItemLbl.text = "Все города"
            
        case 1:
            filterItemCell.headerForItemLbl.text = "Специализация"
            filterItemCell.descriptionForItemLbl.text = "По всем специализациям"
        default:
            filterItemCell.headerForItemLbl.text = "Бюджет"
            filterItemCell.descriptionForItemLbl.text = "Любой бюджет"
        }
        return filterItemCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
