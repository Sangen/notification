//
//  AppDelegate.swift
//  test2
//
//  Created by 坂口真一 on 2014/12/01.
//  Copyright (c) 2014年 坂口真一. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let PNDUserDafault = NSUserDefaults()
    let fire = PNDAlarmFireClass()
    let calculate = PNDAlarmCalculateClass()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {
        // Override point for customization after application launch.
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        application.registerUserNotificationSettings(fire.createInteractiveNotificationSettings())
        
        if let options = launchOptions {
            let notification = launchOptions.objectForKey(UIApplicationLaunchOptionsLocalNotificationKey) as? UILocalNotification
            if let notif = notification {
                UIApplication.sharedApplication().cancelLocalNotification(notification!)
            }
        }
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        NSNotificationCenter.defaultCenter().postNotificationName("applicationDidEnterBackground", object: nil)
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        let alarmEntities = PNDUserDefaults.alarmEntities()
        if !alarmEntities.isEmpty {
            NSLog("UserDefalts exist value. Alarms enabled check start")
            for entity in alarmEntities {
                if entity.enabled {
                    fire.makeNotification(entity.alarmTime,repeat:entity.repeat,snooze:entity.snooze,label:entity.label,sound:entity.sound)
                }
            }
        }
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        UIApplication.sharedApplication().cancelAllLocalNotifications()
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        UIApplication.sharedApplication().cancelAllLocalNotifications()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        let alarmEntities = PNDUserDefaults.alarmEntities()
        if !alarmEntities.isEmpty {
            NSLog("UserDefalts exist value. Alarms enabled check start")
            for entity in alarmEntities {
                if entity.enabled {
                    fire.makeNotification(entity.alarmTime,repeat:entity.repeat,snooze:entity.snooze,label:entity.label,sound:entity.sound)
                }
            }
        }
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        if let actionId = identifier {
            switch actionId {
            case "SNOOZE":
                NSLog("notification.fireDate : %@", notification.fireDate!)
                fire.makeNotification(calculate.snoozeTime(notification.fireDate!), repeat:"0000000", snooze:true, label:notification.alertBody!, sound:notification.soundName!)
            case "OK":
                NSLog("OK : %@",notification)
            default:
                NSLog("What?")
            }
        }
        completionHandler()
    }
}

