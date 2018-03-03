//
//  RootViewController.swift
//  Moody
//
//  Created by pranav on 03/02/18.
//  Copyright © 2018 RB. All rights reserved.
//

import UIKit
import CoreData

class RootViewController: UIViewController, SegueHandler {
    enum SegueIdentifier: String {
        case embedNavigation = "embedNAvigationController"
        case embedCamera = "embedCamera"
    }
    
    var managedObjectContext: NSManagedObjectContext!
    fileprivate var cameraViewController: CameraViewController?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifier(for: segue) {
        case .embedNavigation:
            guard let nc = segue.destination as? UINavigationController, let vc = nc.viewControllers.first as? RegionsTableViewController else { fatalError("wrong view controller type") }
            vc.managedObjectContext = managedObjectContext
        case .embedCamera:
            guard let cameraVC = segue.destination as? CameraViewController else { fatalError("must be camera view controller") }
            cameraViewController = cameraVC
            cameraViewController?.delegate = self
        }
    }
}

extension RootViewController: CameraViewControllerDelegate {
    func didCapture(_ image: UIImage) {
        managedObjectContext.performChanges {
            _ = Mood.insert(into: self.managedObjectContext, image: image, location: nil, placemark: nil)
        }
    }
}
