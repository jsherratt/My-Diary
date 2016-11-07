//
//  My_DiaryTests.swift
//  My DiaryTests
//
//  Created by Joey on 01/11/2016.
//  Copyright © 2016 Joe Sherratt. All rights reserved.
//

import XCTest
import CoreData
import CoreLocation
@testable import My_Diary

class My_DiaryTests: XCTestCase {
    
    //
    let coreDataManager = CoreDataManager.sharedInstance
    
    //----------------------
    //MARK: Core Data Stack
    //----------------------
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "My_Diary")
        container.loadPersistentStores(completionHandler: { storeDiscriptor, error in
            
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        
        let managedObjectContext = CoreDataManager.sharedInstance.persistentContainer.viewContext
        return managedObjectContext
    }()
    
    lazy var entityDescription: NSEntityDescription = {
        let description = NSEntityDescription.entity(forEntityName: "Note", in: self.managedObjectContext)!
        return description
    }()
    
    lazy var locationEntityDescription: NSEntityDescription = {
        let description = NSEntityDescription.entity(forEntityName: "Location", in: self.managedObjectContext)!
        return description
    }()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Note> = {
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: Note.fetchRequest(), managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }()
    
    //---------------------
    //MARK: Functions
    //---------------------
    func createFakeNote() {
        
        let fakeNote = Note(entity: self.entityDescription, insertInto: self.managedObjectContext)
        fakeNote.text = "Test Fake Note"
        fakeNote.date = NSDate()
        fakeNote.location = Location(entity: self.locationEntityDescription, insertInto: self.managedObjectContext)
        fakeNote.image = UIImageJPEGRepresentation(UIImage(named: "icn_noimage")!, 1.0) as NSData?
        
        coreDataManager.saveContext()
    }
    
    func deleteNote() {
        
        if let note = self.coreDataManager.fetchedResultsController.fetchedObjects?.first {
            
            coreDataManager.deleteNote(note: note)
            coreDataManager.saveContext()
        }
    }
    
    //---------------------
    //MARK: Setup Teardown
    //---------------------
    override func setUp() {
        super.setUp()
        
        //Create fake note
        createFakeNote()
    }
    
    override func tearDown() {
        super.tearDown()
        
        //Delete note
        if let note = self.coreDataManager.fetchedResultsController.fetchedObjects?.first {
            coreDataManager.deleteNote(note: note)
            coreDataManager.saveContext()
        }
    }

    //---------------------
    //MARK: Tests
    //---------------------
    func testCreateNote() {
        
        //Delete all notes
        coreDataManager.deleteAllNotes()
        
        //Check to make sure the database is empty
        XCTAssert(self.coreDataManager.fetchedResultsController.fetchedObjects?.count == 0, "One or more notes already exist in the database")
        
        //Create note
        createFakeNote()
        
        //Check if note was created
        XCTAssert(self.coreDataManager.fetchedResultsController.fetchedObjects?.count == 1, "Note was NOT created successfully")
    }
    
    func testNoteChanged() {
        
        //Check if note was created
        XCTAssert(self.coreDataManager.fetchedResultsController.fetchedObjects?.count == 1, "Note was NOT created successfully")
        
        let note = coreDataManager.fetchedResultsController.fetchedObjects?.first
        note?.text = "Test Fake Note Changed"
        note?.date = NSDate()
        
        coreDataManager.saveContext()
        
        XCTAssert(self.coreDataManager.fetchedResultsController.fetchedObjects?.count == 1, "Note was NOT changed successfully")
    }
    
    func testDeleteNote() {
        
        //Check if note was created
        XCTAssert(self.coreDataManager.fetchedResultsController.fetchedObjects?.count == 1, "Note was NOT created successfully")
        
        //Delete the note
        deleteNote()
        
        //Check if note was deleted
        XCTAssert(self.coreDataManager.fetchedResultsController.fetchedObjects?.count == 0, "Note was NOT deleted successfully")
    }
    
    
    
    
}









