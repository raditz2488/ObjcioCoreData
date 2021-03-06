//
//  Mood.swift
//  Moody
//
//  Created by pranav on 03/02/18.
//  Copyright © 2018 RB. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

final class Mood: NSManagedObject {
    @NSManaged fileprivate(set) var date: Date
    @objc public fileprivate(set) var colors: [UIColor] {
        get {
            willAccessValue(forKey: #keyPath(colors))
            var c = primitiveColors
            didAccessValue(forKey: #keyPath(colors))
            if c == nil {
                c = colorStorage.moodColors ?? []
                primitiveColors = c
            }
            return c!
        }
        
        set {
            willChangeValue(forKey: #keyPath(colors))
            primitiveColors = newValue
            didChangeValue(forKey: #keyPath(colors))
            colorStorage = newValue.moodData
        }
    }
    @NSManaged fileprivate var primitiveColors: [UIColor]?
    @NSManaged fileprivate var latitude: NSNumber?
    @NSManaged fileprivate var longitude: NSNumber?
    @NSManaged fileprivate(set) var country: Country
    @NSManaged fileprivate var colorStorage: Data
    public var location: CLLocation? {
        guard let lat = latitude, let lon = longitude else { return nil }
        return CLLocation(latitude: lat.doubleValue, longitude: lon.doubleValue)
    }
    
    static func insert(into context: NSManagedObjectContext, image: UIImage, location: CLLocation?, placemark: CLPlacemark?) -> Mood {
        let mood: Mood = context.insertObject()
        mood.colors = image.moodColors
        mood.date = Date()
        if let coord = location?.coordinate {
            mood.latitude = NSNumber(value: coord.latitude)
            mood.longitude = NSNumber(value: coord.longitude)
        }
        
        let isoCode = placemark?.isoCountryCode ?? ""
        //Get ISO3166 Country enum from iso3166 string code
        let isoCountry = ISO3166.Country.fromISO3166(isoCode)
        //Find existing country managed object or create it and then set it as moods country
        mood.country = Country.findOrCreate(for: isoCountry, in: context)
        return mood
    }
    
    override func prepareForDeletion() {
        //If all moods in the associated country are deleted we delete the country
        if country.moods.filter({ !$0.isDeleted }).isEmpty {
            managedObjectContext?.delete(country)
        }
    }
}

extension Mood: Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(date), ascending: false)]
    }
}

private let MaxColors = 8

extension UIImage {
    fileprivate var moodColors: [UIColor] {
        var colors: [UIColor] = []
        for c in dominantColors(.Moody) where colors.count < MaxColors {
            colors.append(c)
        }
        return colors
    }
}

extension UIColor {
    
    fileprivate var rgb: [UInt8] {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: nil)
        return [UInt8(red * 255), UInt8(green * 255), UInt8(blue * 255)]
    }
    
    fileprivate convenience init?(rawData: [UInt8]) {
        if rawData.count != 3 { return nil }
        let red = CGFloat(rawData[0]) / 255
        let green = CGFloat(rawData[1]) / 255
        let blue = CGFloat(rawData[2]) / 255
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
    
}

extension Data {
    public var moodColors: [UIColor]? {
        guard count > 0 && count % 3 == 0 else { return nil }
        var rgbValues = Array(repeating: UInt8(), count: count)
        rgbValues.withUnsafeMutableBufferPointer { buffer in
            let voidPointer = UnsafeMutableRawPointer(buffer.baseAddress)
            let _ = withUnsafeBytes { bytes in
                memcpy(voidPointer, bytes, count)
            }
        }
        let rgbSlices = rgbValues.sliced(size: 3)
        return rgbSlices.map { slice in
            guard let color = UIColor(rawData: slice) else { fatalError("cannot fail since we know tuple is of length 3") }
            return color
        }
    }
}


extension Sequence where Iterator.Element == UIColor {
    public var moodData: Data {
        let rgbValues = flatMap { $0.rgb }
        return rgbValues.withUnsafeBufferPointer {
            return Data(bytes: $0.baseAddress!,
                        count: $0.count)
        }
    }
}
