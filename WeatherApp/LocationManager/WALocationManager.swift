//
//  LocationManager.swift
//  Weather
//
//  Created by shelly.gupta on 9/12/18.
//  Copyright © 2018 shelly.gupta. All rights reserved.
//

import Foundation
import CoreLocation

protocol WALocationServiceDelegate: AnyObject {
    func locationUpdatedTo(currentLocation: CLLocation)
    func locationUpdationFailedWith(error: Error)
}

class WALocationManager: NSObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    static let shared = WALocationManager()
    var accessGranted = false
    var currentLocation: CLLocation?
    weak var delegate: WALocationServiceDelegate?

    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations[0]
        delegate?.locationUpdatedTo(currentLocation: locations[0])
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.locationUpdationFailedWith(error: error)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.denied {
            accessGranted = false
            delegate?.locationUpdationFailedWith(error: WACustomError.localError("LocationService Access has been denied. WeatherApp needs location services to show Weather Data"))
        } else if status == CLAuthorizationStatus.authorizedWhenInUse {
            accessGranted = true
            locationManager.startUpdatingLocation()
        }
    }
}
