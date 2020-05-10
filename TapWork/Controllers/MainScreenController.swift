//
//  MainScreenTableViewController.swift
//  TapWork
//
//  Created by Sergey Vorobey on 08/02/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView

class MainScreenController: UITableViewController {
    

    private var vacancies = Array<Vacancy>()
    private let spinner = UIActivityIndicatorView()
    var nvActivityIndicator: NVActivityIndicatorView?
//    let spinner2 = NVActivityIndicatorView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "TAP WORK"
        
        tableView.tableFooterView = UIView()
        tableView.addSubview(refreshControll)
        
        view.changeColorView()
        
    }
    
    // refresh spinner
    private lazy var refreshControll: UIRefreshControl = {
        let refreshControll = UIRefreshControl()
        refreshControll.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControll.tintColor = UIColor.red
        return refreshControll
        
    }()
    
    @objc func handleRefresh(_ refreshControll: UIRefreshControl) {
        self.tableView.reloadData()
        let deadline = DispatchTime.now() + .milliseconds(700)
        DispatchQueue.main.asyncAfter(deadline: deadline, execute: {
            refreshControll.endRefreshing()
        })
    }
    
    //reference database
    private func refDatebase()  {
        //        ref = Database.database().reference(withPath: "vacancies")
        let ref = Database.database().reference(withPath: "vacancies")
        
        ref.observe(.value) { [weak self] (snapshot) in
            //        ref.observe(.value) { [weak self] (snapshot) in
            
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        spinnerStart()
        refDatebase()
      
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return vacancies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let vacanciesCell = tableView.dequeueReusableCell(withIdentifier: "VacanciesCell", for: indexPath) as! VacansyTableViewCell
        
        let vacansy = vacancies[indexPath.row]
        
        vacanciesCell.headingLabel.text = vacansy.heading
        vacanciesCell.cityVacansyLabel.text = "Город" //TODO: peredelati
        vacanciesCell.categoryVacansyLabel.styleLabel(with: " Категория ") //TODO
        vacanciesCell.contentLabel.text = vacansy.content
        vacanciesCell.paymentLabel.text = vacansy.payment + " ₽ "
        
        vacanciesCell.changeCellColor()
        
        let datePublic = vacansy.timestamp
        let date = Date(timeIntervalSince1970: datePublic / 1000)
        
        //        vacanciesCell.publicationDateLabel.text = date.calenderTimeSinceNow()
        vacanciesCell.publicationDateLabel.text = date.publicationDate(withDate: date)
        
        spinnerStop()
        
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
            let showInfoVacansyVC = segue.destination as! ShowInfoVacansyViewController
            showInfoVacansyVC.vacansyInfo = vacansy
        }
    }
    
    @IBAction func filterButton(_ sender: UIBarButtonItem) {
        
        let actionSheet = UIAlertController(title: "Сортировка вакансий:", message: nil, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "Назад", style: .destructive)
        let sortingByCategory = UIAlertAction(title: "По категории", style: .default) { [weak self] _ in
            self?.performSegue(withIdentifier: "CategoriesController", sender: nil)
        }
        
        let sortingPrice = UIAlertAction(title: "По бюджету", style: .default) { _ in }
        
        actionSheet.addAction(sortingByCategory)
        actionSheet.addAction(sortingPrice)
        actionSheet.addAction(cancel)
        present(actionSheet, animated: true)
    }
}

extension MainScreenController {
    
    // activity indicator
    private func spinnerStart() {
        
        //        self.view.activityStartAnimating(activityColor: UIColor.red, backgroundColor: UIColor.black.withAlphaComponent(0.1))
        spinner.startAnimating()
        spinner.color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        //                  spinner.hidesWhenStopped = true
        tableView.backgroundView = spinner
        //        tableView.backgroundView = nvActivityIndicator
    }
    
    private func spinnerStop() {
        spinner.stopAnimating()
        spinner.hidesWhenStopped = true
        //        self.view.activityStopAnimating()
    }
    
}
