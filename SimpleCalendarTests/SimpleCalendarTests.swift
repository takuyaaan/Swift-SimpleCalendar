//
//  SimpleCalendarTests.swift
//  SimpleCalendarTests
//
//  Created by Takuyaaan on 2017/06/28.
//  Copyright © 2017年 Takuyaaan. All rights reserved.
//

import XCTest
import RealmSwift
import SwiftyJSON

@testable import SimpleCalendar

class SimpleCalendarTests: XCTestCase {
    var realmManager: RealmManager!
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        var realmConfig = Realm.Configuration.defaultConfiguration
        realmConfig.inMemoryIdentifier = "SimpleCalendarTests"
        realmManager = RealmManager(defaultRealm: try! Realm(configuration: realmConfig))
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    // RealmManager

    func testIsSaveAt() {
        realmManager.insertDate(date: "2017-01-01", memo: "SimpleCalendarTests1")
        let ret = realmManager.isSaveAt(date: "2017-01-01")
        XCTAssert(ret)
    }
    func testMemoAt() {
        realmManager.insertDate(date: "2017-02-01", memo: "SimpleCalendarTests2")
        let string = realmManager.memoAt(date: "2017-02-01")
        XCTAssertEqual(string, "SimpleCalendarTests2")
    }
    func testInsertDate() {
        realmManager.insertDate(date: "2017-03-01", memo: "SimpleCalendarTests3")
        let string = realmManager.memoAt(date: "2017-03-01")
        XCTAssertEqual(string, "SimpleCalendarTests3")
    }
    func testUpdateDate() {
        realmManager.insertDate(date: "2017-04-01", memo: "SimpleCalendarTests4")
        realmManager.updateDate(date: "2017-04-01", memo: "SimpleCalendarTests4-1")
        let string = realmManager.memoAt(date: "2017-04-01")
        XCTAssertEqual(string, "SimpleCalendarTests4-1")
    }
    func testDeleteDate() {
        realmManager.insertDate(date: "2017-05-01", memo: "SimpleCalendarTests5")
        realmManager.deleteDate(date: "2017-05-01")
        let string = realmManager.memoAt(date: "2017-05-01")
        XCTAssertEqual(string, "")
    }

    // CalendarDateManager

    func testDaysCalculation() {
        let calendar = CalendarDateManager()
        calendar.selectedDate = Calendar(identifier: .gregorian).date(from: DateComponents(year: 2017, month: 1, day: 1))!
        let daysNum = calendar.daysCalculation()
        XCTAssertEqual(daysNum, 35)
    }

    func testConversionFormat() {
        let calendar = CalendarDateManager()
        calendar.selectedDate = Calendar(identifier: .gregorian).date(from: DateComponents(year: 2017, month: 1, day: 1))!
        let day = calendar.conversionFormat(IndexPath(row: 0, section: 0))
        XCTAssertEqual(day, "1")
    }

    func testIsCurrentMonth() {
        let calendar = CalendarDateManager()
        calendar.selectedDate = Calendar(identifier: .gregorian).date(from: DateComponents(year: 2017, month: 1, day: 1))!
        let ret = calendar.isCurrentMonth(IndexPath(row: 7, section: 0))
        XCTAssert(ret)
    }

    func testPrevMonth() {
        let calendar = CalendarDateManager()
        let prev = calendar.prevMonth(date: Calendar(identifier: .gregorian).date(from: DateComponents(year: 2017, month: 3, day: 1))!)
        let equal = Calendar(identifier: .gregorian).date(from: DateComponents(year: 2017, month: 2, day: 1))
        XCTAssertEqual(prev, equal)
    }

    func testNextMonth() {
        let calendar = CalendarDateManager()
        let next = calendar.nextMonth(date: Calendar(identifier: .gregorian).date(from: DateComponents(year: 2017, month: 3, day: 1))!)
        let equal = Calendar(identifier: .gregorian).date(from: DateComponents(year: 2017, month: 4, day: 1))
        XCTAssertEqual(next, equal)
    }
    
}
