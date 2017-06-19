//
//  ForecastViewController.swift
//  WeatherSTRV
//
//  Created by Mahmoud Eldesouky on 6/14/17.
//  Copyright © 2017 Mahmoud Eldesouky. All rights reserved.
//

import UIKit

class ForecastViewController: BaseViewController, ServicesManagerSubscriberDelegate, ServicesManagerForecastDelegate {
    
    //MARK:- IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Adapter
    var forecastTableAdapter: ForecastTableAdapter!
    
    //MARK:-Variables
    var subscribedServices = [
        (NotificationIdentifiers.forecastDidUpdate, #selector(ForecastViewController.forecastDidUpdate(notification:))),
        (NotificationIdentifiers.forecastDidFailToUpdate, #selector(ForecastViewController.forecastDidFailToUpdate(notification:)))
    ]
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Observe(services: subscribedServices)
        requestForcastData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        unObserve(services: subscribedServices)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- View Setup
    func setupView() {
        self.title = "Forecast"
        forecastTableAdapter = ForecastTableAdapter(tableView: self.tableView, delegate: self)
    }
    
    //MARK:- Data
    func requestForcastData(){
        ServicesManager.shared.requstForecastData { (forcastList) in
            forecastTableAdapter.reloadTableWith(forecastList: forcastList)
        }
    }
    
    //MARK:- ServicesManagerSubscriberDelegate
    func Observe(services: [(NotificationIdentifiers, Selector)]){
        self.addObserversFor(services: services)
    }
    
    func unObserve(services: [(NotificationIdentifiers, Selector)]){
        self.removeObserversFor(services: services)
    }

    //MARK:- ServicesManagerForecastDelegate
    func forecastDidUpdate(notification: Notification){
        
        if let forecastList = notification.object as? [WeatherModel] {
            forecastTableAdapter.reloadTableWith(forecastList: forecastList)
        }
    }
    
    func forecastDidFailToUpdate(notification: Notification){
        forecastTableAdapter.reloadTableWith(forecastList: nil)
    }
}
