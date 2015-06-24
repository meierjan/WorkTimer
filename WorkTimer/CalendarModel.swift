//
//  CalendarModel.swift
//  WorkTimer
//
//  Created by Jan Meier on 23.03.15.
//  Copyright (c) 2015 Jan Meier. All rights reserved.
//
import UIKit
import EventKitUI
import Foundation

class CalendarModel {
    
    struct DateConstants {
        let startDate   =   NSDate(timeIntervalSinceNow: -60*60*24*365)
        let endDate     =   NSDate().dateByAddingTimeInterval(60*60*24*3)
    }
    
    
    init(let name: String) {
        let constants = DateConstants()
        calendarName = name;
        loadCalendar()
    }
    
    // constants
    static let workingHoursPerWeek : Double  =  8.0
    
    // will be the name even if it doesnt exist
    private var calendarName : String
    
    private var eventStore = EKEventStore()
    private var calendar : EKCalendar!
    
    private var events = [EKEvent]()
    private var eventsAsWeekDict = [Int: [EKEvent]]()
    
    private var workedHoursPerWeek = [Double]()
    private var workedOverHoursPerWeek = [Double]()
    private var totalOverHoursUntilWeek = [Double]()

    var startWeek : Int?
    var lastWeek : Int?
  
    var weekSpan : Int {
        get {
            if let end = lastWeek {
                if let start = startWeek {
                    return end - start
                }
            }
            return 0;
        }
    }
    
    // MARK: Public API
    func getOverhoursForIndex(index: Int) -> Double {
        return workedOverHoursPerWeek[index]
    }
    
    func getOverhoursUntilWeek(index: Int) -> Double {
        return totalOverHoursUntilWeek[index]
    }
    
    func getWorkedhoursForIndex(index: Int) -> Double {
        return workedHoursPerWeek[index]
    }
    
    func eventWeekByArrayIndex(index: Int) -> (Int, [EKEvent]?) {
        if 0 <= index && index <  weekSpan {
            // raise exception
        }
        let week = startWeek! + index
        return (week, eventsAsWeekDict[week])
    }
    
    func eventsForWeek(let week: Int) -> [EKEvent]? {
        return eventsAsWeekDict[week]
    }
    
    var firstEventWeek : Int? {
        get {
            return events.first?.weekNumber
        }
    }
    
    func reloadEvents() {
        loadCalendar()
    }
    
    // MARK: - Non-public API
    
    
    private func loadEvents() {
        let constants = DateConstants()
        let eventList = eventsFromCalendarForTimeSpan(startDate: constants.startDate, endDate: constants.endDate)
        events = eventList
        events.sort({ (event1:EKEvent, event2:EKEvent) -> Bool in
            return event1.weekNumber < event2.weekNumber
        })
        
        startWeek  = events.first?.weekNumber
        let lastEventWeek = events.last?.weekNumber
        
        lastWeek = max( lastEventWeek! + 1 , NSDate().weekNumber)
        let weekCount = lastWeek! - startWeek!
        
        
        
        eventsAsWeekDict = [Int: [EKEvent]]()
        
        
        for (i, event) in enumerate(events) {

            let indexInArray = event.weekNumber - startWeek!
            if eventsAsWeekDict[event.weekNumber] == nil {
                eventsAsWeekDict[event.weekNumber] = []
            }
            eventsAsWeekDict[event.weekNumber]?.append(event)
        }
        // refresh worktime array
        self.reloadHoursAndOverhours(weekCount)
    }
    
    private func reloadHoursAndOverhours(weekCount: Int) {
    // fill array
        workedHoursPerWeek = [Double](count: weekCount,repeatedValue: 0.0)
        totalOverHoursUntilWeek = [Double](count: weekCount,repeatedValue: 0.0)
        workedOverHoursPerWeek = [Double](count: weekCount,repeatedValue: 0.0)
        for i in 0...weekCount-1 {
            workedHoursPerWeek[i] = self.workedHoursByArrayIndex(i)
            workedOverHoursPerWeek[i] = self.overHoursByArrayIndex(i)
            if i  == 0 {
                totalOverHoursUntilWeek[i] = self.overHoursByArrayIndex(i)
            } else {
                totalOverHoursUntilWeek[i] = (totalOverHoursUntilWeek[i-1] + self.overHoursByArrayIndex(i))
            }
        }
    }

    private func loadCalendar() {
        let calendars = self.eventStore.calendarsForEntityType(EKEntityTypeEvent) as! [EKCalendar]
        for cal in calendars { // (should be using identifier)
            if cal.title == calendarName {
                calendar = cal
                loadEvents()
                return
            }
        }
        calendar = nil
    }
    
    private func eventsFromCalendarForTimeSpan(let #startDate: NSDate, let endDate: NSDate) -> [EKEvent] {
        let predicate = eventStore.predicateForEventsWithStartDate(startDate, endDate: endDate,  calendars: [self.calendar])
        return eventStore.eventsMatchingPredicate(predicate)as! [EKEvent]
    }
    
    private func workedHoursByArrayIndex(let index: Int ) -> Double {
        var hours = 0
        let (_,weekEvents) = eventWeekByArrayIndex(index)
        
        return weekEvents == nil ? 0 : weekEvents!.reduce(0) { $0 + $1.duration(.Hours)}
    }
    
    private func overHoursByArrayIndex(let index: Int) -> Double {
        let workedHours = self.workedHoursByArrayIndex(index)
        return workedHours - CalendarModel.workingHoursPerWeek
    }
    
}