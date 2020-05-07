//
//  ShowInfoVacansyViewController.swift
//  TapWork
//
//  Created by Sergey Vorobey on 09/02/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit

class ShowInfoVacansyViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var vacansyInfo: Vacancy?

    override func viewDidLoad() {
        super.viewDidLoad()
      
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
 
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "Вакансии",
                                                        style: .plain,
                                                        target: nil, action: nil)
        }
    }
}

extension ShowInfoVacansyViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vacancyCell = tableView.dequeueReusableCell(withIdentifier: "ShowVacansyInfo", for: indexPath) as! ShowInfoVacansyCell

        if let vacansyInfo = vacansyInfo {
            vacancyCell.headingVacansyLabel.text = vacansyInfo.heading
            vacancyCell.categotyVacansyLabel.styleLabel(with: "  Категория не выбрана  ") // TODO: dodelati
            vacancyCell.contentVacansyLabel.text = vacansyInfo.content
            vacancyCell.paymentVacansyLabel.text = vacansyInfo.payment + " ₽ "
        }
        
//        let datePublic = vacansy.timestamp
//        let date = Date(timeIntervalSince1970: datePublic / 1000)
//
//        //        vacanciesCell.publicationDateLabel.text = date.calenderTimeSinceNow()
//        vacanciesCell.publicationDateLabel.text = date.publicationDate(withDate: date)
//
        return vacancyCell

    }
}

