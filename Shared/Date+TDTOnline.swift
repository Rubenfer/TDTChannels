//
//  Date+TDTOnline.swift
//  TDTOnline iOS
//
//  Created by Ruben Fernandez on 31/10/2019.
//  Copyright © 2019 Ruben Fernandez. All rights reserved.
//

import Foundation

extension Date {
    
    static func parse(tvDate: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss Z"
        return dateFormatter.date(from: tvDate)
    }
    
    static func parse(humanDate: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd'/'MM'/'yyyy"
        return dateFormatter.date(from: humanDate)
    }
    
    var humanDate: String {
        get {
            return "\(day())/\(month())/\(year())"
        }
    }
    
    var humanTime: String {
        get {
            return "\(hour()):\(minute())"
        }
    }
    
    func day() -> Int {
        return Calendar.current.component(.day, from: self)
    }
    
    func month() -> Int {
        return Calendar.current.component(.month, from: self)
    }
    
    func year() -> Int {
        return Calendar.current.component(.year, from: self)
    }
    
    func hour() -> String {
        var hour = String(Calendar.current.component(.hour, from: self))
        if hour.count == 1 {
            hour = "0\(hour)"
        }
        return hour
    }
    
    func minute() -> String {
        var minute = String(Calendar.current.component(.minute, from: self))
        if minute.count == 1 {
            minute = "0\(minute)"
        }
        return minute
    }
    
}
