//
//  ManagedObjectObserver.swift
//  Moody
//
//  Created by pranav on 03/02/18.
//  Copyright © 2018 RB. All rights reserved.
//

import CoreData

final class ManagedObjectObserver {
    enum ChangeType {
        case delete
    }
    
    fileprivate var token: NSObjectProtocol!
    
    init?(object: NSManagedObject, changeHandler: @escaping (ChangeType) -> ()) {
        guard let moc = object.managedObjectContext else { return nil }
        token = moc.addObjectsDidChangeNotificationObserver{ [weak self](note) in
            guard let changeType = self?.changeType(of: object, in: note) else { return }
            changeHandler(changeType)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(token)
    }
    
    fileprivate func changeType(of object: NSManagedObject, in note: ObjectsDidChangeNotification) -> ChangeType? {
        let deleted = note.deletedObjects.union(note.invalidatedObjects)
        //containsObjectIdentical uses pointer comparison "===" operator
        //Core Data guarantees there's exactly one single managed object per managed object context for any entry in the persistent store
        if note.invalidatedAllObjects || deleted.containsObjectIdentical(to: object) {
            return .delete
        }
        return nil
    }
}
