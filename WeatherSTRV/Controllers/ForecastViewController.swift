//
//  ForecastViewController.swift
//  WeatherSTRV
//
//  Created by Mahmoud Eldesouky on 6/14/17.
//  Copyright © 2017 Mahmoud Eldesouky. All rights reserved.
//

import UIKit

class ForecastViewController: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Adapter
    var forecastTableAdapter: ForecastTableAdapter!
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        forecastTableAdapter = ForecastTableAdapter(tableView: self.tableView, delegate: self)
      
        self.title = "Forecast"
        self.navigationController?.navigationBar.isTranslucent = false
        self.tabBarController?.tabBar.isTranslucent = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addServiceObserver()
        ServicesManager.shared.requstForecastData { (forcastList) in
            
            forecastTableAdapter.reloadTableWith(forecastList: forcastList)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        removeServiceObserver()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Notification Center
    
    func addServiceObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(ForecastViewController.forecastDidUpdate(notification:)), name: Notification.Name(NotificationIdentifiers.forecastDidUpdate.rawValue), object: nil)
        
    }
    
    func removeServiceObserver(){
        NotificationCenter.default.removeObserver(self, name: Notification.Name(NotificationIdentifiers.forecastDidUpdate.rawValue), object: nil)
        
    }

    
    func forecastDidUpdate(notification: Notification){
        
        if let forecastList = notification.object as? [WeatherModel] {
            print("forcast: " +  (forecastList.first?.mainDescription)!  + "<,,,,>")
            
            forecastTableAdapter.reloadTableWith(forecastList: forecastList)
        }
    }


}
