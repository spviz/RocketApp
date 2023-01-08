//
//  RocketModel.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 07.01.2023.
//

import Foundation

struct RocketElement: Decodable {
    let flickrImages: [URL]
    let name: String
    let height: Diameter
    let diameter: Diameter
    let mass: Mass
    let payloadWeights: [PayloadWeight]
    let firstFlight: String
    let country: String
    let costPerLaunch: Int
    let firstStage: FirstStage
    let secondStage: SecondStage
    let id: String
}

struct Diameter: Decodable {
    let meters, feet: Double?
}

struct FirstStage: Decodable {
    let engines: Int
    let fuelAmountTons: Double
    let burnTimeSEC: Int?
}

struct Mass: Decodable {
    let kg, lb: Int
}

struct PayloadWeight: Decodable {
    let id, name: String
    let kg, lb: Int
}

struct SecondStage: Decodable {
    let engines: Int
    let fuelAmountTons: Double
    let burnTimeSEC: Int?
}


