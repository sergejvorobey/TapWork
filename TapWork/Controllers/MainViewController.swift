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
    @IBOutlet weak var roleSegmentedControl: UISegmentedControl!
    @IBOutlet weak var choiceButtonLbl: UIBarButtonItem!
    @IBOutlet weak var addedVacansyContainerView: UIView!
    
    private var vacancies = [Vacancy]()
    private var userProfileID: String?
    
    private let spinner = NVActivityIndicatorView(frame: CGRect.init(x: 0,
                                                                     y: 0,
                                                                     width: 30,
                                                                     height: 30),
                                                  type: .circleStrokeSpin,
                                                  color: .red,
                                                  padding: .none)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupItems()
    }
    
    //MARK: Setup appearance items
    private func setupItems() {

        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.clear
        tableView.addSubview(refreshControll)
        tableView.tableFooterView = UIView()
        view.changeColorView()
//        navigationItem.title = "TAP WORK"
        navigationItem.prompt = "TAP WORK"
        roleSegmentedControl.setTitle("Я - Ищу работу", forSegmentAt: 0)
        roleSegmentedControl.setTitle("Я - Работодатель", forSegmentAt: 1)
        choiceButtonLbl.image = #imageLiteral(resourceName: "filter")
        addedVacansyContainerView.isHidden = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getVacancies {[weak self] (result) in
            switch result {
            case .success:
                self?.showActivityIndicator()
                self?.getProfileUserID()
            case .failure(let error):
                self?.errorAlert(title: "Ошибка", message: error.localizedDescription)
                
            }
        }
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
    
    @IBAction func segmentRoleSelection(_ sender: UISegmentedControl) {
        
        switch roleSegmentedControl.selectedSegmentIndex {
        case 0:
            tableView.isHidden = false
            addedVacansyContainerView.isHidden = true
            choiceButtonLbl.image = #imageLiteral(resourceName: "filter")
        case 1:
            tableView.isHidden = true
            choiceButtonLbl.image = #imageLiteral(resourceName: "menu")
            addedVacansyContainerView.isHidden = false
        default:
            break
        }
    }
    
    @IBAction func choiceButton(_ sender: UIBarButtonItem) {
        switch roleSegmentedControl.selectedSegmentIndex {
        case 0:
            print("go filter")//TODO
        case 1:
            addingNewVacansy()
        default:
            break
        }
    }
}

//MARK: Table view datasource, delegate
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let verticalPadding: CGFloat = 20

//
//        let maskLayer = CALayer()
//        maskLayer.cornerRadius = 10
//        maskLayer.backgroundColor = UIColor.black.cgColor
//        maskLayer.frame = CGRect(x: cell.bounds.origin.x,
//                                 y: cell.bounds.origin.y,
//                                 width: cell.bounds.width,
//                                 height: cell.bounds.height)
//            .insetBy(dx: 0, dy: verticalPadding / 2)
//        cell.layer.mask = maskLayer

//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vacancies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vacanciesCell = tableView.dequeueReusableCell(withIdentifier: "VacanciesCell", for: indexPath) as! VacanciesCell
 
        let colorYellow = UIColor(red: 255, green: 255, blue: 204/255, alpha: 1)
        let colorGray = UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1)
        
        let vacansy = vacancies[indexPath.row]

        if vacansy.userId == userProfileID {
            vacanciesCell.cellCurrentUser(color: colorYellow)
            vacanciesCell.isUserInteractionEnabled = false
        } else {
            vacanciesCell.cellCurrentUser(color: colorGray)
            vacanciesCell.isUserInteractionEnabled = true
        }
        vacanciesCell.headingLabel.text = vacansy.heading
        vacanciesCell.cityVacansyLabel.text = vacansy.city
        vacanciesCell.contentLabel.text = vacansy.content
        vacanciesCell.paymentLabel.text = vacansy.payment + " ₽ "
        
        let datePublic = vacansy.timestamp
        
        let date = Date(timeIntervalSince1970: datePublic / 1000)
        
        //                vacanciesCell.publicationDateLabel.text = date.calenderTimeSinceNow()
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
            segue.destination.transitioningDelegate = self
            segue.destination.modalPresentationStyle = .custom
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let vacansy = vacancies[indexPath.row]
            let showInfoVacansyVC = segue.destination as! DetailVacansyViewController
            showInfoVacansyVC.detailVacansy = vacansy
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
extension MainViewController: BonsaiControllerDelegate {
    // return the frame of your Bonsai View Controller
    func frameOfPresentedView(in containerViewFrame: CGRect) -> CGRect {
        
        return CGRect(origin: CGPoint(x: 0, y: containerViewFrame.height / 2),
                      size: CGSize(width: containerViewFrame.width,
                                   height: containerViewFrame.height / 2))
    }
    
    // return a Bonsai Controller with SlideIn or Bubble transition animator
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        /// With Background Color ///
        
        // Slide animation from .left, .right, .top, .bottom
        return BonsaiController(fromDirection: .bottom, backgroundColor: UIColor(white: 0, alpha: 0.5), presentedViewController: presented, delegate: self)
    }
}

extension MainViewController {
    func showActivityIndicator() {
        self.view.addSubview(spinner)
        spinner.startAnimating()
        self.roleSegmentedControl.setEnabled(false, forSegmentAt: 1)
        spinner.center = view.center
        view.isUserInteractionEnabled = false
    }
    
    func hideActivityIndicator(){
        spinner.stopAnimating()
        self.roleSegmentedControl.setEnabled(true, forSegmentAt: 1)
        view.isUserInteractionEnabled = true
    }
}

//MARK: exit user account
extension MainViewController {
    private func addingNewVacansy() {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "Назад", style: .default)
        
        let signOutAcc = UIAlertAction(title: "Создать новую вакансию", style: .default) { (actionSheet) in
            
            self.performSegue(withIdentifier: "AddingVacansy", sender: nil)

        }
        actionSheet.addAction(signOutAcc)
        actionSheet.addAction(cancel)
        present(actionSheet, animated: true)
    }
}
