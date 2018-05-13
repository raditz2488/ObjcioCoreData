//
//  MoodSource.swift
//  Moody
//
//  Created by pranav on 12/05/18.
//  Copyright © 2018 RB. All rights reserved.
//

import CoreData

enum MoodSource {
    case country(Country)
    case continent(Continent)
}

extension MoodSource {
    var predicate: NSPredicate {
        switch self {
        case .country(let c):
            return NSPredicate(format: "country = %@", argumentArray: [c])
        case .continent(let c):
            return NSPredicate(format: "country in %@", argumentArray: [c.countries])

        }
    }
    
    init(region: NSManagedObject) {
        if let country = region as? Country {
            self = .country(country)
        } else if let continent = region as? Continent {
            self = .continent(continent)
        } else {
            fatalError("\(region) is not a valid mood source")
        }
    }
    
    var managedObject: NSManagedObject? {
        switch self {
        case .country(let c): return c
        case .continent(let c): return c
        }
    }
}
