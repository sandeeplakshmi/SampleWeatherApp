//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Ashritha S on 9/30/18.
//  Copyright © 2018 sample. All rights reserved.
//

import UIKit

class WeatherModel: NSObject {

    var _locationName: String!
    var _temparature: Double!
    var _weatherType: String!
    var _date: String!
    
    var locationName: String {
        if _locationName == nil {
            _locationName = ""
        }
        return _locationName
    }
    
    var date: String {
        if _date == nil {
            _date = ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .full
        let currentDate = dateFormatter.string(from: Date())
        self._date = currentDate
        return _date
    }
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    
    var temparature: Double {
        if _temparature == nil {
            _temparature = 0.0
        }
        return _temparature
    }
}
