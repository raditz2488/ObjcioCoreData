//
//  Localizable.swift
//  Moody
//
//  Created by pranav on 03/02/18.
//  Copyright © 2018 RB. All rights reserved.
//

import Foundation

enum LocalizedText: String {
    case cameraView_tapToCapture = "CameraView.tapToCapture"
    case cameraView_needAccess = "CameraView.needAccess"
    case mood_dateComponentFormat = "Mood.dateComponentFormat"
    case regions_title = "Regions.title"
}

func localized(_ key: LocalizedText) -> String {
    return NSLocalizedString(key.rawValue, tableName: nil, bundle: Bundle.main, value: key.rawValue, comment: "")
}


func localized(_ key: LocalizedText, args: [CVarArg]) -> String {
    let format = localized(key)
    return withVaList(args) { arguments -> String in
        return NSString(format: format, locale: NSLocale.current, arguments: arguments) as String
    }
}
