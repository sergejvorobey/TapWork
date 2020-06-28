//
//  EmployerVacancyController.swift
//  TapWork
//
//  Created by Sergey Vorobey on 26/06/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Firebase

class EmployerVacancyController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
//    private let noticeView = CustomNoticeView()
    private var filteredVacancies = [Vacancy]()
    private var userProfileID: String?
    private var headingVacancy: String?
    private let spinner = NVActivityIndicatorView(frame: CGRect.init(x: 0, y: 0,
                                                                     width: 30,
                                                                     height: 30),
                                                  type: .circleStrokeSpin,
                                                  color: .red,
                                                  padding: .none)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        hideActivityIndicator() //todo
        tableView.separatorStyle = .none
        getProfileUserID()
    }
    
    private func checkNoticeView() {
        self.hideActivityIndicator(spinner: spinner)
        switch filteredVacancies.isEmpty {
        case true:
            tableView.isHidden = true
            setupNoticeView(mainView: self.view,
                                       headerText: "У вас пока нет активных вакансий",
                                       descriptionText: "Создайте вакансию и найдите исполнителя")
        default:
            tableView.isHidden = false
            guard let viewWithTag = self.view.viewWithTag(100) else {return}
            viewWithTag.removeFromSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.showActivityIndicator(spinner: spinner)
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
    
    private func setupItems() {
//        noticeView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.addSubview(refreshControll)
    }
    
    private func setupNavigationTitle() {
        switch filteredVacancies.count {
        case 0:
            navigationItem.title = nil //TODO
        case 1:
            navigationItem.title = "\(filteredVacancies.count) вакансия в работе"
        case 2...4:
            navigationItem.title = "\(filteredVacancies.count) вакансии в работе"
        default:
            navigationItem.title = "\(filteredVacancies.count) вакансий в работе"
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
    
    @IBAction func menuPressedButton(_ sender: UIBarButtonItem) {
        addingNewVacansy()
    }
}

//MARK: Table view delegate, datasource
extension EmployerVacancyController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredVacancies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployerVacancyCell", for: indexPath) as! EmployerVacancyCell
        
        let vacancy = filteredVacancies[indexPath.row]
        cell.selectionStyle = .none
        
        cell.employerPublicationHeadingLbl.text = "Ваша публикация"
        cell.headingVacancyLbl.text = vacancy.heading
        cell.cityVacancyLbl.text = vacancy.city
        cell.contentVacancyLbl.text = vacancy.content
        cell.paymenVacancyLbl.text = vacancy.payment + " ₽ "
        cell.countViewsLbl.text = "\(vacancy.countViews)"
        cell.countResponseLbl.text = "6 новых откликов" //TODO
        let datePublic = vacancy.timestamp
        let date = Date(timeIntervalSince1970: datePublic / 1000)
        cell.publicationDateLbl.text = date.publicationDate(withDate: date)
//        cell.menuCurrentVacancyBtn.tag = indexPath.row
        cell.menuCurrentVacancyBtn.addTarget(self, action: #selector(menuBtn(sender:)), for: .touchUpInside)
        
        self.hideActivityIndicator(spinner: spinner)
        return cell
    }
    
    @objc func menuBtn(sender: UIButton){
//        let buttonTag = sender.tag
        menuVacacyBtn()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: Firebase
extension EmployerVacancyController {
    
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
                
                for item in _vacansy as! [Vacancy] {
                    if item.userId == self.userProfileID {
                        self.headingVacancy = item.heading
                        array.append(item)
                    }
                    self.filteredVacancies = array
                }
                self.tableView.reloadData()
            }
            self?.checkCountElementsWithTabBar()
            self?.setupNavigationTitle()
            self?.checkNoticeView()
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
    
    private func deleteVacancy(title: String, userID: String, completion: @escaping (AuthResult) -> Void) {
        
        //check empty
        //check network
        guard Validators.isConnectedToNetwork() else {
            completion(.failure(AuthError.serverError))
            return
        }
        
        if title == headingVacancy && userID == userProfileID {
            let db = Database.database()
            guard let titleVacancy = headingVacancy else {return}
            db.reference().child("vacancies").child(titleVacancy).removeValue()
            //            self.view.activityStartAnimating(activityColor: UIColor.red, backgroundColor: UIColor.black.withAlphaComponent(0.1))
            completion(.success)
        } else {
            completion(.failure(AuthError.unknownError))
        }
    }
    
    //MARK: check items with tab bar badge
    private func checkCountElementsWithTabBar() {
        guard let tabBarItemMainScreen = tabBarController?.tabBar.items![1] else {return}
        if filteredVacancies.isEmpty {
            tabBarItemMainScreen.badgeValue = nil
        } else {
            tabBarItemMainScreen.badgeValue = "\(filteredVacancies.count)"
        }
    }
}

//MARK: create new vacancy
extension EmployerVacancyController: UIActionSheetDelegate {
    private func addingNewVacansy() {
        let createIcon = UIImage(systemName: "bolt.fill")
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
    
    private func menuVacacyBtn() {
        
        let deleteIcon = UIImage(systemName: "trash.fill")
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        //        actionSheet.view.tintColor = .black
        
        let cancel = UIAlertAction(title: "Назад", style: .cancel)
        
        let menuService = UIAlertAction(title: "Удалить вакансию", style: .destructive) {[weak self] (actionSheet) in
            
            guard let headingVacancy = self?.headingVacancy,
                let userProfileID = self?.userProfileID else {return}
            
            self?.deleteVacancy(title: headingVacancy, userID: userProfileID) { (result) in
                switch result {
                case .success:
                    self?.successAlert(title: "Удалено!", message: "Вакансия удалена успешно")
                    //                self.view.activityStopAnimating()
                    break
                case .failure(_):
                    self?.errorAlert(title: "Ошибка!", message: "Ошибка удаления")
                }
            }
        }
        
        menuService.setValue(deleteIcon, forKey: "image")
        menuService.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        
        actionSheet.addAction(menuService)
        actionSheet.addAction(cancel)
        present(actionSheet, animated: true)
    }
}

//MARK: notice create vacancy
extension EmployerVacancyController {
    func setupNoticeView(mainView: UIView, headerText: String, descriptionText: String) {
        
        let containerView = UIView()
        containerView.backgroundColor = .clear
        containerView.tag = 100
        containerView.isUserInteractionEnabled = true
        containerView.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(containerView)
        
        containerView.leftAnchor.constraint(equalTo: mainView.leftAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: mainView.rightAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: mainView.frame.height/4).isActive = true
        containerView.centerYAnchor.constraint(equalTo: mainView.centerYAnchor).isActive = true
        
        //setup headerLbl
        let headerLbl: UILabel = UILabel()
        headerLbl.textColor = UIColor.black
        headerLbl.textAlignment = NSTextAlignment.center
        headerLbl.text = headerText
        headerLbl.font = .systemFont(ofSize: 17, weight: .medium)
        headerLbl.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(headerLbl)
        
        headerLbl.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 40).isActive = true
        headerLbl.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        headerLbl.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        headerLbl.heightAnchor.constraint(equalToConstant: 17).isActive = true
        
        //descriptionMenuLbl
        let descriptionLbl: UILabel = UILabel()
        descriptionLbl.textColor = UIColor.black
        descriptionLbl.textAlignment = NSTextAlignment.center
        descriptionLbl.text = descriptionText
        descriptionLbl.font = .systemFont(ofSize: 15, weight: .ultraLight)
        descriptionLbl.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(descriptionLbl)
        
        descriptionLbl.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant:20).isActive = true
        descriptionLbl.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant:-20).isActive = true
        descriptionLbl.heightAnchor.constraint(equalToConstant: 15).isActive = true
        descriptionLbl.topAnchor.constraint(equalTo: headerLbl.bottomAnchor, constant: 10).isActive = true
        
        
        //create vacancy button
        let createButton = UIButton(type: .system)
        createButton.changeStyleButton(with: "Создать вакансию")
        createButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(createButton)
        
        createButton.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant:20).isActive = true
        createButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant:-20).isActive = true
        createButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        createButton.topAnchor.constraint(equalTo: descriptionLbl.bottomAnchor, constant: 10).isActive = true
        createButton.addTarget(self, action: #selector(handleCreateVacancy), for: .touchUpInside)
    }
    
    @objc func handleCreateVacancy() {
        performSegue(withIdentifier: "AddingVacansy", sender: nil)
    }
}
