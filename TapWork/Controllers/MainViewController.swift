//
//  MainViewController.swift
//  TapWork
//
//  Created by Sergey Vorobey on 04/06/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView
import BonsaiController

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var choiceButtonLbl: UIBarButtonItem!
    
    private var vacancies = [Vacancy]()
    //    private var filteredVacancies = [Vacancy]()
    private var userProfileID: String?
    //master array
    //    private var vacanciesToDisplay = [Vacancy]()
    
    private let spinner = NVActivityIndicatorView(frame: CGRect.init(x: 0,
                                                                     y: 0,
                                                                     width: 30,
                                                                     height: 30),
                                                  type: .circleStrokeSpin,
                                                  color: .red,
                                                  padding: .none)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        tableView.reloadData()
        getProfileUserID()
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showActivityIndicator()
        setupItems()
        
        getVacancies {[weak self] (result) in
            switch result {
            case .success:
                break
            case .failure(let error):
                self?.errorAlert(title: "Ошибка", message: error.localizedDescription)
                
            }
        }
    }
    
    //MARK: Setup appearance items
    private func setupItems() {
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.addSubview(refreshControll)
        tableView.tableFooterView = UIView()

        navigationItem.title = "TAP WORK"

        choiceButtonLbl.image = #imageLiteral(resourceName: "filter")
        //        createVacancyButtonLbl.changeStyleButton(with: "Создать вакансию")
        //        headerCountVacancyLbl.text = "У вас пока нет активных вакасний"
        //        descriptionMenuLbl.text = "Создайте вакансию и найдите исполнителя"
    }
    
    //  refresh spinner
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
    
    @IBAction func choiceButton(_ sender: UIBarButtonItem) {
        print("go filter controller")
    }
}

//MARK: Table view datasource, delegate
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vacancies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vacanciesCell = tableView.dequeueReusableCell(withIdentifier: "VacanciesCell", for: indexPath) as! VacanciesCell
        
        let vacancy = vacancies[indexPath.row]
        
        if vacancy.userId == userProfileID {
            //               vacanciesCell.isUserInteractionEnabled = false
            //                vacanciesCell.isUserInteractionEnabled = true
            vacanciesCell.stackView.isHidden = false
            vacanciesCell.userPublicationLbl.text = "Ваша публикация"
        } else {
            vacanciesCell.stackView.isHidden = true
        }
        vacanciesCell.headingLabel.text = vacancy.heading
        vacanciesCell.cityVacansyLabel.text = vacancy.city
        vacanciesCell.contentLabel.text = vacancy.content
        vacanciesCell.paymentLabel.text = vacancy.payment + " ₽ "
        vacanciesCell.countViewsLbl.text = "114" //TODO
        let datePublic = vacancy.timestamp
        let date = Date(timeIntervalSince1970: datePublic / 1000)
        vacanciesCell.publicationDateLabel.text = date.publicationDate(withDate: date)
        
        hideActivityIndicator()
        return vacanciesCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailVacansyVC" {
//                        segue.destination.transitioningDelegate = self
//                        segue.destination.modalPresentationStyle = .custom
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let vacancy = vacancies[indexPath.row]
            let detailVacancyVC = segue.destination as! DetailVacansyViewController
            detailVacancyVC.detailVacancy = vacancy
            if vacancy.userId == userProfileID {
                detailVacancyVC.checkVacancy = "EMPLOYER_KEY"
            }
        }
    }
}

//MARK: Services get data in DB
extension MainViewController {
    
    //MARK: get vacancies
    private func getVacancies(completion: @escaping (AuthResult) -> Void) {
        guard Validators.isConnectedToNetwork()  else {
            completion(.failure(AuthError.serverError))
            return
        }
        
        let dataLoader = LoaderDataFirebase()
        dataLoader.getDataVacancies()
        
        dataLoader.completionHandler{[weak self] (vacansy, status, message) in
            var array = [Vacancy]()
            if status {
                guard let self = self else {return}
                guard let _vacansy = vacansy else {return}
                self.vacancies = _vacansy as! [Vacancy]
                //                self.vacanciesToDisplay = _vacansy as! [Vacancy]
                
                for item in self.vacancies {
                    if item.userId == self.userProfileID {
                        array.append(item)
                    }
                    //                    self.filteredVacancies = array
                    //                    self.checkCountElementsWithTabBar()
                }
            }
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        completion(.success)
    }
    
    //MARK: parse user id
    private func getProfileUserID() {
        let dataLoader = LoaderDataFirebase()
        dataLoader.getProfileUserID()
        dataLoader.completionHandler {[weak self](userProfileID, status, message) in
            if status {
                
                guard let self = self else {return}
                guard let _userProfileID = userProfileID else {return}
                self.userProfileID = _userProfileID as? String
            }
        }
    }
}

//MARK: Present modally response vacansy controller
//extension MainViewController: BonsaiControllerDelegate {
//    // return the frame of your Bonsai View Controller
//    func frameOfPresentedView(in containerViewFrame: CGRect) -> CGRect {
//
//        return CGRect(origin: CGPoint(x: 0, y: containerViewFrame.height / 4),
//                      size: CGSize(width: containerViewFrame.width,
//                                   height: containerViewFrame.height / (4/3)))
//    }
//
//    // return a Bonsai Controller with SlideIn or Bubble transition animator
//    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
//
//        /// With Background Color ///
//
//        // Slide animation from .left, .right, .top, .bottom
//        return BonsaiController(fromDirection: .bottom, backgroundColor: UIColor(white: 0, alpha: 0.5), presentedViewController: presented, delegate: self)
//    }
//}

//MARK: ActivityIndicator
extension MainViewController {
    private func showActivityIndicator() {
        self.view.addSubview(spinner)
        spinner.startAnimating()
        spinner.center = view.center
        view.isUserInteractionEnabled = false
    }
    
    private func hideActivityIndicator(){
        spinner.stopAnimating()
        view.isUserInteractionEnabled = true
    }
}


