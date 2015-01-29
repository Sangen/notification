//
//  PNDAlarmTableViewManager.swift
//  PandaNotif
//
//  Created by ShinichiSakaguchi on 2015/01/28.
//  Copyright (c) 2015年 Shinichi.Sakaguchi. All rights reserved.
//

import UIKit

class PNDAlarmTableViewManager: NSObject {
    class func soundStatus(sound:String) -> Int {
        switch sound {
        case UILocalNotificationDefaultSoundName:
            return 0
        case "nil":
            return 1
        default:
            return 999
        }
    }
    
   class func soundName(sound:String) -> String {
        switch sound {
        case UILocalNotificationDefaultSoundName:
            return "デフォルト"
        case "nil":
            return "なし"
        default:
            return "Unknown SoundName"
        }
    }
    
   class func repeatStatus(repeat:String) -> String {
        switch repeat {
        case "1111111":
            return "毎日"
        case "1000001":
            return "週末"
        case "0111110":
            return "平日"
        case "0000000":
            return "しない"
        default:
            break
        }
    
        var repeatStatuses = [Character]()
        repeatStatuses = Array(repeat)
        var weekDays = ""
        if repeatStatuses[1] == "1" {
            weekDays += "月 "
        }
        if repeatStatuses[2] == "1" {
            weekDays += "火 "
        }
        if repeatStatuses[3] == "1" {
            weekDays += "水 "
        }
        if repeatStatuses[4] == "1" {
            weekDays += "木 "
        }
        if repeatStatuses[5] == "1" {
            weekDays += "金 "
        }
        if repeatStatuses[6] == "1" {
            weekDays += "土 "
        }
        if repeatStatuses[0] == "1" {
            weekDays += "日"
        }
        return weekDays
    }
}
