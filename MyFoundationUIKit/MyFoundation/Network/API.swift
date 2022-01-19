//
//  API.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/01/19.
//

import Foundation
import Moya

enum API {
    case currentWeather(lat: String, lon: String)
    case oneCall
}

// Moya는 MoyaProvider<TargetType>으로 request를 수행하기 때문에, TargetType 프로토콜을 구현해야함
extension API: TargetType {
    /// 서버의 EndPoint 도메인
    var baseURL: URL {
        return URL(string: "https://api.openweathermap.org")!
    }
    
    /// 도메인 뒤에 추가 될 path (/users, /documents, ...)
    var path: String {
        switch self {
        case .currentWeather:
            return "/data/2.5/weather"
        case .oneCall:
            return "/data/2.5/onecall"
        }
    }
    
    /// HTTP method(GET, POST)
    var method: Moya.Method {
        switch self {
        case .currentWeather:
            return Method.get
        case .oneCall:
            return Method.get
        }
    }
    
    /// request에 쓰일 파라미터
    var task: Task {
        switch self {
        case .currentWeather(let lat, let lon):
            let params: [String: Any] = [
                "lat": lat,
                "lon": lon,
                "appid": "886705b4c1182eb1c69f28eb8c520e20"
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .oneCall:
            return .requestPlain
        }
    }
    
    /// HTTP Headers
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
}
