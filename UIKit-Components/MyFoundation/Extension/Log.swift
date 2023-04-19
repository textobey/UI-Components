//
//  Log.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/12/14.
//

import Foundation

func print(_ object: Any) {
    #if DEBUG
        Swift.print(object)
    #endif
}

/// Helpers for the Logger
class Log {
    // 데이터포맷 세팅
    static var dateFormat = "yyyy-MM-dd hh:mm:ssSSS"
    static var dateFormatter = DateFormatter().then {
        $0.dateFormat = dateFormat
        $0.locale = Locale.current
        $0.timeZone = TimeZone.current
    }
    // Bulid Setting이 DEBUG일 경우에만 true를 return.
    private static var isLoggingEnabled: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    /// 파일 경로에서 파일 이름을 추출합니다.
    ///
    /// - Parameter filePath: 번들의 전체 파일 경로
    /// - Returns: 확장명이 있는 파이 이름
    private class func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
    
    // MARK: - Logging Methods
    
    /// 콘솔에 prefix [‼️] 접두사가 붙은 오류 메시지를 기록합니다.
    ///
    /// - Parameters:
    ///   - object: 기록할 개체 또는 오류 메시지
    ///   - filename: 파일 이름
    ///   - line: 로그가 수행되는 파일의 라인 번호
    ///   - column: 로그 메시지의 column 번호
    ///   - funcName: 로그가 수행되는 함수의 이름
    class func e(_ object: Any,
                 fileName: String = #file,
                 line    : Int = #line,
                 column  : Int = #column,
                 funcName: String = #function) {
        if isLoggingEnabled {
            print("\(Date().toString()) \(LogEvent.e.rawValue)[\(sourceFileName(filePath: fileName))]: \(line) \(column) \(funcName) -> \(object)")
        }
    }
    
    class func i(_ object: Any,
                 fileName: String = #file,
                 line    : Int = #line,
                 column  : Int = #column,
                 funcName: String = #function) {
        if isLoggingEnabled {
            print("\(Date().toString()) \(LogEvent.i.rawValue)[\(sourceFileName(filePath: fileName))]: \(line) \(column) \(funcName) -> \(object)")
        }
    }
    
    class func d(_ object: Any,
                 fileName: String = #file,
                 line    : Int = #line,
                 column  : Int = #column,
                 funcName: String = #function) {
        if isLoggingEnabled {
            print("\(Date().toString()) \(LogEvent.d.rawValue)[\(sourceFileName(filePath: fileName))]: \(line) \(column) \(funcName) -> \(object)")
        }
    }
    
    class func v(_ object: Any,
                 fileName: String = #file,
                 line    : Int = #line,
                 column  : Int = #column,
                 funcName: String = #function) {
        if isLoggingEnabled {
            print("\(Date().toString()) \(LogEvent.v.rawValue)[\(sourceFileName(filePath: fileName))]: \(line) \(column) \(funcName) -> \(object)")
        }
    }
    
    class func w(_ object: Any,
                 fileName: String = #file,
                 line    : Int = #line,
                 column  : Int = #column,
                 funcName: String = #function) {
        if isLoggingEnabled {
            print("\(Date().toString()) \(LogEvent.w.rawValue)[\(sourceFileName(filePath: fileName))]: \(line) \(column) \(funcName) -> \(object)")
        }
    }
    
    class func s(_ object: Any,
                 fileName: String = #file,
                 line    : Int = #line,
                 column  : Int = #column,
                 funcName: String = #function) {
        if isLoggingEnabled {
            print("\(Date().toString()) \(LogEvent.s.rawValue)[\(sourceFileName(filePath: fileName))]: \(line) \(column) \(funcName) -> \(object)")
        }
    }
}

extension Log {
    enum LogEvent: String {
        case e = "[‼️]" // error
        case i = "[ℹ️]" // info
        case d = "[💬]" // debug
        case v = "[🔬]" // verbose
        case w = "[⚠️]" // warning
        case s = "[🔥]" // severe
    }
}
