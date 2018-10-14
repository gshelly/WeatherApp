//
//  WANetworkManager.swift
//  Weather
//
//  Created by shelly.gupta on 9/12/18.
//  Copyright © 2018 shelly.gupta. All rights reserved.
//

import UIKit
typealias locationCoordinates = (lat: Double, long: Double)

class WANetworkManager {
    
    //using a URLSession to make the API call
    //Parsing json to retreive the weather data
    
    private static var NetworkSession: URLSession = {
        // Create custom manager
        let localconfiguration = URLSessionConfiguration.default
        // Set timeout 5 min
        localconfiguration.timeoutIntervalForRequest = 60*5
        return URLSession(configuration: localconfiguration)
    }()
    
    class func getCurrentWeatherBy(currentCoordinates: locationCoordinates, completionHandler:@escaping (WeatherDataModel?, Error?) -> Void) {
        
        if isFixtureDataEnabled {
            // Send DataModel created from Mock Json
            completionHandler(WANetworkManager.readWeatherJSONFixtureDataFromFile(fileName: "WeatherData"), nil)
        } else {
            
            // Making request to the server
            // with the help of current location and apikey, Url for the data is getting created.
            
            let urlString = "\(Config.BaseURL)?lat=\(currentCoordinates.lat)&lon=\(currentCoordinates.long)" +
            "&appid=\(Config.APIKey)&units=metric"
            guard let url = URL(string: urlString) else {
                return
            }
          
            NetworkSession.dataTask(with: url) {
                (data, response, error)  in
                guard error == nil  else {
                    DispatchQueue.main.async {
                        completionHandler(nil,error)
                    }
                    return
                }
                // Check for responseData
                if let responseData = data {
                    // Extracting data from json
                    // Through open weather map api will get the json data for current location weather
                    do {
                        if let jsonObject = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? [String: AnyObject] {
                            let weatherInfo = WeatherDataModel(weatherData: jsonObject)
                            // Get Main Queue
                            DispatchQueue.main.async {
                                completionHandler(weatherInfo, nil)
                            }
                        }
                    } catch let error {
                        print("Failed to load :\(error.localizedDescription)")
                        // Get Main Queue
                        DispatchQueue.main.async {
                            completionHandler(nil, error)
                        }
                    }
                }
            }.resume()
        }
    }
    
    //Fixture method will be used in cases of network issue using mock data
    private class func readWeatherJSONFixtureDataFromFile(fileName:String) ->WeatherDataModel?{
        let path = Bundle.main.path(forResource: fileName, ofType: "json")
        let content = NSData(contentsOfFile: path!)
        do {
            if let jsonObject  = try JSONSerialization.jsonObject(with: content! as Data, options: .allowFragments) as? [String: AnyObject] {
                return WeatherDataModel(weatherData: jsonObject)
            }
        }
        catch let error {
            print("Failed to load :\(error.localizedDescription)")
            return nil
        }
        return nil
    }
}
