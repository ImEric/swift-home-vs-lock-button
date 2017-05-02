//
//  AppDelegate.swift
//  swift-home-vs-lock-button
//
//  Created by ERIC on 5/2/17.
//  Copyright © 2017 Eric Hu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    let displayStatusChanged: CFNotificationCallback = { center, observer, name, object, info in
        let str = name!.rawValue as CFString
        if (str == "com.apple.springboard.lockcomplete" as CFString) {
            let isDisplayStatusLocked = UserDefaults.standard
            isDisplayStatusLocked.set(true, forKey: "isDisplayStatusLocked")
            isDisplayStatusLocked.synchronize()
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let isDisplayStatusLocked = UserDefaults.standard
        isDisplayStatusLocked.set(false, forKey: "isDisplayStatusLocked")
        isDisplayStatusLocked.synchronize()
        
        // Darwin Notification
        let cfstr = "com.apple.springboard.lockcomplete" as CFString
        let notificationCenter = CFNotificationCenterGetDarwinNotifyCenter()
        let function = displayStatusChanged
        CFNotificationCenterAddObserver(notificationCenter,
                                        nil,
                                        function,
                                        cfstr,
                                        nil,
                                        .deliverImmediately)
        
        return true
    }
    
    func applicationWillEnterBackground(_ application: UIApplication) {
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {

    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        let isDisplayStatusLocked = UserDefaults.standard
        if let lock = isDisplayStatusLocked.value(forKey: "isDisplayStatusLocked"){
            // user locked screen
            if(lock as! Bool){
                
                // do anything you want here
                let exitStr = "Lock Button Pressed!"
                let exitStatus = UserDefaults.standard
                exitStatus.set(exitStr, forKey: "exitStatus")
                exitStatus.synchronize()
                print(exitStr)
                
            }
            else{
                
                // do anything you want here
                let exitStr = "Home Button Pressed!"
                let exitStatus = UserDefaults.standard
                exitStatus.set(exitStr, forKey: "exitStatus")
                exitStatus.synchronize()
                print(exitStr)
            }
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateExitStatus"), object: nil)
    }
    
    
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("Back to foreground.")
        
        //restore lock screen setting
        
        let isDisplayStatusLocked = UserDefaults.standard
        isDisplayStatusLocked.set(false, forKey: "isDisplayStatusLocked")
        isDisplayStatusLocked.synchronize()
        
        
    }
    
    
    func applicationDidBecomeActive(_ application: UIApplication) {

    }
    
    func applicationWillTerminate(_ application: UIApplication) {

    }
    
}
