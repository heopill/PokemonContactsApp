//
//  Contacts+CoreDataProperties.swift
//  PokemonContactsApp
//
//  Created by 허성필 on 4/17/25.
//
//

import Foundation
import CoreData


extension Contacts {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contacts> {
        return NSFetchRequest<Contacts>(entityName: "Contacts")
    }

    @NSManaged public var name: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var imageUrl: String?

}

extension Contacts : Identifiable {

}
