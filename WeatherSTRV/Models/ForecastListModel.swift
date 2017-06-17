//
//  ForecastModel.swift
//  WeatherSTRV
//
//  Created by Mahmoud Eldesouky on 6/15/17.
//  Copyright © 2017 Mahmoud Eldesouky. All rights reserved.
//

import Foundation
import ObjectMapper

class ForecastListModel: BaseModel {
    
    var records:[WeatherModel]? = []

    override func mapping(map: Map) {
        records <- map["list"]
    }

    
}
