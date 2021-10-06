//
//  APIService.swift
//  SwiftUI-C
//
//  Created by 이서준 on 2021/10/05.
//

import Foundation

enum WeatherCondition: String {
    case sunny = "☀️"
    case rain = "🌧"
    case clouds = "☁️"
    case snow = "🌨"
}

final class APIService {
    static let `shared` = APIService()
    
    //private let baseUrl = "http://api.openweathermap.org/data/2.5/weather?"
    private let baseUrl = "http://api.openweathermap.org/data/2.5/find?"
    private let parameter = "lat=37.33&lon=126.58&cnt=50"
    private let appid = "e56874130e02399e6fa15ff39256d818&units=metric"
    
    func weathers(completionHandler: @escaping (Find?, Error?) -> Void) {
        let url = URL(string: baseUrl + parameter + "&appid=\(appid)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error -> Void in
            if let data = data, let find = try? JSONDecoder().decode(Find.self, from: data) {
                completionHandler(find, nil)
                return
            } else {
                completionHandler(nil, error)
                return
            }
        }
        // Task는 일시정지 상태이기 때문에, resume()을 통해 다시 실행시켜주어야함.
        task.resume()
    }
    
    private func switching(_ weather: String) -> String {
        switch weather {
        case "Clear":
            return WeatherCondition.sunny.rawValue
        case "Rain", "Mist", "Drizzle":
            return WeatherCondition.rain.rawValue
        case "Clouds", "Haze":
            return WeatherCondition.clouds.rawValue
        default:
            return WeatherCondition.snow.rawValue
        }
    }
}
