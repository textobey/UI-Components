//
//  API+Method.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/01/20.
//

import Foundation
import Moya

extension API {
    func getMethod() -> Moya.Method {
        switch self {
        case .currentWeather:
            return Method.get
        case .oneCall:
            return Method.get
        case .filesUpload:
            return Method.post
        }
    }
}
