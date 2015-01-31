//
//  PNDCalculateManagerTest.swift
//  PandaNotif
//
//  Created by ShinichiSakaguchi on 2015/01/29.
//  Copyright (c) 2015年 Shinichi.Sakaguchi. All rights reserved.
//

import UIKit
import XCTest

class PNDCalculateManagerTest: XCTestCase {
    func testConvertTimeStringToFireDate() {
        let calendar = NSCalendar(identifier: NSGregorianCalendar)!
        var data =  calendar.dateBySettingHour(12, minute: 34, second: 0, ofDate:NSDate(), options: nil)!
        XCTAssertEqual(PNDAlarmCalculateManager.convertTimeStringToFireDate("12:34"), data)
        
        data = calendar.dateBySettingHour(12, minute: 34, second: 1, ofDate:NSDate(), options: nil)!
        XCTAssertNotEqual(PNDAlarmCalculateManager.convertTimeStringToFireDate("12:34"), data)
        
        data = calendar.dateBySettingHour(12, minute: 35, second: 0, ofDate:NSDate(), options: nil)!
        XCTAssertNotEqual(PNDAlarmCalculateManager.convertTimeStringToFireDate("12:34"), data)
    }
    
    func testConvertTimeStringToHour() {
        XCTAssertEqual(PNDAlarmCalculateManager.convertTimeStringToHour("12:34"), 12)
        XCTAssertNotEqual(PNDAlarmCalculateManager.convertTimeStringToHour("12:34"), 11)
    }
    
    func testConvertTimeStringToMinute() {
        XCTAssertEqual(PNDAlarmCalculateManager.convertTimeStringToMinute("12:34"), 34)
        XCTAssertNotEqual(PNDAlarmCalculateManager.convertTimeStringToMinute("12:34"), 33)
    }
    
    func testSnoozeTimeString() {
        let calendar = NSCalendar(identifier: NSGregorianCalendar)!
        let data =  calendar.dateBySettingHour(12, minute: 34, second: 0, ofDate:NSDate(), options: nil)!
        XCTAssertEqual(PNDAlarmCalculateManager.snoozeTimeString(data), self.minuteSet(.Minute, number: 9, date: data))
        XCTAssertNotEqual(PNDAlarmCalculateManager.snoozeTimeString(data), self.minuteSet(.Minute, number: 8, date: data))
    }
    
    func testCurrentTime() {
        XCTAssertEqual(PNDAlarmCalculateManager.currentTimeString(), self.minuteSet(.Second, number: 0, date: NSDate()))
    }

    enum Interval: String {
        case Year = "yyyy"
        case Month = "MM"
        case Day = "dd"
        case Hour = "HH"
        case Minute = "mm"
        case Second = "ss"
    }
    
    private func minuteSet(interval: Interval, number: Int, date: NSDate) -> String {
        let calendar = NSCalendar.currentCalendar()
        var comp = NSDateComponents()
        
        switch interval {
        case .Year:
            comp.year = number
        case .Month:
            comp.month = number
        case .Day:
            comp.day = number
        case .Hour:
            comp.hour = number
        case .Minute:
            comp.minute = number
        case .Second:
            comp.second = number
        default:
            comp.day = 0
        }
        let alarmTime = calendar.dateByAddingComponents(comp, toDate: date, options: nil)!
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        return dateFormatter.stringFromDate(alarmTime)
    }

}
