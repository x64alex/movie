//
//  Movie+CoreDataProperties.swift
//  Movie
//
//  Created by Yopeso on 09.08.2022.
//
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var title: String?

}

extension Movie : Identifiable {

}
