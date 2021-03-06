//
//  AppDelegate.swift
//  WeatherSTRV
//
//  Created by Mahmoud Eldesouky on 6/14/17.
//  Copyright © 2017 Mahmoud Eldesouky. All rights reserved.
//

import UIKit
import Firebase
import SwiftMessages
import ReachabilitySwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    //MARK:- Variables
    var window: UIWindow?
    fileprivate let reachabilityURL  :String           = "www.google.com"
    var isReachable                  :Bool             = false
    var reachability                 : Reachability?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        setupReachability()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        ServicesManager.shared.startMainService()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //MARK:- Reachability
    private func setupReachability() {
        let reachability = Reachability(hostname: reachabilityURL)
        self.reachability = reachability
        
        reachability?.whenReachable = { reachability in
            ServicesManager.shared.startMainService()
            DispatchQueue.main.async {
                self.networkConnection(isWorking: true, message: "")
            }
        }
        reachability?.whenUnreachable = { reachability in
            DispatchQueue.main.async {
                self.networkConnection(isWorking: false, message: "No Internet! Connect to get latest weather updates")
                
            }
        }
        self.startNotifier()
    }
    
    private func startNotifier() {
        do {
            try reachability?.startNotifier()
        } catch {
            return
        }
    }
    
    private func stopNotifier() {
        reachability?.stopNotifier()
        reachability = nil
    }
    
    private func networkConnection(isWorking:Bool, message:String) {
        if isWorking {
            DispatchQueue.main.async {
                SwiftMessages.sharedInstance.hideAll()
            }
            return
        }
        let status = MessageView.viewFromNib(layout: .StatusLine)
        status.backgroundView.backgroundColor = UIColor.red
        status.bodyLabel?.textColor = UIColor.white
        status.configureContent(body: message)
        var statusConfig = SwiftMessages.defaultConfig
        statusConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        statusConfig.duration = .forever
        DispatchQueue.main.async {
            SwiftMessages.show(config: statusConfig, view: status)
        }
    }
}

