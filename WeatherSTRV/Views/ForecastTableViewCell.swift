//
//  ForecastTableViewCell.swift
//  WeatherSTRV
//
//  Created by Mahmoud Eldesouky on 6/16/17.
//  Copyright © 2017 Mahmoud Eldesouky. All rights reserved.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {

    @IBOutlet weak var forecastIcon: UIImageView!
    @IBOutlet weak var forecastDate: UILabel!
    @IBOutlet weak var forecastDescription: UILabel!
    @IBOutlet weak var forecastTemperature: UILabel!
    
    
    var cellOwner: WeatherModel?{
        didSet{
            if let forecast = cellOwner {
                
                if let description = forecast.mainDescription {
                    self.forecastDescription.text = description

                }
                
                if let temperature = forecast.tempratureC {
                    self.forecastTemperature.text = "\(temperature)°"
                }
                
                if let day = forecast.weekDay {
                    self.forecastDate.text = day
                }
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
