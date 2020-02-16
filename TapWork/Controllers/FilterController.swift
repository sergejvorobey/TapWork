//
//  FilterController.swift
//  TapWork
//
//  Created by Sergey Vorobey on 16/02/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit

class FilterController: UIViewController {

    @IBOutlet weak var applyFilterLabel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let button = applyFilterLabel {
            
            button.layer.cornerRadius = 10
            button.layer.backgroundColor = UIColor.red.cgColor
            button.setTitle("Применить фильтр", for: .normal)
            button.setTitleColor(.white, for: .normal)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func applyFilterButton(_ sender: UIButton) {
    }
    
}
