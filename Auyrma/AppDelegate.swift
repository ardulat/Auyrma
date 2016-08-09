//
//  AppDelegate.swift
//  Auyrma
//
//  Created by MacBook on 07.07.16.
//  Copyright © 2016 Yerzhan Mademikhanov. All rights reserved.
//

import UIKit
import Firebase
import EventKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let APP_ID = "74DC26B1-7B18-3248-FFF0-E1B9F3E3D200"
    let SECRET_KEY = "DDFDBC84-3E8C-8DB4-FFC3-08F171748F00"
    let VERSION_NUM = "v1"
    var eventStore: EKEventStore?
    
    var backendless = Backendless.sharedInstance()

    override init() {
        FIRApp.configure()
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        IQKeyboardManager.sharedManager().enable = true
        
        // Override point for customization after application launch.
        backendless.initApp(APP_ID, secret:SECRET_KEY, version:VERSION_NUM)
//        [GMSServices provideAPIKey:@"YOUR_API_KEY"];
        GMSServices.provideAPIKey("AIzaSyAjyaHJKiCjhYOxDrkVu6I8HuBWJSHddd0")
        
//        let barColor = UIColor(red: 49/255, green: 75/255, blue: 108/255, alpha: 1.0)
        let pressedTintColor = UIColor.whiteColor()
        
        //UITabBar.appearance().barTintColor = barColor
        UITabBar.appearance().tintColor = pressedTintColor
        
        // MARK:  Actions
        
        let firstAction: UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        firstAction.identifier = "FIRST_ACTION"
        firstAction.title = "Ой, нету"
        
        firstAction.activationMode = UIUserNotificationActivationMode.Background
        firstAction.destructive = true
        firstAction.authenticationRequired = false
        
        let secondAction: UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        secondAction.identifier = "SECOND_ACTION"
        secondAction.title = "Рахмет"
        
        firstAction.activationMode = UIUserNotificationActivationMode.Background
        firstAction.destructive = true
        firstAction.authenticationRequired = false
        
        // Category
        
        let firstCategory: UIMutableUserNotificationCategory = UIMutableUserNotificationCategory()
        
        firstCategory.identifier = "FIRST_CATEGORY"
        let defaultActions: NSArray = [firstAction, secondAction]
        let minimalActions: NSArray = [firstAction, secondAction]
        
        firstCategory.setActions(defaultActions as? [UIUserNotificationAction], forContext: UIUserNotificationActionContext.Default)
        firstCategory.setActions(minimalActions as? [UIUserNotificationAction], forContext: UIUserNotificationActionContext.Minimal)
        
        // NSSet of all our categories
        
//        let categories: NSSet = NSSet(objects: firstCategory)
        
        
        // MARK: Notification
        let types: UIUserNotificationType = [.Alert, .Badge, .Sound]
        let mySettings: UIUserNotificationSettings = UIUserNotificationSettings(forTypes: types, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(mySettings)
        

        
        return true
    }
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        print("\(#function)")
        
    }
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

