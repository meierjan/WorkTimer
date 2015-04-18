//
//  WorkEvent.swift
//  WorkTimer
//
//  Created by Jan Meier on 23.03.15.
//  Copyright (c) 2015 Jan Meier. All rights reserved.
//
import Foundation
import EventKit

extension EKEvent {
    
    enum TimeUnit {
        case Seconds, Minutes, Hours
    }
    
    func duration(let timeUnit: TimeUnit) -> Double {
        let durationInSecounds = self.endDate.timeIntervalSinceDate(self.startDate)
        switch timeUnit {
        case .Seconds:
            return durationInSecounds
        case .Minutes:
            return durationInSecounds / 60
        case .Hours:
            return durationInSecounds / 3600
        }
    }
    
    var weekNumber : Int {
        return self.startDate.weekNumber
    }
}
