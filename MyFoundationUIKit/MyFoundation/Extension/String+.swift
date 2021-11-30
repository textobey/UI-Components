//
//  String+.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/11/30.
//

import Foundation

extension String {
    /// "yyyy-MM-dd HH:mm:ss"
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
}
