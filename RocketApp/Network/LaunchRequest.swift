//
//  LaunchRequest.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 08.01.2023.
//

import Foundation

struct LaunchRequest: Encodable {
    let query: Query
}

extension LaunchRequest {
    struct Query: Encodable {
        let rocket: String
        let upcoming: Bool
    }
}
