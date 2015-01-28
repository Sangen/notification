//
//  PNDAlarmEntity.swift
//  PandaNotif
//
//  Created by 坂口真一 on 2015/01/22.
//  Copyright (c) 2015年 Shinichi.Sakaguchi. All rights reserved.
//

import UIKit
import Foundation

class PNDAlarmEntity: NSObject, NSCoding {
    var alarmTime = ""
    var label     = ""
    var repeat    = ""
    var sound     = ""
    var snooze    = false
    var enabled   = false
    
    override init() {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        self.alarmTime = aDecoder.decodeObjectForKey("alarmTime") as String
        self.label     = aDecoder.decodeObjectForKey("label") as String
        self.repeat    = aDecoder.decodeObjectForKey("repeat") as String
        self.sound     = aDecoder.decodeObjectForKey("sound") as String
        self.snooze    = aDecoder.decodeObjectForKey("snooze") as Bool
        self.enabled   = aDecoder.decodeObjectForKey("enabled") as Bool
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.alarmTime, forKey: "alarmTime")
        aCoder.encodeObject(self.label, forKey: "label")
        aCoder.encodeObject(self.repeat, forKey: "repeat")
        aCoder.encodeObject(self.sound, forKey: "sound")
        aCoder.encodeObject(self.snooze, forKey: "snooze")
        aCoder.encodeObject(self.enabled, forKey: "enabled")
    }
}