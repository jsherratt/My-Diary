//
//  NotesTableViewController.swift
//  My Diary
//
//  Created by Joey on 01/11/2016.
//  Copyright © 2016 Joe Sherratt. All rights reserved.
//

import UIKit
import CoreData

class NotesTableViewController: UITableViewController, UISearchBarDelegate {
    
    //---------------------
    //MARK: Variables
    //---------------------
    let coreDataManager = CoreDataManager.sharedInstance
    var selectedNote: Note?
    var notes: [Note] = []
    var searchController = UISearchController(searchResultsController: nil)
    
    //---------------------
    //MARK: View
    //---------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Customise navigation bar
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationItem.title = "Notes"
        
        //Set fetched results controller delegate
        coreDataManager.fetchedResultsController.delegate = self
        
        //Configure seach bar
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        self.searchController.searchBar.delegate = self
        tableView.tableHeaderView = searchController.searchBar
        
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
        
        if searchController.isActive {
            
            return self.notes.count
            
        }else {
    
            if let notes = coreDataManager.fetchedResultsController.fetchedObjects?.count {

                return notes
            }
        }
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteCell
        
        if searchController.isActive {
            
            let note = notes[indexPath.row]
            cell.configureCellWithNote(note: note)
            
        }else {
            
            let note = coreDataManager.fetchedResultsController.object(at: indexPath)
            cell.configureCellWithNote(note: note)
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        if searchController.isActive {
            
            selectedNote = notes[indexPath.row]
            
        }else {
            
            selectedNote = coreDataManager.fetchedResultsController.object(at: indexPath)
        }
        
        performSegue(withIdentifier: "ShowNote", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            if searchController.isActive {
                
                let note = notes[indexPath.row]
                coreDataManager.deleteNote(note: note)
                
            }else {
                
                let note = coreDataManager.fetchedResultsController.object(at: indexPath)
                coreDataManager.deleteNote(note: note)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowNote" {
            
            let destination = segue.destination as! UINavigationController
            let noteDetailVc = destination.topViewController as! NoteDetailViewController
            
            noteDetailVc.note = selectedNote
        }
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

extension NotesTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if let searchText = searchController.searchBar.text {
            self.notes = coreDataManager.searchNote(withText: searchText)
        }
        self.tableView.reloadData()
    }
}






















