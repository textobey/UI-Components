//
//  API+Task.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/01/20.
//

import Foundation
import Moya

extension API {
    func getTask() -> Task {
        switch self {
        case .filesUpload:
            return .requestPlain
        default:
            return .requestParameters(parameters: objectMapper(self), encoding: parameterEncodingForMethod())
        }
    }
}

extension API {
    func objectMapper(_ targetType: API) -> [String: Any] {
        let mirror: Mirror = Mirror(reflecting: targetType)
        var dictionary: Dictionary = [String: Any]()
        
        // create dictionary data using the mirror.
        mirror.children.forEach { (_, api) in
            let task = Mirror(reflecting: api)
            task.children.forEach { (key, value) in
                if value is AnyHashable {
                    dictionary.updateValue(value, forKey: key ?? "key")
                } else if value is Encodable {
                    dictionary = (value as! Encodable).toDictionary()
                }
            }
        }
        // appid is mandatory
        dictionary.updateValue("886705b4c1182eb1c69f28eb8c520e20", forKey: "appid")
        
        return dictionary
    }
    
    func parameterEncodingForMethod() -> ParameterEncoding {
        return self.method == .get ? URLEncoding.default : JSONEncoding.default
    }
}

extension Encodable {
    func toDictionary() -> [String: Any] {
        do {
            let jsonEncoder = JSONEncoder()
            let encodedData = try jsonEncoder.encode(self)
            
            let dictionaryData = try JSONSerialization.jsonObject(with: encodedData, options: .fragmentsAllowed) as? [String: Any]
            return dictionaryData ?? [:]
        } catch {
            return [:]
        }
    }
}
