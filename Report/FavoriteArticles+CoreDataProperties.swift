//
//  FavoriteArticles+CoreDataProperties.swift
//  Report.
//
//  Created by Amogh Kalyan on 12/5/21.
//
//

import Foundation
import CoreData


extension FavoriteArticles {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteArticles> {
        return NSFetchRequest<FavoriteArticles>(entityName: "FavoriteArticles")
    }

    @NSManaged public var article: String?

}

extension FavoriteArticles : Identifiable {

}
