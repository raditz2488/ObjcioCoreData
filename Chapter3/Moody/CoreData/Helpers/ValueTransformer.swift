//
//  ValueTransformer.swift
//  Moody
//
//  Created by pranav on 05/08/18.
//  Copyright © 2018 RB. All rights reserved.
//

import Foundation

class ClosureValueTransformer<A: AnyObject, B: AnyObject>: ValueTransformer {
    typealias Transform = (A?) -> B?
    typealias ReverseTransform = (B?) -> A?
    
    fileprivate let transform: Transform
    fileprivate let reverseTransform: ReverseTransform
    
    init(transform: @escaping Transform, reverseTransform: @escaping ReverseTransform) {
        self.transform = transform
        self.reverseTransform = reverseTransform
        super.init()
    }
    
    static func registerTransformer(withName name: String, transform: @escaping Transform, reverseTransform: @escaping ReverseTransform) {
        let vt = ClosureValueTransformer(transform: transform, reverseTransform: reverseTransform)
        Foundation.ValueTransformer.setValueTransformer(vt, forName: NSValueTransformerName(rawValue: name))
    }
    
    override class func transformedValueClass() -> Swift.AnyClass {
        return B.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        return transform(value as? A)
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        return reverseTransform(value as? B)
    }
}
