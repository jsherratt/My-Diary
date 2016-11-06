//
//  SettingsTableViewController.swift
//  My Diary
//
//  Created by Joey on 05/11/2016.
//  Copyright © 2016 Joe Sherratt. All rights reserved.
//

import UIKit
import LocalAuthentication

class SettingsTableViewController: UITableViewController {
    
    //---------------------
    //MARK: Variables
    //---------------------
    let userDefaults = UserDefaults.standard
    
    //---------------------
    //MARK: View
    //---------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Remove empty rows
        tableView.tableFooterView = UIView()
    }
    
    //---------------------
    //MARK: Button Actions
    //---------------------
    @IBAction func setTouchID(_ sender: UISwitch) {
        
        let authenticationContext = LAContext()
        var error: NSError?
        
        //Check if device supports Touch ID
        if authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            
            //Set userDefaults
            if sender.isOn {
                userDefaults.set(true, forKey: "useTouchID")
                
            }else {
                userDefaults.set(false, forKey: "useTouchID")
            }
            userDefaults.synchronize()
            
        }else {
            
            //Device does not support Touch ID
            showAlert(with: "Error", andMessage: "This device does not have a Touch ID sensor")
            sender.setOn(false, animated: true)
        }
    }
    
    //--------------------------
    //MARK: Table View Delegate
    //--------------------------
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
