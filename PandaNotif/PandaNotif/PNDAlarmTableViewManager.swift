//
//  PNDAlarmTableViewManager.swift
//  PandaNotif
//
//  Created by ShinichiSakaguchi on 2015/01/28.
//  Copyright (c) 2015年 Shinichi.Sakaguchi. All rights reserved.
//

import UIKit

class PNDAlarmTableViewManager: NSObject {
    func soundStatus(sound:String) -> Int {
        switch sound {
        case UILocalNotificationDefaultSoundName:
            return Int(0)
        case "nil":
            return 1
        default:
            break
        }
        return 0
    }
    
    func soundName(sound:String) -> String {
        switch sound {
        case UILocalNotificationDefaultSoundName:
            return "デフォルト"
        case "nil":
            return "なし"
        default:
            break
        }
        return "Unknown SoundName"
    }
    
    func repeatStatus(repeat:String) -> String {
        var repeatStatuses = [String]()
        for r in repeat { repeatStatuses.append(String(r)) }
        
        if repeatStatuses == ["1","1","1","1","1","1","1"] {
            return "毎日"
        }
        
        if repeatStatuses == ["1","0","0","0","0","0","1"] {
            return "週末"
        }
        
        if repeatStatuses == ["0","1","1","1","1","1","0"] {
            return "平日"
        }
        
        if repeatStatuses == ["0","0","0","0","0","0","0"] {
            return "しない"
        }
        var weekDays = String()
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
