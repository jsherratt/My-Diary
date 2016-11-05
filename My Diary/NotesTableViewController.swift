//
//  NotesTableViewController.swift
//  My Diary
//
//  Created by Joey on 01/11/2016.
//  Copyright © 2016 Joe Sherratt. All rights reserved.
//

import UIKit
import CoreData
import LocalAuthentication

var hasAuthenticated = false

class NotesTableViewController: UITableViewController, UISearchBarDelegate {
    
    //---------------------
    //MARK: Variables
    //---------------------
    let coreDataManager = CoreDataManager.sharedInstance
    var selectedNote: Note?
    var notes: [Note] = []
    var searchController = UISearchController(searchResultsController: nil)
    let authenticationContext = LAContext()
    var error: NSError?
    
    //---------------------
    //MARK: Outlets
    //---------------------
    @IBOutlet var noteTableView: UITableView!
    
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
        noteTableView.tableHeaderView = searchController.searchBar
        
        //Fetch results
        fetchResults()
        
        //Check if user had 3d touch capability
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: self.tableView)
            print("Can use 3D touch")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Touch ID
        
//        if authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
//            
//            if hasAuthenticated == false {
//                performSegue(withIdentifier: "TouchID", sender: self)
//            }
//            
//        }else {
//            
//            //No biometrics
//            showAlert(with: "Error", andMessage: "This device does not have a Touch ID sensor")
//        }
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
        
        noteTableView.deselectRow(at: indexPath, animated: true)
        
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
//MARK: Extensions
//---------------------
extension NotesTableViewController: NSFetchedResultsControllerDelegate {
    
    //-------------------------------
    //MARK: Fetched Results Delegate
    //-------------------------------
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        noteTableView.reloadData()
    }
}

extension NotesTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if let searchText = searchController.searchBar.text {
            self.notes = coreDataManager.searchNote(withText: searchText)
        }
        noteTableView.reloadData()
    }
}

extension NotesTableViewController: UIViewControllerPreviewingDelegate {
    
    //Peek
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = noteTableView.indexPathForRow(at: location), let cell = noteTableView.cellForRow(at: indexPath) else { return nil }
        
        guard let previewVc = storyboard?.instantiateViewController(withIdentifier: "PreviewVc") as? PreviewViewController else { return nil }
        
        previewVc.note = coreDataManager.fetchedResultsController.object(at: indexPath)
        selectedNote = coreDataManager.fetchedResultsController.object(at: indexPath)
        
        previewVc.preferredContentSize = CGSize(width: 0, height: 0)
        
        previewingContext.sourceRect = cell.frame
        
        return previewVc
    }
    
    //Pop
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        
        if let previewVc = storyboard?.instantiateViewController(withIdentifier: "PreviewVc") as? PreviewViewController {
            
            previewVc.note = selectedNote
            
            show(previewVc, sender: self)
        }
    }
}






















