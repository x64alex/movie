//
//  MovieData+CoreDataProperties.swift
//  Movie
//
//  Created by Yopeso on 09.08.2022.
//
//

import Foundation
import CoreData
import UIKit

extension MovieData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieData> {
        return NSFetchRequest<MovieData>(entityName: "MovieData")
    }

    @NSManaged public var title: String?

}

extension MovieData : Identifiable {

}
