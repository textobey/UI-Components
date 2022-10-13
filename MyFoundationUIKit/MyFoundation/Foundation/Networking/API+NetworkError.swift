//
//  API+NetworkError.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/01/26.
//

import Moya
import RxSwift
import Alamofire
import Foundation

enum APIError: Error {
    case empty
    case requestTimeOut(Error)
    case internetConnection(Error)
    case restError(Error, statusCode: Int? = nil, errorCode: String? = nil)
    case apiError(error: Error, statusCode: Int? = nil, stateCode: APIError.StateCode)
    
    var statusCode: Int? {
        switch self {
        case .restError(_, let statusCode, _):
            return statusCode
        case .apiError(_, let statusCode, _):
            return statusCode
        default:
            return nil
        }
    }
    
    var errorCodes: [String] {
        switch self {
        case .restError(_, _, let errorCode):
            return Array(errorCode ?? "").compactMap { String($0) }
        case .apiError(_, _, let stateCode):
            return [stateCode.rawValue]
        default:
            return []
        }
    }
    
    var isNoNetwork: Bool {
        switch self {
        case .requestTimeOut(let error):
            fallthrough
        case .restError(let error, _, _):
            return API.isNotConnection(error: error) || API.isLostConnection(error: error)
        case .apiError(let error, _, _):
            return API.isNotConnection(error: error) || API.isLostConnection(error: error)
        case .internetConnection(_):
            return true
        default:
            return false
        }
    }
}

extension TargetType {
    /// error (fallthrough)-> AFError (fallthrough)-> URLError
    static func convertToURLError(_ error: Error) -> URLError? {
        switch error {
        case let MoyaError.underlying(afError as AFError, _):
            fallthrough
        case let afError as AFError:
            return afError.underlyingError as? URLError
        case let MoyaError.underlying(urlError as URLError, _):
            fallthrough
        case let urlError as URLError:
            return urlError
        default:
            return nil
        }
    }
    
    /// isConnectedToInternet
    static func isNotConnection(error: Error) -> Bool {
        Self.convertToURLError(error)?.code == .notConnectedToInternet
    }
    
    static func isLostConnection(error: Error) -> Bool {
        switch error {
        case let AFError.sessionTaskFailed(error: posixError as POSIXError)
            where posixError.code == .ECONNABORTED: // SW에 의한 연결 중단
            break
        case let MoyaError.underlying(urlError as URLError, _):
            fallthrough
        case let urlError as URLError:
            // 클라이언트 혹은 서버와의 연결 끊김
            guard urlError.code == URLError.networkConnectionLost else { fallthrough }
            break
        default:
            return false
        }
        return true
    }
}

extension API {
    func handleInternetConnection<T: Any>(error: Error) throws -> Single<T> {
        guard let urlError = Self.convertToURLError(error), Self.isNotConnection(error: error) else { throw error }
        throw APIError.internetConnection(urlError)
    }
    
    func handleTimeOut<T: Any>(error: Error) throws -> Single<T> {
        guard let urlError = Self.convertToURLError(error), urlError.code == .timedOut else { throw error }
        throw APIError.requestTimeOut(urlError)
    }
    
    func handleREST<T: Any>(error: Error) throws -> Single<T> {
        guard error is APIError else {
            throw APIError.restError(
                error,
                statusCode: (error as? MoyaError)?.response?.statusCode,
                errorCode: (try? (error as? MoyaError)?.response?.mapJSON() as? [String: Any])?["code"] as? String
            )
        }
        throw error
    }
    
    func handleAPIError<T: Any>(error: Error) throws -> Single<T> {
        guard error is APIError else {
            throw APIError.apiError(
                error: error,
                statusCode:
                    (error as? MoyaError)?.response?.statusCode,
                stateCode: APIError
                    .getMatchStateCode(errorCode: (try? (error as? MoyaError)?.response?.mapJSON() as? [String: Any])?["code"] as? String)
            )
        }
        throw error
    }
}
