//
//  PNDAlarmFireClass.swift
//  PandaNotif
//
//  Created by 坂口真一 on 2015/01/22.
//  Copyright (c) 2015年 Shinichi.Sakaguchi. All rights reserved.
//

import UIKit

class PNDAlarmFireClass: NSObject {
    let calculate = PNDAlarmCalculateClass()
    
    func createInteractiveNotificationSettings() -> UIUserNotificationSettings {
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
    
    //notification内容確認
    func makeNotification(time:String, repeat:String, snooze:Bool, label:String, sound:String) {
        let now = NSDate()
        let todayTime = calculate.stringForFireDate(time)
        
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
    func showNotificationFire(time:String, repeat:String, snooze:Bool, label:String, sound:String){
        let PNDNotification = UILocalNotification()
        PNDNotification.alertBody = label
        PNDNotification.soundName = sound
        PNDNotification.timeZone = NSTimeZone.systemTimeZone()
        
        if snooze == true{
            PNDNotification.category = "NOTIFICATION_SNOOZE_ON_CATEGORY"
        }else{
            PNDNotification.category = "NOTIFICATION_SNOOZE_OFF_CATEGORY"
        }
        let todayTime = calculate.stringForFireDate(time)
        let calendar = NSCalendar(identifier: NSGregorianCalendar)!
        
        // Notification Fire Today
        if (todayTime.compare(NSDate()) == NSComparisonResult.OrderedDescending){
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
                    let nextWeekday = calendar.nextDateAfterDate(NSDate(), matchingUnit: .WeekdayCalendarUnit, value: i + 1, options: NSCalendarOptions.MatchNextTime)!
                    let nextWeekdayFire = calendar.dateBySettingHour(calculate.stringForHour(time), minute: calculate.stringForMinute(time), second:0, ofDate: nextWeekday, options: nil)!
                    NSLog("Weekday Fire : %@",nextWeekdayFire)
                    PNDNotification.fireDate = nextWeekdayFire
                    UIApplication.sharedApplication().scheduleLocalNotification(PNDNotification)
                }
            }
        }
    }

}
