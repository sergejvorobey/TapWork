//
//  MainScreenTableViewController.swift
//  TapWork
//
//  Created by Sergey Vorobey on 08/02/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit

class MainScreenTableViewController: UITableViewController {
    
    private var vacancies:[Vacancy] = []
    private let vacansyProvider: VacansyProvider = VacansyProvider()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        vacancies = vacansyProvider.vacancies
        tableView.tableFooterView = UIView()

    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return vacancies.count
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return vacancies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vacanciesCell = tableView.dequeueReusableCell(withIdentifier: "VacanciesCell", for: indexPath) as! VacansyTableViewCell
        
        let vacansy = vacancies[indexPath.row]
        vacanciesCell.headingLabel.text = vacansy.heading
        vacanciesCell.contentLabel.text = vacansy.content
        vacanciesCell.paymentLabel.text = vacansy.payment + " ₽ "
        vacanciesCell.publicationDateLabel.text = vacansy.publicationDate
        
        return vacanciesCell
    }
    
    @IBAction func cancelButton(_ sender: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let ShowInfoVacansyViewController = storyboard?.instantiateViewController(withIdentifier: "ShowInfoVacansyViewController") as! ShowInfoVacansyViewController
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            ShowInfoVacansyViewController.vacansyInfo = vacancies[selectedIndexPath.row]
        }
        
        self.navigationController?.pushViewController(ShowInfoVacansyViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
