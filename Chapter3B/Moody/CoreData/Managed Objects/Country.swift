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
    @NSManaged fileprivate(set) var moods: Set<Mood>
    @NSManaged fileprivate(set) var continent: Continent?
    
    static func findOrCreate(for isoCountry: ISO3166.Country, in context: NSManagedObjectContext) -> Country {
        let predicate = NSPredicate(format: "%K == %d", #keyPath(numericISO3166Code), Int(isoCountry.rawValue))
        let country = findOrCreate(in: context, matching: predicate) { (createdCountry) in
            createdCountry.iso3166Code = isoCountry
            createdCountry.updatedAt = Date()
            createdCountry.continent = Continent.findOrCreateContinent(for: isoCountry, in: context)
        }
        return country
    }
    
    override func prepareForDeletion() {
        guard let c = continent else { return }
        //Filter list of countries associated with continent with not deleted and if that list is empty that means all object have been deleted. So we must delete the continent as we need it now more.
        if c.countries.filter({ !$0.isDeleted }).isEmpty {
            managedObjectContext?.delete(c)
        }
    }
}

extension Country: Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(updatedAt), ascending: false)]
    }
}

extension Country: LocalizedStringConvertible {
    var localizedDescription: String {
        return iso3166Code.localizedDescription
    }
}
