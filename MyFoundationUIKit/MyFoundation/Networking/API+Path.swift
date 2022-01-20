//
//  API+Path.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/01/20.
//

import Foundation

extension API {
    func getPath() -> String {
        switch self {
        case .currentWeather:
            return "/data/2.5/weather"
        case .oneCall:
            return "/data/2.5/onecall"
        case .filesUpload:
            return ""
        }
    }
}
