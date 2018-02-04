//
//  NSManagedObjectContext+Observers.swift
//  Moody
//
//  Created by pranav on 03/02/18.
//  Copyright © 2018 RB. All rights reserved.
//

import CoreData

struct ObjectsDidChangeNotification {
    fileprivate let notification: Notification
    
    init(note: Notification) {
        //TODO: Find out what assert does
        assert(note.name == NSNotification.Name.NSManagedObjectContextObjectsDidChange)
        notification = note
    }
    
    var deletedObjects: Set<NSManagedObject> {
        return objects(forKey: NSDeletedObjectsKey)
    }
    
    var invalidatedObjects: Set<NSManagedObject> {
        return objects(forKey: NSInvalidatedObjectsKey)
    }
    
    var invalidatedAllObjects: Bool {
        return notification.userInfo?[NSInvalidatedAllObjectsKey] != nil
    }
    
    fileprivate func objects(forKey key: String) -> Set<NSManagedObject> {
        return notification.userInfo?[key] as? Set<NSManagedObject> ?? Set()
    }
}

extension NSManagedObjectContext {
    func addObjectsDidChangeNotificationObserver(_ handler: @escaping (ObjectsDidChangeNotification) -> ()) -> NSObjectProtocol {
        let nc  = NotificationCenter.default
        return nc.addObserver(forName: .NSManagedObjectContextObjectsDidChange, object: self, queue: nil, using: { (note) in
            let wrappedNote = ObjectsDidChangeNotification(note: note)
            handler(wrappedNote)
        })
    }
}
