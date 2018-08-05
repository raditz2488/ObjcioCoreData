//
//  Region.swift
//  Moody
//
//  Created by pranav on 03/03/18.
//  Copyright © 2018 RB. All rights reserved.
//

import CoreData

final class Region: NSManagedObject {}

extension Region: Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "updatedAt", ascending: false)]
    }
}
