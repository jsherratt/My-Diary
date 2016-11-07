//
//  CoreDataManager.swift
//  My Diary
//
//  Created by Joey on 02/11/2016.
//  Copyright © 2016 Joe Sherratt. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

public class CoreDataManager {
    
    //Shared instance
    static let sharedInstance = CoreDataManager()
    
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
    
    lazy var fetchedResultsController: NSFetchedResultsController<Note> = {
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: Note.fetchRequest(), managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }()
    
    //----------------------
    //MARK: Saving
    //----------------------
    func saveContext () {
        
        if self.managedObjectContext.hasChanges {
            
            do {
                try self.managedObjectContext.save()
                print("Save successfull")
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    //Save note
    func saveNote(withText text: String, andImageData imageData: Data?, andLocation location: CLLocation?) {
        
        let noteDescription = NSEntityDescription.entity(forEntityName: "Note", in: self.managedObjectContext)!
        let note = Note(entity: noteDescription, insertInto: self.managedObjectContext)
        
        if let imageData = imageData {
            note.image = imageData as NSData
        }
        
        if let location = location {
            note.location = self.saveLocation(withLatitude: location.coordinate.latitude, andLongitude: location.coordinate.longitude, andNote: note)
        }
        
        note.text = text
        note.date = Date() as NSDate
        
        self.saveContext()
    }
    
    //Save location
     func saveLocation(withLatitude latitude: Double, andLongitude longitude: Double, andNote note: Note) -> Location {
        
        let entityDescription = NSEntityDescription.entity(forEntityName: "Location", in: self.managedObjectContext)!
        let location = Location(entity: entityDescription, insertInto: self.managedObjectContext)
        
        location.latitude = latitude
        location.longitude = longitude
        
        return location
    }
    
    //----------------------
    //MARK: Deleting
    //----------------------
    func deleteNote(note: Note) {
        
        managedObjectContext.delete(note)
        self.saveContext()
    }
    
    func deleteAllNotes() {
        
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        let notes = try! self.managedObjectContext.fetch(fetchRequest)
        
        for note in notes {
            
            self.managedObjectContext.delete(note)
            self.saveContext()
        }
    }
    
    //----------------------
    //MARK: Searching
    //----------------------
    func searchNote(withText text: String) -> [Note] {
        
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        fetchRequest.entity = entityDescription
        
        let predicate = NSPredicate(format: "text contains[cd] %@", text)
        fetchRequest.predicate = predicate
        
        let notes = try! managedObjectContext.fetch(fetchRequest)
        
        return notes
    }
    
}


































