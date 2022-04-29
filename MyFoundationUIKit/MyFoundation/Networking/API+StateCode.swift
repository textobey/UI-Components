//
//  API+StateCode.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/04/29.
//

import Foundation

extension APIError {
    enum StateCode: String {
        case http_000_00000 = "00000000"
        case http_200_00000 = "20000000"
        case http_400_00000 = "40000000"
        case http_401_00000 = "40100000"
        case http_999_99999 = "99999999"
    }
    
    static func getMatchStateCode(errorCode: String?) -> APIError.StateCode {
        guard let errorCode = errorCode else {
            return .http_000_00000
        }
        return StateCode(rawValue: errorCode) ?? .http_000_00000
    }
}
