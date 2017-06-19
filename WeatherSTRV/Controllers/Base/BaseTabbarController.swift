//
//  BaseTabbarController.swift
//  WeatherSTRV
//
//  Created by Mahmoud Eldesouky on 6/16/17.
//  Copyright © 2017 Mahmoud Eldesouky. All rights reserved.
//

import UIKit

class BaseTabbarController: UITabBarController {
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- View Setup
    func setupView(){
        setupTabBarControllerStyle()
    }
    
    func setupTabBarControllerStyle(){
        self.tabBar.isTranslucent = false
        setupTabBarItems()
    }
    
    func setupTabBarItems(){
        setupItemImage()
        setupItemFonts()
    }
    
    func setupItemImage(){
        self.tabBar.unselectedItemTintColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
    }
    
    func setupItemFonts(){
        self.tabBarItem.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "ProximaNova-Semibold", size: 10)!], for: UIControlState.normal)
        self.tabBarItem.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "ProximaNova-Semibold", size: 10)!], for: UIControlState.selected)
    }
}
