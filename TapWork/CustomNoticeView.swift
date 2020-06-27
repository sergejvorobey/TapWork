//
//  CustomNoticeView.swift
//  TapWork
//
//  Created by Sergey Vorobey on 26/06/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit

class CustomNoticeView: UIView {
    
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
        
    }
}


