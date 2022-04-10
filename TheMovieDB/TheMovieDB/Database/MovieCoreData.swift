//
//  MovieCoreData.swift
//  TheMovieDB
//
//  Created by jianli on 4/6/22.
//

import Foundation
import CoreData

class MovieCoreData{
    static var context:NSManagedObjectContext {
        let container = NSPersistentContainer(name: "MovieDatabase")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        let context = container.viewContext
        return context
    }
}
