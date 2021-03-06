//
//  MoodsTableViewController.swift
//  Moody
//
//  Created by pranav on 03/02/18.
//  Copyright © 2018 RB. All rights reserved.
//

import UIKit
import CoreData

class MoodsTableViewController: UITableViewController, SegueHandler {
    
    enum SegueIdentifier: String {
        case showMoodDetail = "showMoodDetail"
    }
    
    var managedObjectContext: NSManagedObjectContext!
    fileprivate var dataSource: TableViewDataSource<MoodsTableViewController>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    fileprivate func setupTableView() {
        let request = Mood.sortedFetchRequest
        request.fetchBatchSize = 20
        request.returnsObjectsAsFaults = false
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        dataSource = TableViewDataSource(tableView: tableView, cellIdentifier: "MoodCell", fetchedResultsController: frc, delegate: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifier(for: segue) {
        case .showMoodDetail:
            guard let vc = segue.destination as? MoodDetailViewController else { fatalError("Wrong view controller type") }
            guard let mood = dataSource.selectedObject else { fatalError("Showing detail, but no selected row?") }
            vc.mood = mood
        }
    }
}

extension MoodsTableViewController: TableViewDataSourceDelegate {
    func configure(_ cell: MoodTableViewCell, for object: Mood) {
        cell.configure(for: object)
    }
}
