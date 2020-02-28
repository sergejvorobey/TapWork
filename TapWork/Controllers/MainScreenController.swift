//
//  MainScreenTableViewController.swift
//  TapWork
//
//  Created by Sergey Vorobey on 08/02/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit
import Firebase

class MainScreenController: UITableViewController {
    
    @IBOutlet weak var imageAccount: UIBarButtonItem!
    
    private var user: Users!
    private var ref: DatabaseReference!
    private var queryRef:DatabaseQuery!
    private var vacancies = Array<Vacancy>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refDatebase()
        
        tableView.tableFooterView = UIView()
        UserDefaults.standard.set(false, forKey: "registering")
        
    }
    
    private func refDatebase() {
        ref = Database.database().reference(withPath: "vacancies")
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
        
           ref.observe(.value) { [weak self] (snapshot) in
            
               var _vacancies = Array<Vacancy>()
            
               for item in snapshot.children {
                   let vacansy = Vacancy(snapshot: item as! DataSnapshot)
                   _vacancies.append(vacansy)
               }
               self?.vacancies = _vacancies
               self?.vacancies.sort(by: {$0.timestamp > $1.timestamp})
               self?.tableView.reloadData()
           }
       }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return vacancies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vacanciesCell = tableView.dequeueReusableCell(withIdentifier: "VacanciesCell", for: indexPath) as! VacansyTableViewCell
        
        let vacansy = vacancies[indexPath.row]

        vacanciesCell.headingLabel.text = vacansy.heading
        vacanciesCell.contentLabel.text = vacansy.content
        vacanciesCell.paymentLabel.text = vacansy.payment + " ₽ "
        
        let datePublic = vacansy.timestamp
        let date = Date(timeIntervalSince1970: datePublic / 1000)
                
        vacanciesCell.publicationDateLabel.text = date.calenderTimeSinceNow()
            
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
        
        performSegue(withIdentifier: "LoginAccount", sender: nil)
        
    }
}
