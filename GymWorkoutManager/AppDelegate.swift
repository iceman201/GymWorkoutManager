//
//  AppDelegate.swift
//  GymWorkoutManager
//
//  Created by Liguo Jiao on 18/01/16.
//  Copyright © 2016 McKay. All rights reserved.
//

import UIKit
import RealmSwift
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    internal func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // this for AVOS settings
        AVOSCloud.setApplicationId("ms40eP4IP5JGJEHiKAqJqCHj-gzGzoHsz", clientKey: "EM5S0GFMiAtvhHh88opBM3FY")
        
        //Set notificaion type and register for remote notifications
        let types:UIUserNotificationType = [.alert,.badge,.sound]
        let settings = UIUserNotificationSettings(types: types, categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        MSAppCenter.start("9d9c4756-e81b-4a68-a39a-8c21fa93b372", withServices:[
            MSAnalytics.self,
            MSCrashes.self
            ])
        MSAppCenter.start("9d9c4756-e81b-4a68-a39a-8c21fa93b372", withServices:[ MSAnalytics.self, MSCrashes.self ])

        CommonUtils.scheduleLocalNotification()        
        print("--------- Realm path---------")
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "")
        
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = GWMColorYellow
        
        UINavigationBar.appearance().tintColor = GWMColorPurple
        UINavigationBar.appearance().backgroundColor = GWMColorYellow
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : GWMColorPurple]
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let currentInstallation = AVInstallation.current()
        currentInstallation.setDeviceTokenFrom(deviceToken)
        currentInstallation.saveInBackground()
    }
    


}

