//
//  SingleDayViewController.swift
//  WeatherSTRV
//
//  Created by Mahmoud Eldesouky on 6/14/17.
//  Copyright © 2017 Mahmoud Eldesouky. All rights reserved.
//

import UIKit


class SingleDayViewController: BaseViewController, ServicesManagerSubscriberDelegate, ServicesManagerWeatherDelegate{

    //MARK:- IBOutlets
    //MARK: Header View
    @IBOutlet weak var todayWeatherIcon: UIImageView!
    @IBOutlet weak var todayWeatherLocationIcon: UIImageView!
    @IBOutlet weak var todayWeatherLocationLabel: UILabel!
    @IBOutlet weak var todayWeatherTemperatureLabel: UILabel!
    @IBOutlet weak var todayWeatherDescriptionLabel: UILabel!
    @IBOutlet weak var currentLocationView: UIView!
    @IBOutlet weak var currentLocationView_heightConstraint: NSLayoutConstraint!
    
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
    
    //MARK: Share View
    @IBOutlet weak var shareButton: UIButton!
    
    //MARK:- Variables
    var subscribedServices = [
        (NotificationIdentifiers.weatherDidUpdate, #selector(SingleDayViewController.weatherDidUpdate(notification:)))
    ]
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Today"
                
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Observe(services: subscribedServices)
        requestWeatherData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        unObserve(services: subscribedServices)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Data
    func requestWeatherData(){
        ServicesManager.shared.requstWeatherData{ (weather) in
            self.setupDataFor(weather: weather)
        }
    }
    
    //MARK:- ServicesManagerSubscriberDelegate
    func Observe(services: [(NotificationIdentifiers, Selector)]) {
        self.addObserversFor(services: services)
    }
    
    func unObserve(services: [(NotificationIdentifiers, Selector)]){
        self.removeObserversFor(services: subscribedServices)
    }
    
    //MARK:- ServicesManagerWeatherDelegate
    func weatherDidUpdate(notification: Notification){
        if let weather = notification.object as? WeatherModel {
            setupDataFor(weather: weather)
        }
    }
    
    //MARK:- Actions
    @IBAction func shareButtonIsClicked(sender:UIButton){
        DispatchQueue.main.async { [weak self] in
            self?.shareButton.loadingIndicator(show: true)
        }
        showSharingActivity()
    }
    
    func setupDataFor(weather: WeatherModel){
        DispatchQueue.main.async { [weak self] in
            
            guard let weakSelf = self else {
                return
            }
            
            if let city = weather.city, city != "" {
                var location = city
                if let country = weather.country {
                    location = location + ", " + country
                }
                weakSelf.todayWeatherLocationLabel.text = location
                weakSelf.currentLocationView_heightConstraint.constant = 20
                weakSelf.todayWeatherLocationIcon.isHidden = false
            }
            else {
                weakSelf.currentLocationView_heightConstraint.constant = 0
                weakSelf.todayWeatherLocationIcon.isHidden = true
            }
            
            if let temp = weather.tempratureC {
                weakSelf.todayWeatherTemperatureLabel.text = "\(temp)°C"
            }
            
            if let description = weather.mainDescription {
                weakSelf.todayWeatherDescriptionLabel.text = String(describing: description)
            }
            
            if let pressure = weather.pressure {
                weakSelf.pressurePropertyLabel.text = "\(pressure) hPa"
            }
            
            if let wind = weather.speed {
                weakSelf.windPropertyLabel.text = "\(wind) km/h"
            }
            
            if let cloud = weather.cloud {
                weakSelf.crPropertyLabel.text = "\(Int(cloud))%"
            }
            
            if let rain = weather.rain {
                weakSelf.rainPropertyLabel.text = "\(rain.format(f: ".1")) mm"
            }
            
            weakSelf.compassPropertyLabel.text = weather.getWindDirectionInGeographicalDirection()
            weakSelf.todayWeatherIcon.image = weather.iconImage
        }
    }
    
    //MARK:- Share
    func showSharingActivity(){

        let activityViewController = UIActivityViewController(activityItems: [self.getSharablePhoto()], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        activityViewController.excludedActivityTypes = [.addToReadingList, .assignToContact]
        
        // present the view controller
        DispatchQueue.main.async { [weak self] in
            self?.shareButton.loadingIndicator(show: false)
            self?.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    func getSharablePhoto()->UIImage{
        self.shareButton.isHidden = true //Remove share button from screenshot
        let renderer = UIGraphicsImageRenderer(size: self.view.bounds.size)

        let image = renderer.image { ctx in
            self.view.drawHierarchy(in: self.view.bounds, afterScreenUpdates: true)
        }
        self.shareButton.isHidden = false
        return image
    }
    
    //MARK: UIActivityItemSource
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivityType) -> Any?{
        return [getSharablePhoto()]
    }
}
