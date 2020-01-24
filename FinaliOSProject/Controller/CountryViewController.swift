//
//  CountryViewController.swift
//  FinaliOSProject
//
//  Created by Dharam Singh on 2020-01-21.
//  Copyright © 2020 Dharam Singh. All rights reserved.
//

import UIKit

class CountryViewController: UIViewController {
    
    // Country List Array
    var selected = ""
    var checkVC = false
    var countryComeToUpdate = ""
    
    var countryList = ["Canada","United States","Greenland","Maxico","Greenland","Iceland" ]
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func doneBtnPressed(_ sender: Any) {
        goToFirstViewController()
        dismiss(animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib.init(nibName: "CountryCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "CountryCell")
        
    }
    func goToFirstViewController() {
        
        if checkVC == true{
            let vc = self.navigationController?.viewControllers[1] as! AddDetailViewController
                   vc.selectedCountry = selected
                   
                   
                   self.navigationController?.popViewController(animated: true)
        }else{
            let vc = self.navigationController?.viewControllers[1] as! UpdateViewController
                   vc.selectedCountry = selected
                   
                   
                   self.navigationController?.popViewController(animated: true)
        }
       
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let resultVC = segue.destination as? AddDetailViewController {
            resultVC.selectedCountry = selected
        }
    }
}

extension CountryViewController: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell") as! CountryCell
       
        cell.countryLbl.text = countryList[indexPath.row]
        
        return cell
        
    }
    
    // checkmarks when tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        
        selected = countryList[indexPath.row]
        
        
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
        
    }
    
}

