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

    // 起動時
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Sound | UIUserNotificationType.Alert | UIUserNotificationType.Badge, categories: nil))
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        
        myUserDafault.setObject(["0","0","0","0","0","0","0"], forKey: "NewRepeat")
        myUserDafault.setObject("アラーム", forKey: "NewLabel")
        myUserDafault.setObject(UILocalNotificationDefaultSoundName, forKey: "NewSound")
        myUserDafault.setObject("1", forKey: "NewSnooze")

        myUserDafault.setObject(["04:38","04:38","04:38"], forKey: "alarmTimes")
        myUserDafault.setObject(["アラーム","PANDA","あれ"], forKey: "descriptions")
        myUserDafault.setObject(["1010101","0101010","1111111"], forKey: "repeats")
        myUserDafault.setObject([UILocalNotificationDefaultSoundName,"レーザー","nil"], forKey: "sounds")
        myUserDafault.setObject(["1","0","1"], forKey: "snoozes")
        myUserDafault.setObject(["1","1","1"], forKey: "enabled")
        
        myUserDafault.synchronize()
        
        return true
    }
    
    // アプリが非Activeになる直前
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        UIApplication.sharedApplication().cancelAllLocalNotifications()

        let alarmTimes = myUserDafault.objectForKey("alarmTimes") as [String]
        let descriptions = myUserDafault.objectForKey("descriptions") as [String]
        let repeats = myUserDafault.objectForKey("repeats") as [String]
        let sounds = myUserDafault.objectForKey("sounds") as [String]
        let snoozes = myUserDafault.objectForKey("snoozes") as [String]
        let enabled = myUserDafault.objectForKey("enabled") as [String]
        
        for (var i = 0; i < enabled.count; i++) {
            if enabled[i] == "1" {
                makeNotification(alarmTimes[i], repeat: repeats[i], snooze: snoozes[i], label: descriptions[i], sound: sounds[i])
            }
        }
    }

    // アプリが非Activeになりバックグラウンド実行になった際
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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
        
        let alarmTimes = myUserDafault.objectForKey("alarmTimes") as [String]
        let descriptions = myUserDafault.objectForKey("descriptions") as [String]
        let repeats = myUserDafault.objectForKey("repeats") as [String]
        let sounds = myUserDafault.objectForKey("sounds") as [String]
        let snoozes = myUserDafault.objectForKey("snoozes") as [String]
        let enabled = myUserDafault.objectForKey("enabled") as [String]
        
        for (var i = 0; i < enabled.count; i++) {
            if enabled[i] == "1" {
                makeNotification(alarmTimes[i], repeat: repeats[i], snooze: snoozes[i], label: descriptions[i], sound: sounds[i])
            }
        }
    }

    //notification内容確認
    private func makeNotification(time:String, repeat:String, snooze:String, label:String, sound:String) {
        let now = NSDate()
        let todayTime = stringForFireDate(time)
        
        // 現在より過去の時間を指定＆リピートなし＝通知しない
        if (todayTime.compare(now) == NSComparisonResult.OrderedAscending && repeat == "0000000"){
            println("NO GO")
        }else if (todayTime.compare(now) == NSComparisonResult.OrderedAscending && repeat != "0000000"){
            println("Repeat GO")
            showNotificationFire(time, repeat: repeat, snooze: snooze, label: label, sound: sound)
        }else if (todayTime.compare(now) == NSComparisonResult.OrderedDescending){
            println("GO")
            showNotificationFire(time, repeat: repeat, snooze: snooze, label: label, sound: sound)
        }else{
            //現在と同じ時間は通知しない…が同じだと最初に弾かれてる感じかも
            println("NO THANK YOU")
        }
    }
    
    // Notification Fire
    private func showNotificationFire(time:String, repeat:String, snooze:String, label:String, sound:String){
        let PNDNotification: UILocalNotification = UILocalNotification()
        PNDNotification.alertBody = label
        PNDNotification.soundName = sound
        PNDNotification.timeZone = NSTimeZone.systemTimeZone()
        let now = NSDate()
        let todayTime = stringForFireDate(time)
        let calendar = NSCalendar(identifier: NSGregorianCalendar)!
        
        // Notification Fire Today
        if (todayTime.compare(now) == NSComparisonResult.OrderedDescending){
            println(todayTime,"Today Fire")
            PNDNotification.fireDate = todayTime
            UIApplication.sharedApplication().scheduleLocalNotification(PNDNotification)
        }
        
        // Notification Fire Weekday
        if repeat != "0000000"{
            var weekdays = [Character]()
            for ch in repeat{
                weekdays.append(ch)
            }
            for (var i = 0 ;i < 7 ;i++) {
                if weekdays[i] == "1"{
                    let nextWeekday = calendar.nextDateAfterDate(now, matchingUnit: .WeekdayCalendarUnit, value: i + 1, options: NSCalendarOptions.MatchNextTime)!
                    let nextWeekdayFire = calendar.dateBySettingHour(stringForHour(time), minute: stringForMinute(time), second:0, ofDate: nextWeekday, options: nil)!
                    println(nextWeekdayFire,"Weekday Fire")
                    PNDNotification.fireDate = nextWeekdayFire
                    UIApplication.sharedApplication().scheduleLocalNotification(PNDNotification)
                }
            }
        }
    }

    private func stringForFireDate(time: String) -> NSDate{
        let startIndex = advance(time.startIndex, 0)
        let endIndex = advance(time.startIndex, 2)
        let hour = time.substringFromIndex(startIndex).substringToIndex(endIndex).toInt()!
        
        let startIndex2 = advance(time.startIndex, 3)
        let endIndex2 = advance(time.startIndex, 2)
        let minute = time.substringFromIndex(startIndex2).substringToIndex(endIndex2).toInt()!
        
        let calendar = NSCalendar(identifier: NSGregorianCalendar)!
        
        return calendar.dateBySettingHour(hour, minute: minute, second: 0, ofDate:NSDate(), options: nil)!
    }
    
    private func stringForHour(hour: String) -> Int{
        let startIndex = advance(hour.startIndex, 0)
        let endIndex = advance(hour.startIndex, 2)
        
        return hour.substringFromIndex(startIndex).substringToIndex(endIndex).toInt()!
    }
    
    private func stringForMinute(minute: String) -> Int{
        let startIndex = advance(minute.startIndex, 3)
        let endIndex = advance(minute.startIndex, 2)
        
        return minute.substringFromIndex(startIndex).substringToIndex(endIndex).toInt()!
    }
}

