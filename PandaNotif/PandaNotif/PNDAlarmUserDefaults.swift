//
//  PNDAlarmUserDefaults.swift
//  PandaNotif
//
//  Created by ShinichiSakaguchi on 2015/01/28.
//  Copyright (c) 2015年 Shinichi.Sakaguchi. All rights reserved.
//

import UIKit

class PNDAlarmUserDefaults: NSObject {
    class func setAlarmEntities(entities: [PNDAlarmEntity]) {
        let dataList = entities.map { e in NSKeyedArchiver.archivedDataWithRootObject(e) }
        let ud = NSUserDefaults.standardUserDefaults()
        ud.setObject(dataList, forKey: "alarmEntities")
        ud.synchronize()
    }
    
    class func alarmEntities() -> [PNDAlarmEntity] {
        if let dataList = NSUserDefaults.standardUserDefaults().arrayForKey("alarmEntities") as? [NSData] {
            return dataList.map { d in NSKeyedUnarchiver.unarchiveObjectWithData(d) as PNDAlarmEntity }
        }
        return [PNDAlarmEntity]()
    }
}