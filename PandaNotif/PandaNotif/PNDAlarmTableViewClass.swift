//
//  PNDAlarmTableViewClass.swift
//  PandaNotif
//
//  Created by ShinichiSakaguchi on 2015/01/24.
//  Copyright (c) 2015年 Shinichi.Sakaguchi. All rights reserved.
//

import UIKit

class PNDAlarmTableViewClass: NSObject {
    func soundStatus(sound:String) -> Int {
        switch sound {
            case UILocalNotificationDefaultSoundName:
                                    return Int(0)
            case "Alarm.m4r":       return 1
            case "Ascending.m4r":   return 2
            case "Bark.m4r":        return 3
            case "Bell Tower.m4r":  return 4
            case "Blues.m4r":       return 5
            case "Boing.m4r":       return 6
            case "Crickets.m4r":    return 7
            case "Digital.m4r":     return 8
            case "Doorbell.m4r":    return 9
            case "Duck.m4r":        return 10
            case "Harp.m4r":        return 11
            case "Motorcycle.m4r":  return 12
            case "Old Car Horn.m4r":return 13
            case "Old Phone.m4r":   return 14
            case "Piano Riff.m4r":  return 15
            case "Pinball.m4r":     return 16
            case "Robot.m4r":       return 17
            case "Sci-Fi.m4r":      return 18
            case "Sonar.m4r":       return 19
            case "Strum.m4r":       return 20
            case "Timba.m4r":       return 21
            case "Time Passing.m4r":return 22
            case "Trill.m4r":       return 23
            case "Xylophone.m4r":   return 24
            case "nil":             return 25
            default:
                break
            }
            return 0
        }
    
    func soundName(sound:String) -> String {
        switch sound {
            case UILocalNotificationDefaultSoundName:
                                    return "レーダー（デフォルト）"
            case "Alarm.m4r":       return "アラーム"
            case "Ascending.m4r":   return "ステップ"
            case "Bark.m4r":        return "犬の吠え声"
            case "Bell Tower.m4r":  return "教会の鐘"
            case "Blues.m4r":       return "ブルース"
            case "Boing.m4r":       return "バネ"
            case "Crickets.m4r":    return "こおろぎの鳴き声"
            case "Digital.m4r":     return "デジタル"
            case "Doorbell.m4r":    return "玄関チャイム"
            case "Duck.m4r":        return "アヒル"
            case "Harp.m4r":        return "ハープ"
            case "Motorcycle.m4r":  return "オートバイ"
            case "Old Car Horn.m4r":return "クラクション"
            case "Old Phone.m4r":   return "黒電話"
            case "Piano Riff.m4r":  return "ピアノリフ"
            case "Pinball.m4r":     return "ピンボール"
            case "Robot.m4r":       return "ロボット"
            case "Sci-Fi.m4r":      return "SF"
            case "Sonar.m4r":       return "ソナー"
            case "Strum.m4r":       return "ストラム"
            case "Timba.m4r":       return "ティンバ"
            case "Time Passing.m4r":return "タイムパス"
            case "Trill.m4r":       return "トリル"
            case "Xylophone.m4r":   return "シフォン"
            case "nil":             return "なし"
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
