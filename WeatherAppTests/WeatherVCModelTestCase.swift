//
//  WeatherVCModelTestCase.swift
//  WeatherAppTests
//
//  Created by Gupta, Shelly on 12/09/18.
//  Copyright © 2018 Gupta, Shelly. All rights reserved.
//

import XCTest
import CoreLocation

@testable import WeatherApp

class WeatherVCModelTestCase: XCTestCase {
    
    var weatherVCModel: WeatherVCModel!
    static var updateErrorMethodCalled = false
    static var updateViewMethodCalled = false
    override func setUp() {
        super.setUp()
        weatherVCModel = WeatherVCModel()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        weatherVCModel = nil
    }
    
    func testOnViewAppear() {
        //ARRANGE
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let testCurrentDate = dateFormatter.string(from: Date())
        
        //ACT
        weatherVCModel.onViewAppear()
        
        //ASSERT
        XCTAssertEqual(weatherVCModel.currentDay, testCurrentDate)
    }
    
    func testLocationUpdationFailedWith() {
        //ARRANGE
        let error = WACustomError.localError("Enable location")
        let testVC = MockVC()
        testVC.viewModelDelegate = testVC
        
        //ACT
        testVC.locationUpdationFailedWith(error: error)
        
        //ASSERT
        XCTAssertTrue(WeatherVCModelTestCase.updateErrorMethodCalled)
    }
}
    
class MockVC: WeatherVCModel,ViewModelDelegate {
    func updateView() {
        WeatherVCModelTestCase.updateViewMethodCalled = true
    }
    
    func updateError(_ error: Error) {
        WeatherVCModelTestCase.updateErrorMethodCalled = true
    }
    
}

