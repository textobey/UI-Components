//
//  API+BaseURL.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/01/20.
//

import Foundation

extension API {
    func getBaseURL() -> URL {
        return URL(string: "https://api.openweathermap.org")!
    }
}
