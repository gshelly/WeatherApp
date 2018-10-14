//
//  WeatherModel.swift
//  Weather
//
//  Created by shelly.gupta on 9/11/18.
//  Copyright © 2018 shelly.gupta. All rights reserved.
//

import Foundation

// DataModel
struct WeatherDataModel {
    let cityName: String!
    let country: String?
    let humidity: Double?
    let pressure: Double?
    private(set) var windSpeed: Double?
    private(set) var windDirection: Double?
    private(set) var rainFallInLast3Hours: Double?
    let clouds: Double?
    let temp: Double?
    private(set) var weatherDescription: String?
    private(set) var weatherConditionMain: String?
    private(set) var weatherIcon: String?
    let stringDate: String?

    // Optional Initializer
    init?(weatherData: [String: AnyObject]) {
        guard let cityName =  weatherData["name"] as? String, let  mainData = weatherData["main"] as? [String: AnyObject], let sysData = weatherData["sys"] as? [String: AnyObject] else { return nil }
        let weatherArray = weatherData["weather"] as? [[String: AnyObject]]
        self.temp = mainData["temp"] as? Double
        self.cityName = cityName
        self.country = sysData["country"] as? String
        self.humidity = mainData["humidity"] as? Double
        self.pressure = mainData["pressure"] as? Double
        if let windData = weatherData["rain"] as? [String: AnyObject] {
            self.windSpeed = windData["speed"] as? Double
            self.windDirection = windData["deg"] as? Double
        }
        self.clouds = weatherData["clouds"]!["all"] as? Double
        if let rainData = weatherData["rain"] as? [String: AnyObject] {
            self.rainFallInLast3Hours =  rainData["3h"] as? Double
        }
        self.stringDate = weatherData["dt_txt"] as? String
        if let weatherObject = weatherArray?.first {
            self.weatherDescription = weatherObject["description"] as? String
            self.weatherConditionMain = weatherObject["main"] as? String
            self.weatherIcon = weatherObject["icon"] as? String
        }
    }

}
