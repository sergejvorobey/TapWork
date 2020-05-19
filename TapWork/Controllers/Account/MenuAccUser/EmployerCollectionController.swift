//
//  EmployerCollectionController.swift
//  TapWork
//
//  Created by Sergey Vorobey on 15/05/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit

class EmployerCollectionController: UICollectionViewController {
    
    private let sectionInsets = UIEdgeInsets(top: 20.0,
                                             left: 20.0,
                                             bottom: 20.0,
                                             right: 20.0)
    private let itemsPerRow: CGFloat = 2

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.title = "Сервисы для работодателя"

    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return 3
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmployerCollectionCell", for: indexPath) as! EmployerCollectionCell
        
        let index = indexPath.row
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 0.1
        
        switch index {
        case 0:
            cell.headerRow.text = "Создать вакансию"
            cell.imageEmployerMenu.image = #imageLiteral(resourceName: "plusIcon")
        case 1:
            cell.headerRow.text = "Вакансии в работе"
            cell.imageEmployerMenu.image = #imageLiteral(resourceName: "settingAcc")
        case 2:
            cell.headerRow.text = "Черновик"
        default:
            break
        }
    
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let index = indexPath.row

        switch index {
        case 0:
            performSegue(withIdentifier: "addVacansy", sender: nil)
        case 1:
            performSegue(withIdentifier: "InWorkVacansy", sender: nil)
        default:
            break
        }
    }
}

// MARK: UICollectionViewDelegate
extension EmployerCollectionController : UICollectionViewDelegateFlowLayout {
    
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
