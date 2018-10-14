//
//  WAWeatherViewControllerTestCase.swift
//  WeatherAppTests
//
//  Created by shelly.gupta on 9/12/18.
//  Copyright © 2018 Gupta, Shelly. All rights reserved.
//

import XCTest
@testable import WeatherApp

class WAWeatherViewControllerTestCase: XCTestCase {
    
    var weatherVC: WAWeatherViewController!
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        weatherVC = storyboard.instantiateViewController(withIdentifier: "WAWeatherViewController") as? WAWeatherViewController
        UIApplication.shared.keyWindow?.rootViewController = weatherVC
    }
    
    override func tearDown() {
        super.tearDown()
        weatherVC = nil
    }
    
    func testUpdateView() {
        //ACT
        weatherVC.updateView()
        
        //ASSERT
        XCTAssertTrue(weatherVC.errorLabel.isHidden)
    }
    
    func testUpdateError() {
        //ARRANGE
        let error = WACustomError.localError("Enable location")
        
        //ACT
        weatherVC.updateError(error)
        
        //ASSERT
        XCTAssertFalse(weatherVC.errorLabel.isHidden)
        XCTAssertEqual(weatherVC.errorLabel.text, error.localizedDescription)
    }
    
}
