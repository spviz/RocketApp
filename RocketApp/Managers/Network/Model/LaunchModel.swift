//
//  LaunchModel.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 07.01.2023.
//

import Foundation

struct Launch: Decodable {
    let docs: [Doc]
}

extension Launch {
    struct Doc: Decodable {
        let rocket: String
        let success: Bool?
        let name: String
        let dateUtc: Date
    }
}
