//
//  MainScreenTableViewController.swift
//  TapWork
//
//  Created by Sergey Vorobey on 08/02/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit

class MainScreenController: UITableViewController {
    
    @IBOutlet weak var imageAccount: UIBarButtonItem!
    
    private var vacancies:[Vacancy] = []
    private let vacansyProvider: VacansyProvider = VacansyProvider()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        vacancies = vacansyProvider.vacancies
        
        tableView.tableFooterView = UIView()
//        self.view.backgroundColor = UIColor.lightGray
        
    }

    
    // MARK: - Table view data source
    
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return vacancies.count
    //    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return vacancies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vacanciesCell = tableView.dequeueReusableCell(withIdentifier: "VacanciesCell", for: indexPath) as! VacansyTableViewCell
        
        let vacansy = vacancies[indexPath.row]
        
//                vacanciesCell.layer.cornerRadius = 20
//                vacanciesCell.layer.masksToBounds = true
//                vacanciesCell.layer.borderWidth = 6
//                vacanciesCell.layer.borderColor = UIColor.lightGray.cgColor
        
        vacanciesCell.headingLabel.text = vacansy.heading
        vacanciesCell.contentLabel.text = vacansy.content
        vacanciesCell.paymentLabel.text = vacansy.payment + " ₽ "
        vacanciesCell.publicationDateLabel.text = vacansy.publicationDate
        
        return vacanciesCell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let ShowInfoVacansyViewController = storyboard?.instantiateViewController(withIdentifier: "ShowInfoVacansyViewController") as! ShowInfoVacansyViewController
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            ShowInfoVacansyViewController.vacansyInfo = vacancies[selectedIndexPath.row]
        }
        
        self.navigationController?.pushViewController(ShowInfoVacansyViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    
    @IBAction func userAccount(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "ShowAccount", sender: nil)
    }
    
}


//extension MainScreenTableViewController: UITabBarController {
//    
//}
