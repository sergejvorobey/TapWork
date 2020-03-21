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
        
        //        navigationController?.navigationBar.isHidden = false
        
        navigationItem.title = "TAP WORK"
        
        spinner()
        
        refDatebase()
        
        tableView.tableFooterView = UIView()
    }
    
    // activity indicator
    private func spinner() {
        
        let spinner = UIActivityIndicatorView()
        spinner.startAnimating()
        spinner.color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        //        spinner.stopAnimating()
        spinner.hidesWhenStopped = true
        tableView.backgroundView = spinner
    }
    
    private func spinnerStop() {
        
        let spinner = UIActivityIndicatorView()
        spinner.stopAnimating()
        spinner.hidesWhenStopped = true
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
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowVacansyVC" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let vacansy = vacancies[indexPath.row]
            let newHumanVC = segue.destination as! ShowInfoVacansyViewController
            newHumanVC.vacansyInfo = vacansy
        }
    }
    
    @IBAction func userAccount(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "ShowUserAccount", sender: nil)
    }
}
