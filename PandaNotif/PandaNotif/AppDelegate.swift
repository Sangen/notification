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
    var myUserDafault:NSUserDefaults = NSUserDefaults()

    // はじめての起動時
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Sound | UIUserNotificationType.Alert | UIUserNotificationType.Badge, categories: nil))
        
        myUserDafault.setObject(["0","0","0","0","0","0","0"], forKey: "NewRepeat")
        myUserDafault.setObject("アラーム", forKey: "NewLabel")
        myUserDafault.setObject(["レーザー",UILocalNotificationDefaultSoundName], forKey: "NewSound")
        myUserDafault.setObject(true, forKey: "NewSnooze")
        myUserDafault.synchronize()
        
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
    }

    // 2回目以降の起動時
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
    }


}

