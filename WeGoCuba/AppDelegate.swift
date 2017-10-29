//
//  AppDelegate.swift
//  WeGoCuba
//
//  Created by Randy Hector Bartumeu Huergo on 8/29/17.
//  Copyright © 2017 Randy Hector Bartumeu Huergo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    var License: String = "XTUMwQ0ZCa2NMZWR0U1lBbHBDS21nSHYzbHJwc2pYUzhBaFVBdzdmRFljdkhUL2EzcjMvd1NpVCt6bUxjeDNnPQoKYXBwVG9rZW49ODhiMTI5MWYtOGM2MC00OWQyLWExYmMtNmNhNTFiMzI0Njk5CmJ1bmRsZUlkZW50aWZpZXI9Y3UuYmFydHVtZXUuV2VHb0N1YmEKb25saW5lTGljZW5zZT0xCnByb2R1Y3RzPXNkay1pb3MtNC4qCndhdGVybWFyaz1jYXJ0b2RiCg=="    


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        NTMapView.registerLicense(License);
        
        // StatusBar BackgroundColor in all App
        let statWindow = UIApplication.shared.value(forKey:"statusBarWindow") as! UIView
        let statusBar = statWindow.subviews[0] as UIView
//        let statusBarColor = #colorLiteral(red: 0.07435884327, green: 0.2261409163, blue: 0.5749377012, alpha: 1).withAlphaComponent(0.85)
        statusBar.backgroundColor = #colorLiteral(red: 0.07435884327, green: 0.2261409163, blue: 0.5749377012, alpha: 1)
        
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
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

