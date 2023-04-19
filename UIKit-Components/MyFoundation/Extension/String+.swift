//
//  String+.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/11/30.
//

import UIKit

extension String {
    static let empty = ""
    
    enum LetterType {
        case english
        case korean
        case number
        case special
        case unknown
    }
    
    func getLetterType() -> LetterType {
        if self < "A" {
            return .number
        }
        // 둘 다 영문이면 오름차순 정렬
        else if (self >= "A" && self <= "z") {
            return .english
        }
        // 둘 다 한글이면 오름차순 정렬
        else if self > "z" {
            return .korean
        }
        // 0의 아스키코드 미만이면, 특수문자로 판단
        else if self < "0" {
            return .special
        }
        return .unknown
    }
}

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

extension String {
    /// Calculate text's height from `width` and `front`.
    func calculateHeightWith(width: CGFloat, font: UIFont)-> CGFloat {
        let attr = [NSAttributedString.Key.font: font]
        let maxSize: CGSize = CGSize(width: width, height: CGFloat(MAXFLOAT))
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        return self.boundingRect(with: (maxSize), options: option, attributes: attr, context: nil).size.height
    }
}

extension String {
    /// 숫자, 가나다, ABC, 특수문자순으로 정렬합니다.
    static func sortByName(_ first: String, _ second: String) -> Bool {
        let orderAsc = ComparisonResult.orderedAscending
        // (first > "A" && second > "A") A타입으로도 숫자 오름차순 정렬이 된다. 이유는 모르겠다.. 가독성이 좋지 않아 숫자로 바꿨다..
        if (first > "1" && second > "1") { // 둘 다 숫자면 오름차순 정렬
            return first.localizedStandardCompare(second) == orderAsc
        } else if (first >= "A" && second >= "A" && first <= "z" && second <= "z") { // 둘 다 영문이면 오름차순 정렬
            return first.localizedStandardCompare(second) == orderAsc
        } else if (first > "z" && second > "z") { // 둘 다 한글이면 오름차순 정렬
            return first.localizedStandardCompare(second) == orderAsc
        } else {
            // 서로 다른 타입이면 내림차순 정렬
            // 지역 로컬을 정한 후 한글이 영문보다 우선 순위를 가지게 함
            let locale = NSLocale(localeIdentifier: "en")
            return first.compare(second, locale: locale as Locale) == orderAsc
        }
    }
}
