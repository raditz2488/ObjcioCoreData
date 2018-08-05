//
//  Utitlities.swift
//  Moody
//
//  Created by pranav on 03/02/18.
//  Copyright © 2018 RB. All rights reserved.
//

import Foundation


extension Sequence where Iterator.Element: NSObjectProtocol {
    func containsObjectIdentical(to object: AnyObject) -> Bool {
        return contains { $0 === object }
    }
}


extension Array {
    var decomposed: (Iterator.Element, [Iterator.Element])? {
        guard let x = first else { return nil }
        return (x, Array(self[1..<count]))
    }
    
    func sliced(size: Int) -> [[Iterator.Element]] {
        var result: [[Iterator.Element]] = []
        for idx in stride(from: startIndex, to: endIndex, by: size) {
            let end = Swift.min(idx + size, endIndex)
            result.append(Array(self[idx..<end]))
        }
        return result
    }
}

