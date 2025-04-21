//
//  Contacts+CoreDataClass.swift
//  PokemonContactsApp
//
//  Created by 허성필 on 4/17/25.
//
//

import Foundation
import CoreData

@objc(Contacts)
public class Contacts: NSManagedObject {
    public static let className = "Contacts"
    public enum Key {
        static let name = "name"
        static let phoneNumber = "phoneNumber"
        static let imageUrl = "imageUrl"
    }
}
