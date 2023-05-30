//
//  L.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 30.01.2023.
//

import Foundation

struct LaunchesInfo {
    let rocketName: String
    let launches: [LaunchItem]
}

struct LaunchItem: Equatable {
    let name: String
    let date: String
    let imageName: String
}
