//
//  PandaNotifTests.swift
//  PandaNotifTests
//
//  Created by ShinichiSakaguchi on 2014/11/21.
//  Copyright (c) 2014年 Shinichi.Sakaguchi. All rights reserved.
//

import UIKit
import XCTest

class PandaNotifTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCalculate() {
        let calculate = PNDAlarmCalculateManagerTests()
        let calendar = NSCalendar(identifier: NSGregorianCalendar)!
        let data =  calendar.dateBySettingHour(12, minute: 34, second: 0, ofDate:NSDate(), options: nil)!
        let data2 = calendar.dateBySettingHour(12, minute: 34, second: 1, ofDate:NSDate(), options: nil)!
        let data3 = calendar.dateBySettingHour(12, minute: 35, second: 0, ofDate:NSDate(), options: nil)!
        // This is an example of a functional test case.
        //XCTAssertEqual(PNDAlarmCalculateManager.convertTimeStringToFireDate("12:34"), data, "convertTimeStringToFireDate Error")
        XCTAssertNotEqual(calculate.convertTimeStringToFireDate("12:34"), data2, "convertTimeStringToFireDate2 Error")
        XCTAssertNotEqual(calculate.convertTimeStringToFireDate("12:34"), data3, "convertTimeStringToFireDate3 Error")
        
        XCTAssertEqual(calculate.convertTimeStringToHour("12:34"), 12, "convertTimeStringToHour Equal Error")
        XCTAssertNotEqual(calculate.convertTimeStringToHour("12:34"), 11, "convertTimeStringToHour NotEqual Error")
        
        XCTAssertEqual(calculate.convertTimeStringToMinute("12:34"), 34, "convertTimeStringToMinute Equal Error")
        XCTAssertNotEqual(calculate.convertTimeStringToHour("12:34"), 33, "convertTimeStringToMinute NotEqual Error")
        
        //XCTAssertEqual(calculate.localDate(), NSDate(), "Bad LocalDate")
        XCTAssertEqual(calculate.snoozeTime(data), "12:43", "snoozeTime Equal Error")
        XCTAssertNotEqual(calculate.snoozeTime(data), "12:42", "snoozeTime NotEqual Error")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
}
