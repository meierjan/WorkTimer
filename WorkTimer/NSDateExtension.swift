//
//  NSDateExtension.swift
//  WorkTimer
//
//  Created by Jan Meier on 24.03.15.
//  Copyright (c) 2015 Jan Meier. All rights reserved.
//

import Foundation

extension NSDate {

    // from: http://stackoverflow.com/questions/28088201/nscalendar-week-number-of-date
    var weekNumber : Int {
        let calender = NSCalendar.currentCalendar()
        let dateComponent = calender.components(
            [NSCalendarUnit.WeekOfYear, NSCalendarUnit.Day, NSCalendarUnit.Month, NSCalendarUnit.Year],
            fromDate:self)
        return dateComponent.weekOfYear
    }
    
    func weeksBetweenReferenceDate(date: NSDate) -> Int {
        return date.weekNumber - date.weekNumber;
    }
}
