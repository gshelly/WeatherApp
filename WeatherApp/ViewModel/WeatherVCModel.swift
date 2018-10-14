//
//  WeatherVCModel.swift
//  Weather
//
//  Created by shelly.gupta on 9/11/18.
//  Copyright © 2018 shelly.gupta. All rights reserved.
//

import Foundation
import CoreLocation

protocol ViewModelDelegate: class {
    // To indicate Delegate handler to updateData in its view
    func updateView()
    // To indicate Delegate handler to updateError Scenarios its view
    func updateError(_ error: Error)
}

class WeatherVCModel: NSObject, WALocationServiceDelegate {
    // Display Model Data
    var cityName: String?
    var conditionDescription: String?
    var conditionIconName: String?
    var currentTemperature: String?
    var currentDay: String?
    // Delegate
    weak var viewModelDelegate: ViewModelDelegate?
    private let locationManager = WALocationManager.shared
    private let dateFormatter = DateFormatter()

    override init() {
        super.init()
        locationManager.delegate = self
        dateFormatter.dateFormat = "EEEE"
    }

    // Should be called by controller on viewAppear
    func onViewAppear() {
        currentDay = dateFormatter.string(from: Date())
        if locationManager.accessGranted {
            locationManager.startUpdatingLocation()
        }
    }

    func locationUpdatedTo(currentLocation: CLLocation) {
        self.locationManager.stopUpdatingLocation()
        WANetworkManager.getCurrentWeatherBy(currentCoordinates: (lat: currentLocation.coordinate.latitude, long: currentLocation.coordinate.longitude)) { [weak self](weatherModel, error) in
            // Stop updating location
            if let weatherModel = weatherModel {
                self?.cityName = weatherModel.cityName
                self?.conditionDescription = weatherModel.weatherConditionMain
                self?.conditionIconName = weatherModel.weatherIcon
                if let weatherTemp = weatherModel.temp {
                    self?.currentTemperature = String(format: "%.2f", weatherTemp)
                }
                self?.viewModelDelegate?.updateView()
            } else if let error = error {
                // Handle error case
                print(error)
                self?.viewModelDelegate?.updateError(error)
            }
        }
    }

    func locationUpdationFailedWith(error: Error) {
        // Handle error case
        self.locationManager.stopUpdatingLocation()
        self.viewModelDelegate?.updateError(error)
    }
}
