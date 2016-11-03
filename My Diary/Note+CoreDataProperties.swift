//
//  Note.swift
//  My Diary
//
//  Created by Joey on 02/11/2016.
//  Copyright © 2016 Joe Sherratt. All rights reserved.
//

import UIKit
import CoreData

extension Note {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        
        let fetchRequest = NSFetchRequest<Note>(entityName: "Note")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        return fetchRequest
    }
}

extension Note {
    
    @NSManaged public var date: NSDate
    @NSManaged public var text: String
    @NSManaged public var image: NSData?
    @NSManaged public var location: Location?
}
