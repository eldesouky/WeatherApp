//
//  WeatherSTRVDelegates.swift
//  WeatherSTRV
//
//  Created by Mahmoud Eldesouky on 6/15/17.
//  Copyright © 2017 Mahmoud Eldesouky. All rights reserved.
//

import UIKit
import CoreLocation

protocol LocationServiceDelegate: class {
    func locationDidUpdate(location: CLLocation)
}

protocol WeatherServiceDelegate: class {
    func weatherDidUpdate(weather: WeatherModel)
    func forecastDidUpdate(forecastList: [WeatherModel])
}

protocol CustomView {
    static func instanceFromNib() -> UIView
}
