//
//  NotesTableViewController.swift
//  My Diary
//
//  Created by Joey on 01/11/2016.
//  Copyright © 2016 Joe Sherratt. All rights reserved.
//

import UIKit
import CoreData

class NotesTableViewController: UITableViewController {
    
    //---------------------
    //MARK: Variables
    //---------------------
    let coreDataManager = CoreDataManager.sharedInstance
    var notes: [Note] = []
    
    //---------------------
    //MARK: Outlets
    //---------------------
    
    
    //---------------------
    //MARK: View
    //---------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set fetched results controller delegate
        coreDataManager.fetchedResultsController.delegate = self
        
        //Fetch results
        fetchResults()
    }
    
    //---------------------
    //MARK: Functions
    //---------------------
    func fetchResults() {
        
        do {
            try coreDataManager.fetchedResultsController.performFetch()
            
        }catch let error as NSError {
            
            showAlert(with: "Error", andMessage: "\(error.localizedDescription)")
        }
    }
    
    //--------------------------
    //MARK: Table View Delegate
    //--------------------------
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let notes = coreDataManager.fetchedResultsController.fetchedObjects?.count {
            return notes
        }
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteCell
        
        let note = notes[indexPath.row]
        cell.configureCellWithNote(note: note)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//---------------------
//MARK: Extension
//---------------------
extension NotesTableViewController: NSFetchedResultsControllerDelegate {
    
    //-------------------------------
    //MARK: Fetched Results Delegate
    //-------------------------------
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        self.tableView.reloadData()
    }
}






















