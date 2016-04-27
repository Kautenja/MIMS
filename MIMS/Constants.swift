//
//  Constants.swift
//  MIMS
//
//  Created by Patrick M. Bush on 4/19/16.
//  Copyright © 2016 UML Lovers. All rights reserved.
//

import Foundation

func createAlert(message: String, errorMessage: String) -> UIAlertController {
    let alert = UIAlertController(title: message, message: errorMessage, preferredStyle: .Alert)
    alert.addAction(UIAlertAction(title: "Dismiss", style: .Destructive, handler: nil))
    return alert
}


public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs === rhs || lhs.compare(rhs) == .OrderedSame
}

public func <(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == .OrderedAscending
}

extension NSDate: Comparable { }

extension NSDate {

    func getDateForAppointment() ->String {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Year, .Month, .Day, .Weekday], fromDate: self)
        let month = components.month
        let day = components.day
        let year = components.year
        let weekday = components.weekday
        let actualMonth = checkMonth(month)
        let actualWeekday = checkDay(weekday)
        return ("\(actualWeekday), \(actualMonth) \(day), \(year)")
    }
    
    func checkMonth(month: Int) -> String {
        switch month {
        case 1: return "January"
        case 2: return "February"
        case 3: return "March"
        case 4: return "April"
        case 5: return "May"
        case 6: return "June"
        case 7: return "July"
        case 8: return "August"
        case 9: return "September"
        case 10: return "October"
        case 11: return "November"
        case 12: return "December"
        default: return ""
        }
    }
    
    func checkDay(day: Int) -> String {
        switch day {
        case 1: return "Sunday"
        case 2: return "Monday"
        case 3: return "Tuesday"
        case 4: return "Wednesday"
        case 5: return "Thursday"
        case 6: return "Friday"
        case 7: return "Saturday"
        case 8: return "Sunday"
        default: return ""
        }
    }
//
//    func getTimeForAppointment() -> String {
//        let calendar = NSCalendar.currentCalendar()
//        let components = calendar.components([.Hour, .Minute], fromDate: self)
//        let hour = components.hour
//        let minute = components.minute
//        return ("\(hour):\(minute) - \(hour + 1):\(minute)")
//    }
    
    func getTimeForAppointment() -> String
    {
        //Get Short Time String
        let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        let timeString = formatter.stringFromDate(self)
        
        //Return Short Time String
        return timeString
    }
}