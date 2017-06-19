//
//  BaseViewController.swift
//  WeatherSTRV
//
//  Created by Mahmoud Eldesouky on 6/18/17.
//  Copyright © 2017 Mahmoud Eldesouky. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBaseView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- View Setup
    func setupBaseView(){
        self.setupNavigationControllerStyle()
    }
    
    func setupNavigationControllerStyle(){
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0), NSFontAttributeName: UIFont(name: "ProximaNova-Semibold", size: 18)!]

    }
    
    //MARK:- Observers
    func addObserversFor(services: [(NotificationIdentifiers, Selector)]){
        for service in services {
            NotificationCenter.default.addObserver(self, selector: service.1, name: Notification.Name(service.0.rawValue), object: nil)
        }
    }
    
    func removeObserversFor(services: [(NotificationIdentifiers, Selector)]){
        for service in services {
            NotificationCenter.default.removeObserver(self, name: Notification.Name(service.0.rawValue), object: nil)
        }
    }
}
