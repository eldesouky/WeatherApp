//
//  ForecastViewController.swift
//  WeatherSTRV
//
//  Created by Mahmoud Eldesouky on 6/14/17.
//  Copyright © 2017 Mahmoud Eldesouky. All rights reserved.
//

import UIKit

class ForecastViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var forecastTableAdapter: ForecastTableAdapter!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        forecastTableAdapter = ForecastTableAdapter(tableView: self.tableView, delegate: self)
      
        self.title = "Forecast"
        self.navigationController?.navigationBar.isTranslucent = false
        self.tabBarController?.tabBar.isTranslucent = false
        
        ServicesManager.shared.requstForecastData { (forcastList) in
            
            print("forcast: " +  (forcastList.first?.mainDescription)!  + "<,,,,>")
            
            forecastTableAdapter.reloadTableWith(forecastList: forcastList)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(ForecastViewController.forecastDidUpdate(notification:)), name: Notification.Name(NotificationIdentifiers.forecastDidUpdate.rawValue), object: nil)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(NotificationIdentifiers.forecastDidUpdate.rawValue), object: nil)
    }
    
    func forecastDidUpdate(notification: Notification){
        
        if let forecastList = notification.object as? [WeatherModel] {
            print("forcast: " +  (forecastList.first?.mainDescription)!  + "<,,,,>")
            
            forecastTableAdapter.reloadTableWith(forecastList: forecastList)
        }
    }


}
