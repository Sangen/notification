//
//  PNDAlarmCalculateClass.swift
//  PandaNotif
//
//  Created by 坂口真一 on 2015/01/22.
//  Copyright (c) 2015年 Shinichi.Sakaguchi. All rights reserved.
//

import UIKit

class PNDAlarmCalculateClass: NSObject {
    func convertTimeStringToFireDate(time:String) -> NSDate {
        let startIndex = advance(time.startIndex, 0)
        let endIndex = advance(time.startIndex, 2)
        let hour = time.substringFromIndex(startIndex).substringToIndex(endIndex).toInt()!
        
        let startIndex2 = advance(time.startIndex, 3)
        let endIndex2 = advance(time.startIndex, 2)
        let minute = time.substringFromIndex(startIndex2).substringToIndex(endIndex2).toInt()!
        
        let calendar = NSCalendar(identifier: NSGregorianCalendar)!
        
        return calendar.dateBySettingHour(hour, minute: minute, second: 0, ofDate:NSDate(), options: nil)!
    }
    
    func convertTimeStringToHour(time:String) -> Int {
        let startIndex = advance(time.startIndex, 0)
        let endIndex = advance(time.startIndex, 2)
        
        return time.substringFromIndex(startIndex).substringToIndex(endIndex).toInt()!
    }
    
    func convertTimeStringToMinute(time:String) -> Int {
        let startIndex = advance(time.startIndex, 3)
        let endIndex = advance(time.startIndex, 2)
        
        return time.substringFromIndex(startIndex).substringToIndex(endIndex).toInt()!
    }
    
    func localDate() -> NSDate {
        let date = NSDate()
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        let timeZone = NSTimeZone(name: NSTimeZone.systemTimeZone().name)
        dateFormatter.timeZone = timeZone
        
        let dStr = dateFormatter.stringFromDate(date)
        return dateFormatter.dateFromString(dStr)!
    }
    
    func snoozeTime(fireDate:NSDate) -> String {
        let calendar = NSCalendar(identifier: NSGregorianCalendar)!
        let snoozeFireDate = calendar.dateByAddingUnit(.MinuteCalendarUnit, value: +9, toDate:fireDate, options: nil)!
        NSLog("snoozeFireDate : %@", snoozeFireDate)
        var comps = (0, 0, 0, 0)
        calendar.getHour(&comps.0, minute: &comps.1, second: &comps.2, nanosecond: &comps.3, fromDate: snoozeFireDate)
        var hour = String(comps.0)
        var minute = String(comps.1)

        return makeTwoDigitTime(hour) + ":" + makeTwoDigitTime(minute)
    }
    
    func currentTime() -> String {
        let calendar = NSCalendar(identifier: NSGregorianCalendar)!
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.stringFromDate(NSDate())
    }
    
    func makeTwoDigitTime(time:String) -> String {
        if countElements(time) == 1 {
            return "0" + time
        }
        return time
    }
}
