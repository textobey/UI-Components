//
//  WeatherInfo.swift
//  SwiftUI-C
//
//  Created by 이서준 on 2021/10/06.
//

import Foundation

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
