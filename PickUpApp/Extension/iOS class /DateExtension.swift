//
//  DateExtension.swift
//

import Foundation

let serverDateFormate = "yyyy-MM-dd HH:mm:ss"

let second = 1
let minute = second * 60
let hour = minute * 60
let day = hour * 24
let month = day * 30

extension Date {
    
    
    static func convertUTCStringToDate(_ strDate:String, dateFormat:String) -> Date?
    {
        let formatter:DateFormatter = DateFormatter();
        formatter.dateFormat = dateFormat;
        
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let date = formatter.date(from: strDate);
        return date;
    }
    
    static func convertOptionStringToDate(_ strDate : String, dateFormat : String) -> Date?
    {
        
        let formatter:DateFormatter = DateFormatter();
        formatter.dateFormat = dateFormat;
        //formatter.timeZone =  TimeZone.ReferenceType.local
        formatter.timeZone = TimeZone.autoupdatingCurrent
        
        let myDate = formatter.date(from: strDate);
        return myDate
        
    }
    
    static func convertStringToDate(_ strDate : String, dateFormat : String) -> Date
    {
        
        let formatter:DateFormatter = DateFormatter();
        formatter.dateFormat = dateFormat;
        //formatter.timeZone =  TimeZone.ReferenceType.local
        formatter.timeZone = TimeZone.autoupdatingCurrent
        
        let myDate = formatter.date(from: strDate);
        return myDate!
        
    }
    
    
    static func convertLocalStringToUTCDate(_ date:Date, dateFormat:String) -> String?
    {
        let formatter:DateFormatter = DateFormatter();
        formatter.dateFormat = dateFormat;
        formatter.timeZone = TimeZone(abbreviation: "GMT+02:00")
        
        let str = formatter.string(from: date);
        return str;
    }
    
    static func convertUTCDateToString(_ date:Date, dateFormat:String) -> String?
    {
        let formatter:DateFormatter = DateFormatter();
        formatter.dateFormat = dateFormat;
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        let str = formatter.string(from: date);
        return str;
    }
    
    static func convertDateToString(_ date:Date, dateFormat:String) -> String?
    {
        let formatter:DateFormatter = DateFormatter();
        formatter.dateFormat = dateFormat;
        formatter.timeZone = TimeZone.autoupdatingCurrent
        let str = formatter.string(from: date);
        return str;
    }
    
    func isGreaterThanDate(_ dateToCompare: Date) -> Bool {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedDescending {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    func isLessThanDate(_ dateToCompare: Date) -> Bool {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedAscending {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    func equalToDate(_ dateToCompare: Date) -> Bool {
        //Declare Variables
        var isEqualTo = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedSame {
            isEqualTo = true
        }
        
        //Return Result
        return isEqualTo
    }
    
    func addDays(_ daysToAdd: Int) -> Date {
        let secondsInDays: TimeInterval = Double(daysToAdd) * 60 * 60 * 24
        let dateWithDaysAdded: Date = self.addingTimeInterval(secondsInDays)
        
        //Return Result
        return dateWithDaysAdded
    }
    
    func addHours(_ hoursToAdd: Int) -> Date {
        let secondsInHours: TimeInterval = Double(hoursToAdd) * 60 * 60
        let dateWithHoursAdded: Date = self.addingTimeInterval(secondsInHours)
        
        //Return Result
        return dateWithHoursAdded
    }
    
    func isToday(_ date: Date) -> Bool {
        
        let calendar = Calendar.current
        let day1 = calendar.component(.day, from: self)
        let day2 = calendar.component(.day, from: date)
        
        return (day1 == day2)
    }
    
    func isYesterday(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let day1 = calendar.component(.day, from: self)
        let day2 = calendar.component(.day, from: date)
        
        return (day1 + 1 == day2)
    }
    func isSameYear(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let year1 = calendar.component(.year, from: self)
        let year2 = calendar.component(.year, from: date)
        
        return (year1 == year2)
    }
    func isSameWeek(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let year1 = calendar.component(.weekOfYear, from: self)
        let year2 = calendar.component(.weekOfYear, from: date)
        
        return (year1 == year2)
    }
    
    func yearsFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.year, from: date, to: self, options: []).year!
    }
    func monthsFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.month, from: date, to: self, options: []).month!
    }
    func weeksFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.weekOfYear, from: date, to: self, options: []).weekOfYear!
    }
    func daysFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.day, from: date, to: self, options: []).day!
    }
    func hoursFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.hour, from: date, to: self, options: []).hour!
    }
    func minutesFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.minute, from: date, to: self, options: []).minute!
    }
    func secondsFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.second, from: date, to: self, options: []).second!
    }
    func offsetFrom(_ date:Date) -> String {
        if yearsFrom(date)   > 0 { return "\(yearsFrom(date))y"   }
        if monthsFrom(date)  > 0 { return "\(monthsFrom(date))M"  }
        if weeksFrom(date)   > 0 { return "\(weeksFrom(date))w"   }
        if daysFrom(date)    > 0 { return "\(daysFrom(date))d"    }
        if hoursFrom(date)   > 0 { return "\(hoursFrom(date))h"   }
        if minutesFrom(date) > 0 { return "\(minutesFrom(date))m" }
        if secondsFrom(date) > 0 { return "\(secondsFrom(date))s" }
        return ""
    }
    
    
    func startOfMonth() -> Date? {
        let comp: DateComponents = Calendar.current.dateComponents([.year, .month, .hour], from: Calendar.current.startOfDay(for: self))
        return Calendar.current.date(from: comp)!
    }
    
    func endOfMonth() -> Date? {
        var comp: DateComponents = Calendar.current.dateComponents([.month, .day, .hour], from: Calendar.current.startOfDay(for: self))
        comp.month = 1
        comp.day = -1
        return Calendar.current.date(byAdding: comp, to: self.startOfMonth()!)
    }
    
    func getTimeInterval() -> String? {
        let currentTime = Date(timeIntervalSinceNow: 0)
        
        let timeInterval = Int(currentTime.timeIntervalSince(self))
        if timeInterval < minute {
            return "Just Now"
        }
        if timeInterval < hour {
            return "\(currentTime.minutesFrom(self)) min ago"
        }
        if timeInterval <= (hour * 5) {
            return "\(currentTime.hoursFrom(self)) hours ago"
        }
        if self.isToday(currentTime) && timeInterval > (hour * 5)  {
            return "Today \(Date.convertDateToString(self, dateFormat: "hh:mm a")!)"
        }
        if self.isYesterday(currentTime) {
            return "Yesterday \(Date.convertDateToString(self, dateFormat: "hh:mm a")!)"
        }
        if self.isSameWeek(currentTime) {
            return "\(Date.convertDateToString(self, dateFormat: "EEEE hh:mm a")!)"
        }
        if self.isSameYear(currentTime) {
            return "\(Date.convertDateToString(self, dateFormat: "dd MMM, hh:mm a")!)"
        }
        else {
            return "\(Date.convertDateToString(self, dateFormat: "dd MMM yyyy, hh:mm a")!)"
        }
        return nil
    }
}
