//
//  LaunchModel.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 07.01.2023.
//

import Foundation

struct LaunchElement: Codable {
    let name: String
    let rocket: String?
    let success: Bool?
    let dateLocal: String?

    enum CodingKeys: String, CodingKey {
        case name
        case rocket
        case success
        case dateLocal = "date_local"
    }
}
