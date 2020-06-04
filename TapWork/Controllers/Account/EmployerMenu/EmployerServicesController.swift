//
//  EmployerServicesController.swift
//  TapWork
//
//  Created by Sergey Vorobey on 02/06/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit
import BonsaiController

class EmployerServicesController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.clear
        view.backgroundColor = UIColor.clear
        
    }
}


extension EmployerServicesController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployerMenuCell", for: indexPath) as! EmployerMenuCell
        
        let index = indexPath.row
        cell.backgroundColor = UIColor.clear
        
        switch index {
        case 0:
            cell.headerService.text = "Создать вакансию"
            //            cell.descriptionLabel.text = item.profession
//            cell.countElementService.isHidden = true
            cell.imageService.image = #imageLiteral(resourceName: "plusIcon")
        case 1:
            cell.headerService.text = "Ваши вакансии"
            //            cell.descriptionLabel.text = item.experience
//            cell.countElementService.text = "2" //TODO
//            cell.countElementService.isHidden = true
            cell.imageService.image = #imageLiteral(resourceName: "inWork")
        case 2:
            cell.headerService.text = "Черновик"
            //            cell.descriptionLabel.text = item.aboutMe
//            cell.countElementService.isHidden = true
//            cell.countElementService.text = "0" //TODO
            cell.imageService.image = #imageLiteral(resourceName: "favoritesStar")
        default:
            break
        }
        
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let index = indexPath.row
        
        switch index {
        case 0:
            performSegue(withIdentifier: "AddingVacansy", sender: nil)
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddingVacansy" {
            segue.destination.transitioningDelegate = self
            segue.destination.modalPresentationStyle = .custom
        }
    }
}

//MARK: Present modally response vacansy controller
extension EmployerServicesController: BonsaiControllerDelegate {
    // return the frame of your Bonsai View Controller
    func frameOfPresentedView(in containerViewFrame: CGRect) -> CGRect {
        
        return CGRect(origin: CGPoint(x: 0, y: containerViewFrame.height / 4 /*containerViewFrame.height / 2*/),
                      size: CGSize(width: containerViewFrame.width,
                                   height: containerViewFrame.height / (4/3)))
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
