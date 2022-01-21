//
//  API+Request.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/01/20.
//

import Foundation
import Moya
import RxMoya
import RxSwift

extension API {
    struct Wrapper: TargetType {
        let base: API
        
        var baseURL: URL { base.baseURL }
        var path: String { base.path }
        var method: Moya.Method { base.method }
        var sampleData: Data { base.sampleData }
        var task: Task { base.task }
        var headers: [String : String]? { base.headers }
    }
    
    private enum MoyaWrapper {
        static var provider: MoyaProvider<API.Wrapper> {
            return MoyaProvider<API.Wrapper>(endpointClosure: { target in
                MoyaProvider.defaultEndpointMapping(for: target)
            })
        }
    }
}

extension API {
    static let moya = MoyaWrapper.provider
    
    static var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        return decoder
    }
    
    func request<T: Decodable>(file: StaticString = #file, function: StaticString = #function, line: UInt = #line) -> Single<T> {
        
        return Single.create { observer in
            let endPoint = API.Wrapper(base: self)
            let requestString = "\(endPoint.method) \(endPoint.baseURL) \(endPoint.path)"
            
            return Self.moya.rx.request(endPoint)
                .filterSuccessfulStatusCodes()
                .do(onSuccess: { response in
                    let requestContent = "🛰 SUCCESS: \(requestString) (\(response.statusCode))"
                    print(requestContent, file, function, line)
                }, onError: { error in
                    print(error)
                }).map {
                    let jsonString = try $0.mapString()
                    guard let value = jsonString.data(using: .utf8) else { return $0 }
                    let newResponse = Response(statusCode: $0.statusCode, data: value, request: $0.request, response: $0.response)
                    return newResponse
                }
                .map(T.self, using: API.jsonDecoder)
                .map { result in
                    
                }
        }
    }
}
