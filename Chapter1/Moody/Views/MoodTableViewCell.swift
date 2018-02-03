//
//  MoodTableViewCell.swift
//  Moody
//
//  Created by pranav on 03/02/18.
//  Copyright © 2018 RB. All rights reserved.
//

import UIKit

class MoodTableViewCell: UITableViewCell {
    @IBOutlet weak var moodView: MoodView!
    @IBOutlet weak var label: UILabel!
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    formatter.doesRelativeDateFormatting = true
    formatter.formattingContext = .standalone
    return formatter
}()

extension MoodTableViewCell {
    func configure(for mood: Mood) {
        moodView.colors = mood.colors
        label.text = dateFormatter.string(from: mood.date)
    }
}
