//
//  MoodDetailViewController.swift
//  Moody
//
//  Created by pranav on 03/02/18.
//  Copyright © 2018 RB. All rights reserved.
//

import UIKit

class MoodDetailViewController: UIViewController {
    @IBOutlet weak var moodView: MoodView!
    fileprivate var observer: ManagedObjectObserver?
    var mood: Mood! {
        didSet {
            observer = ManagedObjectObserver(object: mood, changeHandler: { [weak self](type) in
                guard type == .delete else { return }
                _ = self?.navigationController?.popViewController(animated: true)
            })
            updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    @IBAction func deleteMood(_ sender: Any) {
        mood.managedObjectContext?.performChanges {
            self.mood.managedObjectContext?.delete(self.mood)
        }
    }
    
    fileprivate func updateViews() {
        moodView?.colors = mood.colors
    }    
}
