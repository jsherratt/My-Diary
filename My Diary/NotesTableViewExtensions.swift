//
//  NotesTableViewExtensions.swift
//  My Diary
//
//  Created by Joey on 05/11/2016.
//  Copyright © 2016 Joe Sherratt. All rights reserved.
//

import UIKit

//---------------------
//MARK: Extensions
//---------------------
extension NotesTableViewController: UISearchResultsUpdating {
    
    //Search for notes
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
