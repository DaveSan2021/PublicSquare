//
//  Location+CoreDataProperties.swift
//  PublicSquare
//
//  Created by Dave Sanyal on 3/22/23.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var name: String?
    @NSManaged public var avgrating: Double
    @NSManaged public var totalratings: Int32

}

extension Location : Identifiable {

}
