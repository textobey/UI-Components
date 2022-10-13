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
        struct Plugins {
            var plugins: [PluginType]
            
            init(plugins: [PluginType] = []) {
                self.plugins = plugins
            }
            
            func callAsFunction() -> [PluginType] { self.plugins }
        }
        
        static var provider: MoyaProvider<API.Wrapper> {
            // EndPoint 인스턴스에 맵핑하는 클로저, 해당 클로저로 인해서, Generic 타입을 지정하여 스위프트에 알릴 필요가 없음.
            let endpointClosure = { (target: API.Wrapper) -> Endpoint in
                // URL(target:) 모든 TargetType에서 URL을 만들수있는
                let url = URL(target: target).absoluteString
                return Endpoint(url: url, sampleResponseClosure: {
                    .networkResponse(200, target.sampleData)
                },
                method: target.method,
                task: target.task,
                httpHeaderFields: target.headers
                )
            }
            
            let plugins = Plugins(plugins: [])
            
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 3
            configuration.urlCredentialStorage = nil
            let session = Session(configuration: configuration)
            
            // Moya Provider 인스턴스 생성
            return MoyaProvider(endpointClosure: endpointClosure, session: session, plugins: plugins())
        }
    }
}

extension API {
    static let moya = MoyaWrapper.provider
    
    static var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        return decoder
    }
    
    /// Decodable Model을 파라미터로 받아서, Mapping하여 Observable로 리턴
    func request<T: Decodable>(with: T.Type) -> Observable<T> {
        return self.request()
            .map(T.self, using: API.jsonDecoder)
            .observe(on: MainScheduler.instance) // for UI
            .asObservable()
    }
    
    /// 실제 Moya request 구현부
    private func request(
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) -> Single<Response> {
        let endPoint = API.Wrapper(base: self)
        let requestString = "\(endPoint.method) \(endPoint.baseURL) \(endPoint.path)"
        
        return Self.moya.rx.request(endPoint)
            .filterSuccessfulStatusAndRedirectCodes()
            .catch(self.handleInternetConnection)
            .catch(self.handleTimeOut)
            .catch(self.handleREST)
            .do(onSuccess: { response in
                let requestContent = "🛰 SUCCESS: \(requestString) (\(response.statusCode))"
                print(requestContent, file, function, line)
            }, onError: { error in
                switch error {
                case APIError.requestTimeOut:
                    print(": APIError.requestTimeOut")
                case APIError.internetConnection:
                    print(": APIError.InternetConnection")
                case APIError.restError(let error, _, _):
                    guard let response = (error as? MoyaError)?.response else { break }
                    if let jsonObject = try? response.mapJSON(failsOnEmptyData: false) {
                        let errorDictionary = jsonObject as? [String: Any]
                        guard let key = errorDictionary?.first?.key else { return }
                        let message: String
                        if let description = errorDictionary?[key] as? String {
                          message = "🛰 FAILURE: \(requestString) (\(response.statusCode)\n\(key): \(description)"
                        } else if let description = (errorDictionary?[key] as? [String]) {
                          message = "🛰 FAILURE: \(requestString) (\(response.statusCode))\n\(key): \(description)"
                        } else if let rawString = String(data: response.data, encoding: .utf8) {
                          message = "🛰 FAILURE: \(requestString) (\(response.statusCode))\n\(rawString)"
                        } else {
                          message = "🛰 FAILURE: \(requestString) (\(response.statusCode)"
                        }
                        print(message)
                    }
                default:
                    break
                }
            }, onSubscribe: {
                let message = "REQUEST: \(requestString)"
                print(message, file, function, line)
            }).map {
                guard let value = try $0.mapString().data(using: .utf8) else { return $0 }
                let newResponse = Response(
                    statusCode: $0.statusCode,
                    data: value,
                    request: $0.request,
                    response: $0.response
                )
                return newResponse
            }
    }
}

/*static func request<T: Decodable, E>(
    type: T.Type,
    result: Result<Response, MoyaError>,
    completion: @escaping (Result<E, Error>) -> Void
) {
    switch result {
    case .success(let response):
        let data = try? response.map(T.self, using: API.jsonDecoder)
        completion(.success(data as! E))
    case .failure(let error):
        completion(.failure(error))
    }
}*/

/*static func request<T: Decodable>(_ api: API) -> Single<T> {
    return Single<T>.create { observer in
        let observable = api.request().map(T.self, using: API.jsonDecoder)
            .asObservable()
            .subscribe(onNext: { data in
                observer(.success(data))
            })
        return Disposables.create {
            observable.dispose()
        }
    }.observe(on: MainScheduler.instance)
}*/
