//
//  SingleDayViewController.swift
//  WeatherSTRV
//
//  Created by Mahmoud Eldesouky on 6/14/17.
//  Copyright © 2017 Mahmoud Eldesouky. All rights reserved.
//

import UIKit

class SingleDayViewController: UIViewController {

    //MARK:- IBOutlets
    //MARK: Header View
    @IBOutlet weak var todayWeatherIcon: UIImageView!
    @IBOutlet weak var todayWeatherLocationIcon: UIImageView!
    
    @IBOutlet weak var todayWeatherLocationLabel: UILabel!
    
    @IBOutlet weak var todayWeatherTemperatureLabel: UILabel!
    
    @IBOutlet weak var todayWeatherDescriptionLabel: UILabel!
    
    //MARK: Properties View
    @IBOutlet weak var crPropertyView: UIView!
    @IBOutlet weak var rainPropertyView: UIView!
    @IBOutlet weak var pressurePropertyView: UIView!
    @IBOutlet weak var windPropertyView: UIView!
    @IBOutlet weak var compassPropertyView: UIView!
    
    @IBOutlet weak var crPropertyLabel: UILabel!
    @IBOutlet weak var rainPropertyLabel: UILabel!
    @IBOutlet weak var compassPropertyLabel: UILabel!
    @IBOutlet weak var windPropertyLabel: UILabel!
    @IBOutlet weak var pressurePropertyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        self.title = "Today"
        self.navigationController?.navigationBar.isTranslucent = false
        self.tabBarController?.tabBar.isTranslucent = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(SingleDayViewController.weatherDidUpdate(notification:)), name: Notification.Name(NotificationIdentifiers.weatherDidUpdate.rawValue), object: nil)
        

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(NotificationIdentifiers.weatherDidUpdate.rawValue), object: nil)
    }
    
    func weatherDidUpdate(notification: Notification){

        if let weather = notification.object as? WeatherModel {
            
            setupDataFor(weather: weather)
            
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupDataFor(weather: WeatherModel){
     
        DispatchQueue.main.async { [unowned self] in
                        
            if let city = weather.city {
                var location = city
                if let country = weather.country {
                    location = location + ", " + country
                }
                self.todayWeatherLocationLabel.text = location
            }
            
            if let temp = weather.tempratureC {
                self.todayWeatherTemperatureLabel.text = "\(temp)°C"
            }

            if let description = weather.mainDescription {
                self.todayWeatherDescriptionLabel.text = String(describing: description)
            }

            if let pressure = weather.pressure {
                self.pressurePropertyLabel.text = "\(pressure) hPa"
            }
            
            if let wind = weather.speed {
                self.windPropertyLabel.text = "\(wind) km/h"
            }
            
            if let cloud = weather.cloud {
                self.crPropertyLabel.text = "\(Int(cloud))%"
            }
            
            if let rain = weather.rain {
                self.rainPropertyLabel.text = "\(rain.format(f: ".1")) mm"
            }
            
            self.compassPropertyLabel.text = weather.windDirectionInGeographicalDirection()
            
        }
        

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
