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

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {
        // Override point for customization after application launch.
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        application.registerUserNotificationSettings(fire.createInteractiveNotificationSettings())
        
        if let options = launchOptions{
            let notification = launchOptions.objectForKey(UIApplicationLaunchOptionsLocalNotificationKey) as? UILocalNotification
            if let notif = notification {
                NSLog("通知されてアプリ起動したよ")
                UIApplication.sharedApplication().cancelLocalNotification(notification!)
            }
        }
        return true
    }
    
    // アプリが非Activeになる直前
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    // アプリが非Activeになりバックグラウンド実行になった際
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        NSNotificationCenter.defaultCenter().postNotificationName("applicationDidEnterBackground", object: nil)
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        if PNDUserDafault.arrayForKey("alarmEntities") != nil{
            NSLog("UserDefalts exist value. Alarms enabled check start")
            let alarmEntities = PNDUserDefaults.alarmEntities()
            for a in 0...alarmEntities.count-1{
                if alarmEntities[a].enabled == true{
                    fire.makeNotification(alarmEntities[a].alarmTime,repeat:alarmEntities[a].repeat,snooze:alarmEntities[a].snooze,label:alarmEntities[a].label,sound:alarmEntities[a].sound)
                }
            }
        }else{
            NSLog("UserDefaults does not exist")
        }
    }

    // 2回目以降の起動時（バックグラウンドにアプリがある場合）
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        UIApplication.sharedApplication().cancelAllLocalNotifications()
    }
    
    // アプリがActiveになった際に呼び出される
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        UIApplication.sharedApplication().cancelAllLocalNotifications()
    }

    // システムからのアプリ終了の際に呼び出される
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        if PNDUserDafault.arrayForKey("alarmEntities") != nil{
            NSLog("UserDefalts exist value alarm enabled check start")
            let alarmEntities = PNDUserDefaults.alarmEntities()
            for a in 0...alarmEntities.count-1{
                if alarmEntities[a].enabled == true{
                    fire.makeNotification(alarmEntities[a].alarmTime,repeat:alarmEntities[a].repeat,snooze:alarmEntities[a].snooze,label:alarmEntities[a].label,sound:alarmEntities[a].sound)
                }
            }
        }else{
            NSLog("UserDefaults does not exist")
        }
    }
    
    // アプリがバックグラウンド状態で通知発火したとき
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        if let actionId = identifier{
            switch actionId {
            case "SNOOZE":
                let calendar = NSCalendar(identifier: NSGregorianCalendar)!
                let snoozeFireDate = calendar.dateByAddingUnit(.MinuteCalendarUnit, value: +9, toDate:notification.fireDate!, options: nil)!
                var comps = (0, 0, 0, 0)
                calendar.getHour(&comps.0, minute: &comps.1, second: &comps.2, nanosecond: &comps.3, fromDate: snoozeFireDate)
                var hour = String(comps.0)
                let minute = String(comps.1)
                if countElements(hour) == 1{
                    hour = "0" + hour
                }
                let time = hour + ":" + minute as String
                fire.makeNotification(time, repeat:"0000000", snooze:true, label:notification.alertBody!, sound:notification.soundName!)
            case "OK":
                NSLog("OK : %@",notification)
            default:
                NSLog("What?")
            }
        }
        completionHandler()
    }
}

