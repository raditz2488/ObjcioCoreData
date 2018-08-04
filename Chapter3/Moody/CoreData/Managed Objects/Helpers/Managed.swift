//
//  Managed.swift
//  Moody
//
//  Created by pranav on 03/02/18.
//  Copyright © 2018 RB. All rights reserved.
//

import CoreData

protocol Managed: class, NSFetchRequestResult {
    static var entityName: String { get }
    static var defaultSortDescriptors: [NSSortDescriptor] { get }
}

extension Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] { return [] }
    
    static var sortedFetchRequest: NSFetchRequest<Self> {
        let request = NSFetchRequest<Self>(entityName: entityName)
        request.sortDescriptors = defaultSortDescriptors
        return request
    }
    
    public static func sortedFetchRequest(with predicate: NSPredicate) -> NSFetchRequest<Self> {
        let request = sortedFetchRequest
        request.predicate = predicate
        return request
    }
}

extension Managed where Self: NSManagedObject {
    static var entityName: String { return entity().name! }
    
    static func findOrCreate(in context: NSManagedObjectContext, matching predicate: NSPredicate, configure:(Self) -> ()) -> Self {
        //Here there are three possibilites.
        //1. The object may exist in the context i.e on RAM and if found return it
        //2. The object may exist in the database i.e on secondary storage and if fetched return it.
        //3. It may not exist in the context or in database in which case we create one and return it.
        //Thats exactly how the method findOrFetch is defined
        guard let object  = findOrFetch(in: context, matching: predicate) else {
            let newObject: Self = context.insertObject()
            configure(newObject)
            return newObject
        }
        return object
    }
    
    static func findOrFetch(in context: NSManagedObjectContext, matching predicate: NSPredicate) -> Self? {
        //If object is in context we return it.
        //If object is not in context we fetch it from database
        guard let object = materializedObject(in: context, matching: predicate) else {
            return fetch(in: context) { request in
                request.predicate = predicate
                request.returnsObjectsAsFaults = false
                request.fetchLimit = 1
            }.first
        }
        return object
    }
    
    static func materializedObject(in context: NSManagedObjectContext, matching predicate: NSPredicate) -> Self? {
        //If object is in context and it is not a fault then we evaluate the predicate. If it evaluates to true then we return the object else we return nil.
        for object in context.registeredObjects where !object.isFault {
            guard let result = object as? Self, predicate.evaluate(with: result) else { continue }
            return result
        }
        return nil
    }
    
    static func fetch(in context: NSManagedObjectContext, configurationBlock: (NSFetchRequest<Self>) -> () = { _ in }) -> [Self] {
        let request = NSFetchRequest<Self>(entityName: Self.entityName)
        configurationBlock(request)
        return try! context.fetch(request)
    }
}
