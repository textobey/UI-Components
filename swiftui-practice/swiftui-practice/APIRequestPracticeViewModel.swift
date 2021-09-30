//
//  APIRequestPracticeViewModel.swift
//  swiftui-practice
//
//  Created by 이서준 on 2021/09/30.
//

import Foundation
import Combine
import SwiftUI

final class APIRequestPracticeViewModel: ObservableObject {
    private var cancellable = Set<AnyCancellable>()
    private var weatherSubject = PassthroughSubject<WeatherInfo?, Never>()
    
    init() {
        bindOutputs()
    }
    
    enum Input {
        case appear
    }
    
    func apply(_ input: Input) {
        switch input {
        case .appear:
            getWeatherAPIResponse()
        }
    }
    
    @Published var weatherResponse: WeatherInfo?
    
    func bindOutputs() {
        weatherSubject
            .assign(to: \.weatherResponse, on: self)
            .store(in: &cancellable)
    }
    
    func getWeatherAPIResponse() {
        let baseUrl = "http://api.openweathermap.org/data/2.5/weather?"
        let appid = "e56874130e02399e6fa15ff39256d818&units=metric"
        guard let url = URL(string: baseUrl + "q=seoul,deajeon,deagu,busan" + "&appid=\(appid)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let weatherInfo = try? JSONDecoder().decode(WeatherInfo.self, from: data) {
                DispatchQueue.main.async {
                    print(weatherInfo)
                    self.weatherSubject.send(weatherInfo)
                }
            }
        }.resume()
    }
    
    func switching(_ weather: String) -> String {
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

enum WeatherCondition: String {
    case sunny = "☀️"
    case rain = "🌧"
    case clouds = "☁️"
    case snow = "🌨"
}

struct WeatherInfo : Codable {
    let coord : Coord?
    let weather : [Weather]?
    let base : String?
    let main : Main?
    let visibility : Int?
    let wind : Wind?
    let clouds : Clouds?
    let dt : Int?
    let sys : Sys?
    let timezone : Int?
    let id : Int?
    let name : String?
    let cod : Int?
}

struct Weather : Codable {
    let id : Int?
    let main : String?
    let description : String?
    let icon : String?
}

struct Main : Codable {
    let temp : Double?
    let feels_like : Double?
    let temp_min : Double?
    let temp_max : Double?
    let pressure : Int?
    let humidity : Int?
}

struct Sys : Codable {
    let type : Int?
    let id : Int?
    let country : String?
    let sunrise : Int?
    let sunset : Int?
}

struct Wind : Codable {
    let speed : Double?
    let deg : Int?
}

struct Coord : Codable {
    let lon : Double?
    let lat : Double?
}

struct Clouds : Codable {
    let all : Int?
}

