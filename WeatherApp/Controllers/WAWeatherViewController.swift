//
//  WeatherViewController.swift
//  Weather
//
//  Created by shelly.gupta on 9/11/18.
//  Copyright © 2018 shelly.gupta. All rights reserved.
//

import UIKit

class WAWeatherViewController: UIViewController, ViewModelDelegate {
    // IBOutlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    let degreeString = (NSString(format:"%@", "\u{00B0}c") as String) as String
    // ViewModel
    private var viewModel = WeatherVCModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewModelDelegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicator.startAnimating()
        viewModel.onViewAppear()
    }

    func updateView() {
        // Stop Activity
        activityIndicator.stopAnimating()
        // Hide Error Label
        errorLabel.isHidden = true
        // Update Data Label
        locationLabel.text = viewModel.cityName
        if let iconName =  viewModel.conditionIconName {
            conditionImageView.image = UIImage(named: iconName)
        }
        if let currentTemperature = viewModel.currentTemperature {
            temperatureLabel.text = currentTemperature + degreeString
        }
        conditionLabel.text = viewModel.conditionDescription
        dayLabel.text = viewModel.currentDay
    }
    
    func updateError(_ error: Error) {
        // Handle Error Scenarios
        errorLabel.isHidden = false
        activityIndicator.stopAnimating()
        errorLabel.text = error.localizedDescription
    }
}
