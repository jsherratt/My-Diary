//
//  location.swift
//  My Diary
//
//  Created by Joey on 02/11/2016.
//  Copyright © 2016 Joe Sherratt. All rights reserved.
//

import UIKit
import CoreData

extension Location {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        
        return NSFetchRequest<Location>(entityName: "Location");
    }
    
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var Notes: NSSet?
}

extension Location {
    
    @objc(addEntriesObject:)
    @NSManaged public func addToEntries(_ value: Note)
    
    @objc(removeEntriesObject:)
    @NSManaged public func removeFromEntries(_ value: Note)
    
    @objc(addEntries:)
    @NSManaged public func addToEntries(_ values: NSSet)
    
    @objc(removeEntries:)
    @NSManaged public func removeFromEntries(_ values: NSSet)
}
