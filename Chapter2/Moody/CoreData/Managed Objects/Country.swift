//
//  Country.swift
//  Moody
//
//  Created by pranav on 04/02/18.
//  Copyright © 2018 RB. All rights reserved.
//

import CoreData

final class Country: NSManagedObject {
    @NSManaged var updatedAt: Date
    fileprivate(set) var iso3166Code: ISO3166.Country {
        get {
            guard let c = ISO3166.Country(rawValue: numericISO3166Code) else { fatalError("Unknown country code") }
            return c
        }
        
        set {
            numericISO3166Code = newValue.rawValue
        }
    }
    @NSManaged fileprivate var numericISO3166Code: Int16
}

extension Country: Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(updatedAt), ascending: false)]
    }
}
