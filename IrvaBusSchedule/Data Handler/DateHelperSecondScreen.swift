//
//  DateHelperSecondScreen.swift
//  IrvaBusSchedule
//
//  Created by Cat on 4/29/18.
//  Copyright © 2018 Cat. All rights reserved.
//

import UIKit

class DateHelperSecondScreen {
    
    class func intervalToDeparture() {
        var dateOfDeparture: Date?
        
        let calendar = Calendar(identifier: .gregorian)
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        
        for item in Storage.shared.scheduleDataSecondScreen {
            var departureDateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
            departureDateComponents.hour = item.hours
            departureDateComponents.minute = item.minutes
            dateOfDeparture = calendar.date(from: departureDateComponents)
          
            
            guard let theDate = dateOfDeparture else {
                assert(false)
                return
            }
            
            let timeInterval = theDate.timeIntervalSince(Date())
            
            if timeInterval > 0 {
                item.intervalToDeparture = timeInterval
                item.intervalToDepartureOnTheScreen = String(stringFromTimeInterval(interval: timeInterval))
            } else {
                let previousDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())
                let timeIntervalTwo = theDate.timeIntervalSince(previousDate!)
                
                item.intervalToDepartureOnTheScreen = String(stringFromTimeInterval(interval: timeIntervalTwo))
            }
        }
    }
    
    class func nearestTrip() {
        var nearestTrip: Model?
        
        for item in Storage.shared.scheduleDataSecondScreen where item.intervalToDeparture > 0 {
            if nearestTrip == nil  {
                nearestTrip = item
            } else {
                if item.intervalToDeparture < nearestTrip!.intervalToDeparture {
                    nearestTrip = item
                }
            }
        }
        nearestTrip?.isNearestTrip = true
    }
    
    class func stringFromTimeInterval(interval: Double) -> String {
        let hours = (Int(interval) / 3600)
        let minutes = Int(interval / 60) - Int(hours * 60)
        
        if hours < 1 && minutes < 10 {
            return String(format: "%0.1dm", minutes)
        } else if hours < 1 && minutes > 9  {
            return String(format: "%0.2dm", minutes)
        } else if hours < 10 && minutes < 1 {
            return String(format: "%0.1dh", hours)
        } else if hours < 10 && minutes < 10 {
            return String(format: "%0.1dh \n%0.1dm", hours, minutes)
        } else if hours < 10 && minutes > 9 {
            return String(format: "%0.1dh %0.2dm", hours, minutes)
        } else if hours > 9 && minutes < 1 {
            return String(format: "%0.2dh", hours)
        } else if hours > 9 && minutes < 10 {
            return String(format: "%0.2dh %0.1dm", hours, minutes)
        } else {
            return String(format: "%0.2dh %0.2dm", hours, minutes)
        }
    }

}
