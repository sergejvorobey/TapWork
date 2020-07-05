//
//  FavoritesVacanciesController.swift
//  TapWork
//
//  Created by Sergey Vorobey on 20/06/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Firebase

class FavoritesVacanciesController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var favoriteVacancy = [Vacancy]()
    private var userProfileID: String?
    private let spinner = NVActivityIndicatorView(frame: CGRect.init(x: 0, y: 0,
                                                                     width: 30,
                                                                     height: 30),
                                                  type: .circleStrokeSpin,
                                                  color: .red,
                                                  padding: .none)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getProfileUserID()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.showActivityIndicator(spinner: spinner)
        setupItems()
        getFavoritesVacancies {[weak self] (result) in
            switch result {
            case .success:
                break
            case .failure(let error):
                self?.errorAlert(title: "Ошибка", message: error.localizedDescription)
            }
        }
    }
    
    private func setupItems() {
        navigationItem.title = "Избранное"
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    private func checkNoticeView() {
        self.hideActivityIndicator(spinner: spinner)
        switch favoriteVacancy.isEmpty {
        case true:
            tableView.isHidden = true
            setupNoticeView(mainView: self.view,
                            headerText: "Добавьте вакансии в избранное",
                            descriptionText: "Вы можете вернуться к ним позже, что бы откликнуться")
        default:
            tableView.isHidden = false
            guard let viewWithTag = self.view.viewWithTag(100) else {return}
            viewWithTag.removeFromSuperview()
        }
    }
}

extension FavoritesVacanciesController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteVacancy.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let favoriteCell = tableView.dequeueReusableCell(withIdentifier: "FavoriteVacancyCell", for: indexPath) as! FavoriteVacancyCell
        let vacancy = favoriteVacancy[indexPath.row]
        
        favoriteCell.headingVacancyLbl.text = vacancy.heading
        favoriteCell.cityVacancyLbl.text = vacancy.city
        favoriteCell.categoryVacancyLbl.text = "123"
        favoriteCell.contentVacancyLbl.text = vacancy.content
        favoriteCell.paymenVacancyLbl.text = vacancy.payment
        favoriteCell.countViewsLbl.text = "\(vacancy.countViews)"
        
        
        self.hideActivityIndicator(spinner: spinner)
        return favoriteCell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: Firebase
extension FavoritesVacanciesController {
    
}

//MARK: notice custom view
extension FavoritesVacanciesController {
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
        headerLbl.numberOfLines = 0
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
        //        descriptionLbl.lineBreakMode = .byWordWrapping
        descriptionLbl.numberOfLines = 0
        descriptionLbl.font = .systemFont(ofSize: 15, weight: .ultraLight)
        descriptionLbl.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(descriptionLbl)
        
        descriptionLbl.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant:20).isActive = true
        descriptionLbl.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant:-20).isActive = true
        descriptionLbl.heightAnchor.constraint(equalToConstant: 40).isActive = true
        descriptionLbl.topAnchor.constraint(equalTo: headerLbl.bottomAnchor, constant: 10).isActive = true
        
        //search vacancy button
        let searchButton = UIButton(type: .system)
        searchButton.changeStyleButton(with: "Искать вакансии")
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(searchButton)
        
        searchButton.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant:20).isActive = true
        searchButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant:-20).isActive = true
        searchButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        searchButton.topAnchor.constraint(equalTo: descriptionLbl.bottomAnchor, constant: 10).isActive = true
        searchButton.addTarget(self, action: #selector(handleSearchVacancy), for: .touchUpInside)
    }
    
    @objc func handleSearchVacancy() {
        tabBarController?.selectedIndex = 0
    }
}

extension FavoritesVacanciesController {
    
    private func getFavoritesVacancies (completion: @escaping (AuthResult) -> Void) {
//        guard Validators.isConnectedToNetwork()  else {
//            completion(.failure(AuthError.serverError))
//            return
//        }
//
//        let dataLoader = LoaderDataFirebase()
//        dataLoader.getDataVacancies()
//
//        dataLoader.completionHandler{[weak self] (vacancy, status, message) in
//            var array = [Vacancy]()
//            if status {
//                guard let self = self else {return}
//                guard let _vacancy = vacancy else {return}
//                for item in _vacancy as! [Vacancy] {
//                    let filteredNums = item.favoritesVacancies.filter({$0 == self.userProfileID})
//
//                    if filteredNums.first == self.userProfileID {
//                        array.append(item)
//                    }
//                    self.favoriteVacancy = array
//                }
//            }
//            DispatchQueue.main.async {
//                self?.tableView.reloadData()
//            }
//            self?.checkNoticeView()
//        }
//        completion(.success)
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
    
    //MARK: delete favorites
    private func deleteFavoriteVacancy() {
        
    }
}
