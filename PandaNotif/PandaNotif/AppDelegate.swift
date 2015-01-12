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
        
        myUserDafault.setObject("0000000", forKey: "NewRepeat")
        myUserDafault.setObject("アラーム", forKey: "NewLabel")
        myUserDafault.setObject(UILocalNotificationDefaultSoundName, forKey: "NewSound")
        myUserDafault.setObject(true, forKey: "NewSnooze")
        
        myUserDafault.setObject(["17:30","20:45","21:00"], forKey: "alarmTimes")
        myUserDafault.setObject(["アラーム","あいうえお","ハッフルパフ"], forKey: "descriptions")
        myUserDafault.setObject(["0000000","1111111","1010101"], forKey: "repeats")
        myUserDafault.setObject([UILocalNotificationDefaultSoundName,"nil","sample"], forKey: "sounds")
        myUserDafault.setObject([1,1,0], forKey: "snoozes")
        myUserDafault.setObject([1,1,1], forKey: "enabled")
        myUserDafault.synchronize()
        
        return true
    }
    
    // アプリが非Activeになる直前
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        UIApplication.sharedApplication().cancelAllLocalNotifications()

        var alarm : AnyObject! = myUserDafault.objectForKey("alarmTimes")
        var description : AnyObject! = myUserDafault.objectForKey("descriptions")
        var repeat : AnyObject! = myUserDafault.objectForKey("repeats")
        var sound : AnyObject! = myUserDafault.objectForKey("sounds")
        var snooze : AnyObject! = myUserDafault.objectForKey("snoozes")
        var enable : AnyObject! = myUserDafault.objectForKey("enabled")
        
        var alarmTimes:NSArray = alarm as NSArray
        var descriptions:NSArray = description as NSArray
        var repeats:NSArray = repeat as NSArray
        var sounds:NSArray = sound as NSArray
        var snoozes:NSArray = snooze as NSArray
        var enabled:NSArray = enable as NSArray
        
        var check:Bool = false
        var enabledIndex:[Int] = []
        
        for (var i = 0; i < enabled.count; i++) {
            if enabled[i] as NSObject == 1{
                //println("有効な通知があったからcheckをtrueにしてindex番号を記録するよ")
                check = true
                enabledIndex.append(i)
                //println(enabledIndex)
            }
        }
        
        if check == true{
            for(var i = 0; i < enabledIndex.count; i++){
                println(alarmTimes[enabledIndex[i]])
                println(descriptions[enabledIndex[i]])
                println(repeats[enabledIndex[i]])
                println(sounds[enabledIndex[i]])
                println(snoozes[enabledIndex[i]])
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
        // 通知登録
        var alarm : AnyObject! = myUserDafault.objectForKey("alarmTimes")
        var description : AnyObject! = myUserDafault.objectForKey("descriptions")
        var repeat : AnyObject! = myUserDafault.objectForKey("repeats")
        var sound : AnyObject! = myUserDafault.objectForKey("sounds")
        var snooze : AnyObject! = myUserDafault.objectForKey("snoozes")
        var enable : AnyObject! = myUserDafault.objectForKey("enabled")
        
        var alarmTimes:NSArray = alarm as NSArray
    }

    private func makeNotification(time:NSString, repeat:String, snooze:String, label:String, sound:String) {
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        let dateFromString = dateFormatter.dateFromString(time)
        let now = NSDate()
        
        // 現在より過去の時刻を指定した場合は通知しない
        if (dateFromString!.compare(now) == NSComparisonResult.OrderedAscending || repeat == "no repeat"){
            return
        }
        
        showNotificationFire(dateFromString!, repeat: repeat, snooze: snooze, label: label, sound: sound)
    }
    
    //notification 全部発火
    private func showNotificationFire(time:NSDate, repeat:String, snooze:String, label:String, sound:String){
        // Notificationの生成
        let myNotification: UILocalNotification = UILocalNotification()
        myNotification.alertBody = label
        myNotification.soundName = sound
        myNotification.timeZone = NSTimeZone.systemTimeZone()
        myNotification.fireDate = time
        
        //repeat時は繰り返し（繰り返し期間は暫定1週間）
        
        UIApplication.sharedApplication().scheduleLocalNotification(myNotification)
    }



}

