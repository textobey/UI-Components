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
    case filesUpload
}

/*
extension API: TargetType {
    /// The target's base `URL`.
    var baseURL: URL { getBaseURL() }

    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String { get }

    /// The HTTP method used in the request.
    var method: Moya.Method { get }

    /// Provides stub data for use in testing. Default is `Data()`.
    var sampleData: Data { get }

    /// The type of HTTP task to be performed.
    var task: Task { get }

    /// The type of validation to perform on the request. Default is `.none`.
    var validationType: ValidationType { get }

    /// The headers to be used in the request.
    var headers: [String: String]? { get }
}
*/

// Moya는 MoyaProvider<TargetType>으로 request를 수행하기 때문에, TargetType 프로토콜을 구현해야함
extension API: TargetType {
    /// 서버의 EndPoint 도메인
    var baseURL: URL { getBaseURL() }
    
    /// 도메인 뒤에 추가 될 path (/users, /documents, ...)
    var path: String { getPath() }
    
    /// HTTP method(GET, POST)
    var method: Moya.Method { getMethod() }
    
    /// request에 쓰일 파라미터
    var task: Task { getTask() }
    
    /// HTTP Headers
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
}
