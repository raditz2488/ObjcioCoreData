//
//  GeoLocationController.swift
//  Moody
//
//  Created by pranav on 12/05/18.
//  Copyright © 2018 RB. All rights reserved.
//

import CoreLocation

protocol GeoLocationControllerDelegate: class {
    func geoLocationDidChangeAuthorizationStatus(authorized: Bool)
}

class GeoLocationController: NSObject {
    var isAuthorized: Bool {
        let status = CLLocationManager.authorizationStatus()
        return status == .authorizedAlways || status == .authorizedWhenInUse
    }
    
    fileprivate weak var delegate: GeoLocationControllerDelegate!
    fileprivate var locationManager: CLLocationManager = CLLocationManager()
    
    fileprivate var previousLocation: CLLocation?
    fileprivate var previousPlacemark: CLPlacemark?
    
    fileprivate var geocoder = CLGeocoder()

    
    required init(delegate: GeoLocationControllerDelegate) {
        super.init()
        self.delegate = delegate
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else {
            start()
        }
    }
    
    fileprivate func start() {
        delegate.geoLocationDidChangeAuthorizationStatus(authorized: isAuthorized)
        if isAuthorized {
            locationManager.startUpdatingLocation()
        }
    }
    
    func retrieveCurrentLocation(_ completion: @escaping (CLLocation?, CLPlacemark?) -> ()) {
        guard let location = locationManager.location else {
            completion(nil, nil)
            return
        }
        
        guard previousLocation == nil || (previousLocation?.distance(from: location) ?? 0 ) > 1000 || previousPlacemark == nil else {
            return completion(location, previousPlacemark)
        }
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            self.previousPlacemark = placemarks?.first
            completion(location, placemarks?.first)
        }
    }
}

extension GeoLocationController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        start()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
