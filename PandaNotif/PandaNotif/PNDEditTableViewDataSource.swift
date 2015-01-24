//
//  PNDEditTableViewDataSource.swift
//  PandaNotif
//
//  Created by ShinichiSakaguchi on 2015/01/24.
//  Copyright (c) 2015年 Shinichi.Sakaguchi. All rights reserved.
//

import UIKit
/*
class PNDEditTableViewDataSource: NSObject, UITableViewDataSource {
    var editIndexPath = Int()
    var alarmEntity = PNDAlarmEntity()
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 5
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        //let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        
        if self.alarmEntity.snooze {
            self.snoozeSwitch.on = true
        }else{
            self.snoozeSwitch.on = false
        }
        
        var repeats = [String]()
        for i in alarmEntity.repeat { repeats.append(String(i)) }
        
        if repeats == ["1","1","1","1","1","1","1"] {
            self.repeatLabel.text = "毎日"
        }else if repeats == ["1","0","0","0","0","0","1"] {
            self.repeatLabel.text = "週末"
        }else if repeats == ["0","1","1","1","1","1","0"] {
            self.repeatLabel.text = "平日"
        }else if repeats == ["0","0","0","0","0","0","0"] {
            self.repeatLabel.text = "しない"
        }else{
            var weekDay = String()
            if repeats[1] == "1" {
                weekDay += "月 "
            }
            if repeats[2] == "1" {
                weekDay += "火 "
            }
            if repeats[3] == "1" {
                weekDay += "水 "
            }
            if repeats[4] == "1" {
                weekDay += "木 "
            }
            if repeats[5] == "1" {
                weekDay += "金 "
            }
            if repeats[6] == "1" {
                weekDay += "土 "
            }
            if repeats[0] == "1" {
                weekDay += "日"
            }
            self.repeatLabel.text = weekDay
        }
        self.label.text = self.alarmEntity.label
        
        switch self.alarmEntity.sound {
        case UILocalNotificationDefaultSoundName:
            self.sound.text = "レーダー（デフォルト）"
        case "Alarm.m4r":
            self.sound.text = "アラーム"
        case "Ascending.m4r":
            self.sound.text = "ステップ"
        case "Bark.m4r":
            self.sound.text = "犬の吠え声"
        case "Bell Tower.m4r":
            self.sound.text = "教会の鐘"
        case "Blues.m4r":
            self.sound.text = "ブルース"
        case "Boing.m4r":
            self.sound.text = "バネ"
        case "Crickets.m4r":
            self.sound.text = "こおろぎの鳴き声"
        case "Digital.m4r":
            self.sound.text = "デジタル"
        case "Doorbell.m4r":
            self.sound.text = "玄関チャイム"
        case "Duck.m4r":
            self.sound.text = "アヒル"
        case "Harp.m4r":
            self.sound.text = "ハープ"
        case "Motorcycle.m4r":
            self.sound.text = "オートバイ"
        case "Old Car Horn.m4r":
            self.sound.text = "クラクション"
        case "Old Phone.m4r":
            self.sound.text = "黒電話"
        case "Piano Riff.m4r":
            self.sound.text = "ピアノリフ"
        case "Pinball.m4r":
            self.sound.text = "ピンボール"
        case "Robot.m4r":
            self.sound.text = "ロボット"
        case "Sci-Fi.m4r":
            self.sound.text = "SF"
        case "Sonar.m4r":
            self.sound.text = "ソナー"
        case "Strum.m4r":
            self.sound.text = "ストラム"
        case "Timba.m4r":
            self.sound.text = "ティンバ"
        case "Time Passing.m4r":
            self.sound.text = "タイムパス"
        case "Trill.m4r":
            self.sound.text = "トリル"
        case "Xylophone.m4r":
            self.sound.text = "シフォン"
        case "nil":
            self.sound.text = "なし"
        default:
            break
        }
        return nil
    }
}
*/
