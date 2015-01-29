//
//  PNDAlarmTableViewManagerTest.swift
//  PandaNotif
//
//  Created by ShinichiSakaguchi on 2015/01/29.
//  Copyright (c) 2015年 Shinichi.Sakaguchi. All rights reserved.
//

import UIKit
import XCTest

class PNDAlarmTableViewManagerTest: XCTestCase {
    func testSoundStatus() {
        XCTAssertEqual(PNDAlarmTableViewManager.soundStatus(UILocalNotificationDefaultSoundName),0)
        XCTAssertEqual(PNDAlarmTableViewManager.soundStatus("nil"),1)
        XCTAssertEqual(PNDAlarmTableViewManager.soundStatus("佐村河内 守"),999)
    }
    
    func testSoundName() {
        XCTAssertEqual(PNDAlarmTableViewManager.soundName(UILocalNotificationDefaultSoundName),"デフォルト")
        XCTAssertEqual(PNDAlarmTableViewManager.soundName("nil"),"なし")
        XCTAssertEqual(PNDAlarmTableViewManager.soundName("新垣 隆"),"Unknown SoundName")
    }
    
    func testRepeatStatus() {
        XCTAssertEqual(PNDAlarmTableViewManager.repeatStatus("1111111"), "毎日")
        XCTAssertEqual(PNDAlarmTableViewManager.repeatStatus("1000001"), "週末")
        XCTAssertEqual(PNDAlarmTableViewManager.repeatStatus("0111110"), "平日")
        XCTAssertEqual(PNDAlarmTableViewManager.repeatStatus("0000000"), "しない")

        XCTAssertEqual(PNDAlarmTableViewManager.repeatStatus("1000000"), "日")
        XCTAssertEqual(PNDAlarmTableViewManager.repeatStatus("0100000"), "月 ")
        XCTAssertEqual(PNDAlarmTableViewManager.repeatStatus("0010000"), "火 ")
        XCTAssertEqual(PNDAlarmTableViewManager.repeatStatus("0001000"), "水 ")
        XCTAssertEqual(PNDAlarmTableViewManager.repeatStatus("0000100"), "木 ")
        XCTAssertEqual(PNDAlarmTableViewManager.repeatStatus("0000010"), "金 ")
        XCTAssertEqual(PNDAlarmTableViewManager.repeatStatus("0000001"), "土 ")
        
        XCTAssertEqual(PNDAlarmTableViewManager.repeatStatus("1111101"), "月 火 水 木 土 日")
    }
}
