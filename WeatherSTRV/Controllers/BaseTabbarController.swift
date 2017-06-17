//
//  BaseTabbarController.swift
//  WeatherSTRV
//
//  Created by Mahmoud Eldesouky on 6/16/17.
//  Copyright © 2017 Mahmoud Eldesouky. All rights reserved.
//

import UIKit

class BaseTabbarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tabBar.unselectedItemTintColor = UIColor(red: 1/255, green: 51/255, blue: 51/255, alpha: 1.0)
        self.tabBarItem.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Edmondsans-Bold", size: 10)!, NSForegroundColorAttributeName:UIColor.red], for: UIControlState.normal)
        self.tabBarItem.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Edmondsans-Bold", size: 10)!, NSForegroundColorAttributeName:UIColor.black], for: UIControlState.selected)
        
       // self.tabBar.tintColor = .mainColor()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
