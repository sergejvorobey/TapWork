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
import BonsaiController

class MainScreenController: UITableViewController {
    
    private var vacancies = [Vacancy]()
    private let spinner = UIActivityIndicatorView()
    private var nvActivityIndicator: NVActivityIndicatorView?
    var userStatus: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       setupItems()
        
        
//        tableView.backgroundColor = UIColor.clear
//        view.backgroundColor = UIColor.clear
        
        
        
    }
    
    private func setupItems() {
        
        navigationItem.title = "TAP WORK"
        tableView.tableFooterView = UIView()
        tableView.addSubview(refreshControll)
        
//        let color = UIColor.white
//        let gradient = CAGradientLayer()
//        gradient.colors = [UIColor.gray.cgColor, color.cgColor]
//        gradient.frame = view.bounds
//        view.layer.insertSublayer(gradient, at: 0)
        //        navigationItem.title = "Личная информация"
//                navigationItem.rightBarButtonItem?.tintColor = .black
//        navigationController?.navigationBar.barTintColor = color
//        self.view.backgroundColor = color
//        view.backgroundColor = .darkGray
        let color = UIColor.white
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.darkGray.cgColor, color.cgColor]
        gradient.frame = self.view.bounds
        self.view.layer.insertSublayer(gradient, at: 0)
        self.view.backgroundColor = color
        navigationController?.navigationBar.barTintColor = color
//        view.changeColorView()
//        self.tableView.addShadow()
    }
    
    //MARK: parse user status
    private func getStatusUser() {
        
        let dataLoader = LoaderDataFirebase()
        dataLoader.getUserStatus()
        dataLoader.completionHandler {[weak self](userStatus, status, message) in
            if status {

                guard let self = self else {return}
                guard let _userStatus = userStatus else {return}
                self.userStatus = _userStatus as? String
            }
        }
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
    
    //ref database vacancies
    private func getVacancies(completion: @escaping (AuthResult) -> Void) {
        guard Validators.isConnectedToNetwork()  else {
            completion(.failure(AuthError.serverError))
            return
        }
        
        let dataLoader = LoaderDataFirebase()
        dataLoader.getDataVacancies()
        
        dataLoader.completionHandler{[weak self] (vacansy, status, message) in
            
            if status {
                guard let self = self else {return}
                guard let _vacansy = vacansy else {return}
                self.vacancies = _vacansy as! [Vacancy]
            }
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        completion(.success)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

//        spinnerStart()
        getStatusUser()
        getVacancies { (result) in
            switch result {
            case .success:
                break
            case .failure(let error):
                self.showAlert(title: "Ошибка", message: error.localizedDescription)

            }
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return vacancies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let vacanciesCell = tableView.dequeueReusableCell(withIdentifier: "VacansyTableViewCell", for: indexPath) as! VacansyTableViewCell
        
        vacanciesCell.backgroundColor = UIColor.clear
        
        if userStatus == "Работодатель" {
            vacanciesCell.isUserInteractionEnabled = false
        } else {
            vacanciesCell.isUserInteractionEnabled = true
        }
        
        let vacansy = vacancies[indexPath.row]

        vacanciesCell.headingLabel.text = vacansy.heading
        vacanciesCell.cityVacansyLabel.text = vacansy.city
        vacanciesCell.categoryVacansyLabel.styleLabel(with: " Категория ") //TODO
        vacanciesCell.contentLabel.text = vacansy.content
        vacanciesCell.paymentLabel.text = vacansy.payment + " ₽ "
        
//        vacanciesCell.changeCellColor()
        
        let datePublic = vacansy.timestamp
        
        let date = Date(timeIntervalSince1970: datePublic / 1000)

//                vacanciesCell.publicationDateLabel.text = date.calenderTimeSinceNow()
        vacanciesCell.publicationDateLabel.text = date.publicationDate(withDate: date)
        
//        spinnerStop()
        
        return vacanciesCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailVacansyVC" {
            segue.destination.transitioningDelegate = self
            segue.destination.modalPresentationStyle = .custom
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let vacansy = vacancies[indexPath.row]
            let showInfoVacansyVC = segue.destination as! DetailVacansyViewController
            showInfoVacansyVC.detailVacansy = vacansy
        }
    }
    
    @IBAction func filterButton(_ sender: UIBarButtonItem) {
        
        let actionSheet = UIAlertController(title: "Сортировка вакансий:", message: nil, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "Назад", style: .destructive)
        let sortingByCategory = UIAlertAction(title: "По категории", style: .default) {  _ in
//            self?.performSegue(withIdentifier: "CategoriesController", sender: nil)
        }
        
        let sortingPrice = UIAlertAction(title: "По бюджету", style: .default) { _ in }
        
        actionSheet.addAction(sortingByCategory)
        actionSheet.addAction(sortingPrice)
        actionSheet.addAction(cancel)
        present(actionSheet, animated: true)
    }
}

//MARK: Present modally response vacansy controller
extension MainScreenController: BonsaiControllerDelegate {
    // return the frame of your Bonsai View Controller
    func frameOfPresentedView(in containerViewFrame: CGRect) -> CGRect {
        
        return CGRect(origin: CGPoint(x: 0, y: containerViewFrame.height - 250 /*containerViewFrame.height / 2*/), 
                      size: CGSize(width: containerViewFrame.width,
                                   height: containerViewFrame.height / 2))
    }
    
    // return a Bonsai Controller with SlideIn or Bubble transition animator
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
    
        /// With Background Color ///
    
        // Slide animation from .left, .right, .top, .bottom
        return BonsaiController(fromDirection: .bottom, backgroundColor: UIColor(white: 0, alpha: 0.5), presentedViewController: presented, delegate: self)
        
        // or Bubble animation initiated from a view
        //return BonsaiController(fromView: yourOriginView, backgroundColor: UIColor(white: 0, alpha: 0.5), presentedViewController: presented, delegate: self)
    
    
        /// With Blur Style ///
        
        // Slide animation from .left, .right, .top, .bottom
        //return BonsaiController(fromDirection: .bottom, blurEffectStyle: .light, presentedViewController: presented, delegate: self)
        
        // or Bubble animation initiated from a view
        //return BonsaiController(fromView: yourOriginView, blurEffectStyle: .dark,  presentedViewController: presented, delegate: self)
    }
}

extension MainScreenController {
    
    // activity indicator
    private func spinnerStart() {

        spinner.startAnimating()
        spinner.color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        tableView.backgroundView = spinner

    }
    
    private func spinnerStop() {
        spinner.stopAnimating()
        spinner.hidesWhenStopped = true
//        self.view.activityStopAnimating()
    }
}



