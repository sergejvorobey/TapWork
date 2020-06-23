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
    @IBOutlet weak var noticeStackView: UIStackView!
    @IBOutlet weak var headerCountVacancyLbl: UILabel!
    @IBOutlet weak var descriptionMenuLbl: UILabel!
    @IBOutlet weak var createVacancyButtonLbl: UIButton!

    
    private var allVacancies = [Vacancy]()
    private var filteredVacancies = [Vacancy]()
    private var userProfileID: String?
    //master array
    private var vacanciesToDisplay = [Vacancy]()
    
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
        
        roleSegmentedControl.selectedSegmentIndex = 0
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        if roleSegmentedControl.selectedSegmentIndex == 1 {
//            tableView.reloadData()
//        }
        
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
        
        //        roleSegmentedControl.selectedSegmentIndex = 0
        noticeStackView.isHidden = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.clear
        tableView.addSubview(refreshControll)
        tableView.tableFooterView = UIView()
        view.changeColorView()
        navigationItem.prompt = "TAP WORK"
        roleSegmentedControl.setTitle("Я - Ищу работу", forSegmentAt: 0)
        roleSegmentedControl.setTitle("Я - Предлагаю работу", forSegmentAt: 1)
        choiceButtonLbl.image = #imageLiteral(resourceName: "filter")
        createVacancyButtonLbl.changeStyleButton(with: "Создать вакансию")
        headerCountVacancyLbl.text = "У вас пока нет активных вакасний"
        descriptionMenuLbl.text = "Создайте вакансию и найдите исполнителя"

    }
    
    @IBAction func createdVacancyButton(_ sender: UIButton) {
        performSegue(withIdentifier: "AddingVacansy", sender: nil)
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
    
    
    //MARK: depending on the data hide/show notice stack view
    private func checkCountActiveVacancy() {
        if vacanciesToDisplay.isEmpty == true {
            noticeStackView.isHidden = false
        }
    }
    
    @IBAction func segmentRoleSelection(_ sender: UISegmentedControl) {
        switch roleSegmentedControl.selectedSegmentIndex {
        case 0:
            choiceButtonLbl.image = #imageLiteral(resourceName: "filter")
            vacanciesToDisplay = allVacancies
            noticeStackView.isHidden = true
        default:
            vacanciesToDisplay = filteredVacancies
            choiceButtonLbl.image = #imageLiteral(resourceName: "menu")
            checkCountActiveVacancy()
        }
        self.tableView.reloadData()
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
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
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))

        let label = UILabel()
        label.frame = CGRect.init(x: 20, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        if roleSegmentedControl.selectedSegmentIndex == 0 {
            label.text = "Вакансии"
        } else {
            label.text = "Ваши публикации"
        }
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 35, weight: .bold) // my custom font
        label.textColor = .black // my custom color

        headerView.addSubview(label)

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vacanciesToDisplay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vacanciesCell = tableView.dequeueReusableCell(withIdentifier: "VacanciesCell", for: indexPath) as! VacanciesCell
 
//        let colorYellow = UIColor(red: 255, green: 255, blue: 204/255, alpha: 1)
        let colorGray = UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1)
        
        let vacansy = vacanciesToDisplay[indexPath.row]

        if vacansy.userId == userProfileID {
//            if roleSegmentedControl.selectedSegmentIndex == 0 {
//               vacanciesCell.isUserInteractionEnabled = false
//            } else {
//                vacanciesCell.isUserInteractionEnabled = true
//            }
            vacanciesCell.stackView.isHidden = false
            vacanciesCell.userPublicationLbl.text = "Ваша публикация"
        } else {
            vacanciesCell.stackView.isHidden = true
        }
        vacanciesCell.cellCurrentUser(color: colorGray)
        vacanciesCell.headingLabel.text = vacansy.heading
        vacanciesCell.cityVacansyLabel.text = vacansy.city
        vacanciesCell.contentLabel.text = vacansy.content
        vacanciesCell.paymentLabel.text = vacansy.payment + " ₽ "
        vacanciesCell.countViewsLbl.text = "114"
        
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
//            segue.destination.transitioningDelegate = self
//            segue.destination.modalPresentationStyle = .custom
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let vacancy = vacanciesToDisplay[indexPath.row]
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
                self.allVacancies = _vacansy as! [Vacancy]
                self.vacanciesToDisplay = _vacansy as! [Vacancy]
                for item in self.allVacancies {
                    if item.userId == self.userProfileID {
                        array.append(item)
                    }
                    self.filteredVacancies = array
                }
            }
//            DispatchQueue.main.async {
                self?.tableView.reloadData()
//            }
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
        self.roleSegmentedControl.setEnabled(false, forSegmentAt: 1)
        spinner.center = view.center
        view.isUserInteractionEnabled = false
    }
    
   private func hideActivityIndicator(){
        spinner.stopAnimating()
        self.roleSegmentedControl.setEnabled(true, forSegmentAt: 1)
        view.isUserInteractionEnabled = true
    }
}

//MARK: create new vacancy
extension MainViewController: UIActionSheetDelegate {
    private func addingNewVacansy() {
        
        let createIcon = UIImage(systemName: "square.and.pencil")
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        actionSheet.view.tintColor = .black

        let cancel = UIAlertAction(title: "Назад", style: .cancel)

        let createNewVacancy = UIAlertAction(title: "Создать новую вакансию", style: .default) { (actionSheet) in
            self.performSegue(withIdentifier: "AddingVacansy", sender: nil)
        }
        
        createNewVacancy.setValue(createIcon, forKey: "image")
        createNewVacancy.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        
        actionSheet.addAction(createNewVacancy)
        actionSheet.addAction(cancel)
        present(actionSheet, animated: true)
    }
}

