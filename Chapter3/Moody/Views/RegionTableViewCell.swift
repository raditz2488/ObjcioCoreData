//
//  RegionTableViewCell.swift
//  Moody
//
//  Created by pranav on 03/03/18.
//  Copyright © 2018 RB. All rights reserved.
//

import UIKit

class RegionTableViewCell: UITableViewCell {}

extension RegionTableViewCell {
    func configure(for object: LocalizedStringConvertible) {
        textLabel?.text = object.localizedDescription
    }
}
