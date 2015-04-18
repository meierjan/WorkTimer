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
    
    // will be the name even if it doesnt exist
    private var calendarName : String
    
    private var eventStore = EKEventStore()
    private var calendar : EKCalendar!
    
    struct DateConstants {
        let startDate   =   NSDate(timeIntervalSinceNow: -60*60*24*365)
        let endDate     =   NSDate().dateByAddingTimeInterval(60*60*24*3)
    }
    
    
    init(let name: String) {
        let constants = DateConstants()
        calendarName = name;
        loadCalendar()
    }
    
    var events = [EKEvent]()
    var eventsAsWeekDict = [Int: [EKEvent]]()
    
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
    
    func workedHourByArrayIndex(let index: Int ) -> Double {
        var hours = 0
        let (_,weekEvents) = eventWeekByArrayIndex(index)
        
        return weekEvents == nil ? 0 : weekEvents!.reduce(0) { $0 + $1.duration(.Hours)}
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
        
        eventsAsWeekDict = [Int: [EKEvent]]()
        
        
        for (i, event) in enumerate(events) {
            let indexInArray = event.weekNumber - startWeek!
            if eventsAsWeekDict[event.weekNumber] == nil {
                eventsAsWeekDict[event.weekNumber] = []
            }
            println("\(event.title) in Week \(event.weekNumber)")
            eventsAsWeekDict[event.weekNumber]?.append(event)
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
    
}