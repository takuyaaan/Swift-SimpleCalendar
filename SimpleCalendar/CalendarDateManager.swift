//
//  CalendarDateManager.swift
//  SimpleCalendar
//
//  Created by Takuyaaan on 2017/06/28.
//  Copyright © 2017年 Takuyaaan. All rights reserved.
//

import UIKit

class CalendarDateManager {
    
    var currentMonthOfDates = [Date]()
    var selectedDate = Date()
    fileprivate let daysPerWeek: Int = 7
    
    fileprivate func firstDateOfMonth() -> Date {
        var components = NSCalendar.current.dateComponents([.year, .month, .day], from: selectedDate as Date)
        components.day = 1
        return NSCalendar.current.date(from: components)!
    }
    
    fileprivate func dateForCellAtIndexPath(_ numberOfItems: Int) {
        let ordinalityOfFirstDay = NSCalendar.current.ordinality(of: .day, in: .weekOfMonth, for: firstDateOfMonth())
        let numberOfItems = daysCalculation()
        for ii in 0..<numberOfItems {
            var dateComponents = DateComponents()
            dateComponents.day = ii - (ordinalityOfFirstDay! - 1)
            let date = NSCalendar.current.date(byAdding: dateComponents, to: firstDateOfMonth())
            currentMonthOfDates.append(date!)
        }
    }
    
    fileprivate func monthCalculation(addValue: Int, from date: Date) -> Date {
        let calendar = NSCalendar.current
        var dateComponents = DateComponents()
        dateComponents.month = addValue
        return calendar.date(byAdding: dateComponents, to: date)!
    }
    
    func daysCalculation() -> Int {
        
        let rangeWeeks = NSCalendar.current.range(of: .weekOfMonth, in: .month, for: firstDateOfMonth())
        let numberOfWeeks = rangeWeeks?.count
        return numberOfWeeks! * daysPerWeek
    }
    
    func conversionFormat(_ indexPath: IndexPath) -> String {
        if currentMonthOfDates.count <= 0 {
            dateForCellAtIndexPath(daysCalculation())
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: currentMonthOfDates[indexPath.row])
    }
    
    func isCurrentMonth(_ indexPath: IndexPath) -> Bool {
        if currentMonthOfDates.count <= 0 {
            dateForCellAtIndexPath(daysCalculation())
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "M"
        let currentMonth = formatter.string(from: selectedDate)
        let stringMonth = formatter.string(from: currentMonthOfDates[indexPath.row])
        if Int(stringMonth) != Int(currentMonth) {
            return false
        }
        return true
    }
    
    func prevMonth(date: Date) -> Date {
        currentMonthOfDates = []
        selectedDate = monthCalculation(addValue: -1, from: date)
        dateForCellAtIndexPath(daysCalculation())
        return selectedDate
    }

    func nextMonth(date: Date) -> Date {
        currentMonthOfDates = []
        selectedDate = monthCalculation(addValue: 1, from: date)
        dateForCellAtIndexPath(daysCalculation())
        return selectedDate
    }
    
}
