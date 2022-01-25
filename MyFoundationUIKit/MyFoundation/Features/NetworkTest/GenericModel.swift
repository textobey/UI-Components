//
//  GenericModel.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/01/25.
//

import Foundation
import AnyCodable

struct GenericModel: Codable {
    var result: AnyCodable
    let code: String?
    let desc: String?
}
