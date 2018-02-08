//
//  MoodyStack.swift
//  Moody
//
//  Created by pranav on 03/02/18.
//  Copyright © 2018 RB. All rights reserved.
//

import CoreData

enum MoodyStackErrors: String {
    case loadStoreFailed = "Failed to load Moody store"
}

let moodyDataModelFileName = "Moody"

func createMoodyContainer(completion: @escaping (NSPersistentContainer) -> ()) {
    //1.Create container for Moody data model
    //Coredata uses the name we pass to look up the data model.
    //It should match the name of our .xcdatamodeld bundle
    //This probably also creates the folder in which the database will exist
    let container = NSPersistentContainer(name: moodyDataModelFileName)
    
    //2.Load persistentStore for our data model
    //This loadPersistentStores is an async method it has completion block as parameter.
    //Completion block takes two params.
    //First is of type NSPersistentStoreDescription.
    //The second one is of type Error?.
    //This method tries to open the underlying sqlite database file.
    //If this database file doesn't exist yet, Coredata will generate it using the entity we described in the data model file.
    //It does this by generating schema from the entities we describe in the data model.
    container.loadPersistentStores { (_, error) in
        //Check if we had an error while loading the store. If we have an error we forcefully crash the app so we know at first hand why it happened.
        guard error == nil else { fatalError(MoodyStackErrors.loadStoreFailed.rawValue + "\(error!)") }
        
        //There was no error loading the store so we call our completion handler on main thread
        DispatchQueue.main.async { completion(container) }
    }
}
