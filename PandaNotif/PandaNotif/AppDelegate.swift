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

    // 起動時
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {
        // Override point for customization after application launch.
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        
        let settings = createInteractiveNotificationSettings()
        application.registerUserNotificationSettings(settings)
        
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
        let flg:Bool = self.PNDUserDafault.objectForKey("alarmTimes") != nil
        if flg {
            NSLog("UserDefalts exist")
            let alarmTimes = self.PNDUserDafault.objectForKey("alarmTimes") as [String]
            let labels = self.PNDUserDafault.objectForKey("labels") as [String]
            let repeats = self.PNDUserDafault.objectForKey("repeats") as [String]
            let sounds = self.PNDUserDafault.objectForKey("sounds") as [String]
            let snoozes = self.PNDUserDafault.objectForKey("snoozes") as [Bool]
            let enabled = self.PNDUserDafault.objectForKey("enabled") as [Bool]
            
            for var i = 0; i < enabled.count; i++ {
                let flg: Bool = enabled[i] == true
                if flg {
                    makeNotification(alarmTimes[i],repeat:repeats[i],snooze:snoozes[i],label:labels[i],sound:sounds[i])
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
        let flg:Bool = self.PNDUserDafault.objectForKey("alarmTimes") != nil
        if flg {
            NSLog("UserDefaults exist")
            let alarmTimes = self.PNDUserDafault.objectForKey("alarmTimes") as [String]
            let labels = self.PNDUserDafault.objectForKey("labels") as [String]
            let repeats = self.PNDUserDafault.objectForKey("repeats") as [String]
            let sounds = self.PNDUserDafault.objectForKey("sounds") as [String]
            let snoozes = self.PNDUserDafault.objectForKey("snoozes") as [Bool]
            let enabled = self.PNDUserDafault.objectForKey("enabled") as [Bool]
            
            for var i = 0; i < enabled.count; i++ {
                let flg: Bool = enabled[i] == true
                if flg {
                    makeNotification(alarmTimes[i],repeat:repeats[i],snooze:snoozes[i],label:labels[i],sound:sounds[i])
                }
            }
        }else{
            NSLog("UserDefaults does not exist")
        }
    }
    
    private func createInteractiveNotificationSettings() -> UIUserNotificationSettings {
        let snooze = UIMutableUserNotificationAction()
        snooze.title = "スヌーズ";
        snooze.identifier = "SNOOZE"
        snooze.activationMode = .Background
        snooze.destructive = true
        snooze.authenticationRequired = false
        
        let ok = UIMutableUserNotificationAction()
        ok.title = "OK"
        ok.identifier = "OK"
        ok.activationMode = .Background
        ok.destructive = false
        ok.authenticationRequired = false
        
        let snoozeOnCategory = UIMutableUserNotificationCategory()
        snoozeOnCategory.identifier = "NOTIFICATION_SNOOZE_ON_CATEGORY"
        snoozeOnCategory.setActions([snooze, ok], forContext:.Minimal)
        snoozeOnCategory.setActions([snooze, ok], forContext:.Default)
        
        let snoozeOffCategory = UIMutableUserNotificationCategory()
        snoozeOffCategory.identifier = "NOTIFICATION_SNOOZE_OFF_CATEGORY"
        snoozeOffCategory.setActions([ok], forContext: .Minimal)
        snoozeOffCategory.setActions([ok], forContext: .Default)
        
        let categories: NSSet? = NSSet(objects:snoozeOnCategory,snoozeOffCategory)
        let notificationSettings =  UIUserNotificationSettings(forTypes: .Alert | .Sound, categories: categories)

        return notificationSettings
    }
    
    // アプリがバックグラウンド状態で通知発火したとき
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        if let actionId = identifier{
            switch actionId {
            case "SNOOZE":
                let fireDate = notification.fireDate!
                let label = notification.alertBody!
                let calendar = NSCalendar(identifier: NSGregorianCalendar)!
                let snoozeFireDate = calendar.dateByAddingUnit(.MinuteCalendarUnit, value: +9, toDate: fireDate, options: nil)!
                var comps = (0, 0, 0, 0)
                calendar.getHour(&comps.0, minute: &comps.1, second: &comps.2, nanosecond: &comps.3, fromDate: snoozeFireDate)
                var hour = String(comps.0)
                let minute = String(comps.1)
                let flg:Bool = countElements(hour) == 1
                if flg {
                    hour = "0" + hour
                }
                let time = hour + ":" + minute as String
                makeNotification(time, repeat:"0000000", snooze:true, label:label, sound:UILocalNotificationDefaultSoundName)
            case "OK":
                NSLog("OK : %@",notification)
            default:
                NSLog("What?")
            }
        }
        completionHandler()
    }
    
    //notification内容確認
    private func makeNotification(time:String, repeat:String, snooze:Bool, label:String, sound:String) {
        let now = NSDate()
        let todayTime = stringForFireDate(time)
        
        // 現在より過去の時間を指定＆リピートなし＝通知しない
        if (todayTime.compare(now) == NSComparisonResult.OrderedAscending && repeat == "0000000"){
            NSLog("NO GO")
        }else if (todayTime.compare(now) == NSComparisonResult.OrderedAscending && repeat != "0000000"){
            NSLog("Repeat GO")
            showNotificationFire(time, repeat: repeat, snooze: snooze, label: label, sound: sound)
        }else if (todayTime.compare(now) == NSComparisonResult.OrderedDescending){
            NSLog("GO")
            showNotificationFire(time, repeat: repeat, snooze: snooze, label: label, sound: sound)
        }else{
            //現在と同じ時間は通知しない…が同じだと最初に弾かれてる感じかも
            NSLog("NO THANK YOU")
        }
    }
    
    // Notification Fire
    private func showNotificationFire(time:String, repeat:String, snooze:Bool, label:String, sound:String){
        let PNDNotification = UILocalNotification()
        PNDNotification.alertBody = label
        PNDNotification.soundName = sound
        PNDNotification.timeZone = NSTimeZone.systemTimeZone()
        
        let flg:Bool = snooze == true
        if flg {
            PNDNotification.category = "NOTIFICATION_SNOOZE_ON_CATEGORY"
        }else{
            PNDNotification.category = "NOTIFICATION_SNOOZE_OFF_CATEGORY"
        }

        let now = NSDate()
        let todayTime = stringForFireDate(time)
        let calendar = NSCalendar(identifier: NSGregorianCalendar)!
        
        // Notification Fire Today
        if (todayTime.compare(now) == NSComparisonResult.OrderedDescending){
            NSLog("Today Fire : %@", todayTime)
            PNDNotification.fireDate = todayTime
            UIApplication.sharedApplication().scheduleLocalNotification(PNDNotification)
        }
        
        // Notification Fire Weekday
        if repeat != "0000000"{
            var weekdays = [Character]()
            for i in repeat{
                weekdays.append(i)
            }
            for i in 0...6 {
                if weekdays[i] == "1"{
                    let nextWeekday = calendar.nextDateAfterDate(now, matchingUnit: .WeekdayCalendarUnit, value: i + 1, options: NSCalendarOptions.MatchNextTime)!
                    let nextWeekdayFire = calendar.dateBySettingHour(stringForHour(time), minute: stringForMinute(time), second:0, ofDate: nextWeekday, options: nil)!
                    NSLog("Weekday Fire : %@",nextWeekdayFire)
                    PNDNotification.fireDate = nextWeekdayFire
                    UIApplication.sharedApplication().scheduleLocalNotification(PNDNotification)
                }
            }
        }
    }

    private func stringForFireDate(time:String) -> NSDate{
        let startIndex = advance(time.startIndex, 0)
        let endIndex = advance(time.startIndex, 2)
        let hour = time.substringFromIndex(startIndex).substringToIndex(endIndex).toInt()!
        
        let startIndex2 = advance(time.startIndex, 3)
        let endIndex2 = advance(time.startIndex, 2)
        let minute = time.substringFromIndex(startIndex2).substringToIndex(endIndex2).toInt()!
        
        let calendar = NSCalendar(identifier: NSGregorianCalendar)!
        
        return calendar.dateBySettingHour(hour, minute: minute, second: 0, ofDate:NSDate(), options: nil)!
    }
    
    private func stringForHour(hour:String) -> Int{
        let startIndex = advance(hour.startIndex, 0)
        let endIndex = advance(hour.startIndex, 2)
        
        return hour.substringFromIndex(startIndex).substringToIndex(endIndex).toInt()!
    }
    
    private func stringForMinute(minute:String) -> Int{
        let startIndex = advance(minute.startIndex, 3)
        let endIndex = advance(minute.startIndex, 2)
        
        return minute.substringFromIndex(startIndex).substringToIndex(endIndex).toInt()!
    }
}

