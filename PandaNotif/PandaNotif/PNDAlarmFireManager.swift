//
//  PNDAlarmFireManager.swift
//  PandaNotif
//
//  Created by ShinichiSakaguchi on 2015/01/28.
//  Copyright (c) 2015年 Shinichi.Sakaguchi. All rights reserved.
//

import UIKit

class PNDAlarmFireManager: NSObject {
    let calculate = PNDAlarmCalculateManager()
    
    func createInteractiveNotificationSettings() -> UIUserNotificationSettings {
        let snooze = UIMutableUserNotificationAction()
        snooze.title = "スヌーズ"
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
    
    func makeNotification(time:String, repeat:String, snooze:Bool, label:String, sound:String) {
        let now = NSDate()
        let todayTime = calculate.convertTimeStringToFireDate(time)
        
        if repeat != "0000000" {
            NSLog("Repeat GO")
            showNotificationFire(time, repeat: repeat, snooze: snooze, label: label, sound: sound)
        } else if todayTime.compare(now) == NSComparisonResult.OrderedDescending {
            NSLog("Today GO")
            showNotificationFire(time, repeat: repeat, snooze: snooze, label: label, sound: sound)
        }
    }
    
    func showNotificationFire(time:String, repeat:String, snooze:Bool, label:String, sound:String) {
        let PNDNotification = UILocalNotification()
        PNDNotification.alertBody = label
        
        // LocalNotification.soundNameはデフォルト値nilのためサウンドなしは設定不要
        if sound == UILocalNotificationDefaultSoundName {
            PNDNotification.soundName = UILocalNotificationDefaultSoundName
        }
        PNDNotification.timeZone = NSTimeZone.systemTimeZone()
        
        if snooze {
            PNDNotification.category = "NOTIFICATION_SNOOZE_ON_CATEGORY"
        } else {
            PNDNotification.category = "NOTIFICATION_SNOOZE_OFF_CATEGORY"
        }
        let todayTime = calculate.convertTimeStringToFireDate(time)
        let calendar = NSCalendar(identifier: NSGregorianCalendar)!
        
        if todayTime.compare(NSDate()) == NSComparisonResult.OrderedDescending {
            NSLog("Today Fire : %@", todayTime)
            PNDNotification.fireDate = todayTime
            UIApplication.sharedApplication().scheduleLocalNotification(PNDNotification)
        }
        
        let weekdaysNotifFlags = Array(repeat)
        for (i, notifFlag) in enumerate(weekdaysNotifFlags) {
            if notifFlag == "1" {
                let nextWeekday = calendar.nextDateAfterDate(NSDate(), matchingUnit: .WeekdayCalendarUnit, value: i + 1, options: NSCalendarOptions.MatchNextTime)!
                let nextWeekdayFire = calendar.dateBySettingHour(calculate.convertTimeStringToHour(time), minute: calculate.convertTimeStringToMinute(time), second:0, ofDate: nextWeekday, options: nil)!
                NSLog("Weekday Fire : %@",nextWeekdayFire)
                PNDNotification.fireDate = nextWeekdayFire
                UIApplication.sharedApplication().scheduleLocalNotification(PNDNotification)
            }
        }
    }
}
