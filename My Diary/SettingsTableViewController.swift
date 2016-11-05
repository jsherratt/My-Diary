//
//  SettingsTableViewController.swift
//  My Diary
//
//  Created by Joey on 05/11/2016.
//  Copyright © 2016 Joe Sherratt. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    //---------------------
    //MARK: View
    //---------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
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
