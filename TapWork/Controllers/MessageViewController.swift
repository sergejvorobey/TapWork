//
//  MessageViewController.swift
//  TapWork
//
//  Created by Sergey Vorobey on 02/04/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var messages = [String]()
    private let spinner = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()

        navigationItem.title = "Сообщения Test"
        
        tableView.separatorColor = UIColor.clear
        

    }

    func checkMessages() -> String? {
        if messages.isEmpty == true {
            navigationItem.title = "Сообщений нет"
            tableView.isHidden = true
        }
        return nil
    }
}

extension MessageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let messageCell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
        
//        if checkMessages() != nil {
            messageCell.nameUserMessage.text = "Sergey Vorobey"
            messageCell.messageText.text = "Я по поводу вакансии, вот моя визитка. Посмотрите пожалуйста!"
            messageCell.datePublic.text = "22:22, 12.05"
            messageCell.countMessage.text = "1"
            messageCell.imageUser.image = #imageLiteral(resourceName: "userImage")
            messageCell.imageUser.changeStyleImage()
//        }
        
        return messageCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChatViewController" {
            //            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            //            let vacansy = vacancies[indexPath.row]
            //            let newHumanVC = segue.destination as! ShowInfoVacansyViewController
            //            newHumanVC.vacansyInfo = vacansy
        }
    }
}
