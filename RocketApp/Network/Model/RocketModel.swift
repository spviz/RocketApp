//
//  RocketModel.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 07.01.2023.
//

import Foundation

struct Rocket: Decodable {
    let flickrImages: [URL]
    let name: String
    let height: Diameter
    let diameter: Diameter
    let mass: Mass
    let payloadWeights: [PayloadWeight]
    let firstFlight: Date
    let country: String
    let costPerLaunch: Int
    let firstStage: FirstStage
    let secondStage: SecondStage
    let id: String
}

extension Rocket {
    struct Diameter: Decodable {
        let meters, feet: Double
    }

    struct FirstStage: Decodable {
        let engines: Int
        let fuelAmountTons: Double
        let burnTimeSec: Int?
    }

    struct Mass: Decodable {
        let kg, lb: Int
    }

    struct PayloadWeight: Decodable {
        let kg, lb: Int
    }

    struct SecondStage: Decodable {
        let engines: Int
        let fuelAmountTons: Double
        let burnTimeSec: Int?
    }
}
