//
//  PNDFireManagerTest.swift
//  PandaNotif
//
//  Created by ShinichiSakaguchi on 2015/01/29.
//  Copyright (c) 2015年 Shinichi.Sakaguchi. All rights reserved.
//

import UIKit
import XCTest

class PNDFireManagerTest: XCTestCase {
    func testMakeNotification() {
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        NSThread.sleepForTimeInterval(0.5)
        XCTAssert(UIApplication.sharedApplication().scheduledLocalNotifications.isEmpty)

        // 登録済みNotificationと時刻・ラベルが同じ、かつリピートなしは登録されない
        do {
            PNDAlarmFireManager.makeNotification("23:59", repeat: "0000000", snooze: true, label: "Test", sound: "nil")
            PNDAlarmFireManager.makeNotification("23:59", repeat: "0000000", snooze: true, label: "Test", sound: "nil")
            PNDAlarmFireManager.makeNotification("23:59", repeat: "0000000", snooze: true, label: "Test", sound: "nil")
            NSThread.sleepForTimeInterval(0.5)
            XCTAssertEqual(UIApplication.sharedApplication().scheduledLocalNotifications.count,1)
        } while false
        
        // 登録されるNotification例
        do {
            PNDAlarmFireManager.makeNotification("23:59", repeat: "0000000", snooze: true, label: "Ultra Super Unit Test", sound: "nil")
            PNDAlarmFireManager.makeNotification("23:59", repeat: "1000000", snooze: true, label: "Test", sound: "nil")
            NSThread.sleepForTimeInterval(0.5)
            XCTAssertEqual(UIApplication.sharedApplication().scheduledLocalNotifications.count,3)
        } while false
        
        do {
            UIApplication.sharedApplication().cancelAllLocalNotifications()
            PNDAlarmFireManager.makeNotification("23:59", repeat: "1000000", snooze: true, label: "Test", sound: "nil")
            NSThread.sleepForTimeInterval(0.5)
            XCTAssertEqual(UIApplication.sharedApplication().scheduledLocalNotifications.count,2)
        } while false
        
        do {
            UIApplication.sharedApplication().cancelAllLocalNotifications()
            PNDAlarmFireManager.makeNotification("23:59", repeat: "1100000", snooze: true, label: "Test", sound: "nil")
            NSThread.sleepForTimeInterval(0.5)
            XCTAssertEqual(UIApplication.sharedApplication().scheduledLocalNotifications.count,3)
        } while false
        
        do {
            UIApplication.sharedApplication().cancelAllLocalNotifications()
            PNDAlarmFireManager.makeNotification("23:59", repeat: "1110000", snooze: true, label: "Test", sound: "nil")
            NSThread.sleepForTimeInterval(0.5)
            XCTAssertEqual(UIApplication.sharedApplication().scheduledLocalNotifications.count,4)
        } while false
        
        do {
            UIApplication.sharedApplication().cancelAllLocalNotifications()
            PNDAlarmFireManager.makeNotification("23:59", repeat: "1111000", snooze: true, label: "Test", sound: "nil")
            NSThread.sleepForTimeInterval(0.5)
            XCTAssertEqual(UIApplication.sharedApplication().scheduledLocalNotifications.count,5)
        } while false
        
        do {
            UIApplication.sharedApplication().cancelAllLocalNotifications()
            PNDAlarmFireManager.makeNotification("23:59", repeat: "1111100", snooze: true, label: "Test", sound: "nil")
            NSThread.sleepForTimeInterval(0.5)
            XCTAssertEqual(UIApplication.sharedApplication().scheduledLocalNotifications.count,6)
        } while false
        
        do {
            UIApplication.sharedApplication().cancelAllLocalNotifications()
            PNDAlarmFireManager.makeNotification("23:59", repeat: "1111110", snooze: true, label: "Test", sound: "nil")
            NSThread.sleepForTimeInterval(0.5)
            XCTAssertEqual(UIApplication.sharedApplication().scheduledLocalNotifications.count,7)
        } while false
        
        do {
            UIApplication.sharedApplication().cancelAllLocalNotifications()
            PNDAlarmFireManager.makeNotification("23:59", repeat: "1111111", snooze: true, label: "Test", sound: "nil")
            NSThread.sleepForTimeInterval(0.5)
            XCTAssertEqual(UIApplication.sharedApplication().scheduledLocalNotifications.count,8)
        } while false
    }
}
