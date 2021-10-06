//
//  ListModel.swift
//  SwiftUI-C
//
//  Created by 이서준 on 2021/10/06.
//

import Foundation

struct ListModel: Codable, Identifiable {
    let id : Int?
    let name : String?
    let coord : Coord?
    let main : Main?
    let dt : Int?
    let wind : Wind?
    let sys : Sys?
    let rain : String?
    let snow : String?
    let clouds : Clouds?
    let weather : [Weather]?
}
