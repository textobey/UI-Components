//
//  Weather.swift
//  SwiftUI-C
//
//  Created by 이서준 on 2021/10/06.
//

import Foundation

struct Weather : Codable {
    let id : Int?
    let main : String?
    let description : String?
    let icon : String?
}
