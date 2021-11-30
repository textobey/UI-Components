//
//  Date+.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/11/30.
//

import Foundation

extension Date {
    var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
        calendar.locale   = Locale(identifier: "ko_KR")
        return calendar
    }
    
    var year: Int {
        return calendar.component(.year, from: self)
    }

    var month: Int {
        return calendar.component(.month, from: self)
    }

    var day: Int {
        return calendar.component(.day, from: self)
    }

    var hour: Int {
        return calendar.component(.hour, from: self)
    }

    var minute: Int {
        return calendar.component(.minute, from: self)
    }

    var second: Int {
        return calendar.component(.second, from: self)
    }
    
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    //print(Date().startOfMonth())     // "2018-02-01 08:00:00 +0000\n"
    //print(Date().endOfMonth())       // "2018-02-28 08:00:00 +0000\n"
    
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return dateFormatter.string(from: self)
    }
}
