//
//  RocketModel.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 07.01.2023.
//

import Foundation

struct RocketElement: Codable {
    
    //Image
    let flickrImages: [String]
    //Name
    let name: String
    //Block 1
    let height: Diameter
    let diameter: Diameter
    let mass: Mass
    let payloadWeights: [PayloadWeight]
    //Block 2
    let firstFlight: String
    let country: String
    let costPerLaunch: Int
    //Block 3
    let firstStage: FirstStage
    //Block 4
    let secondStage: SecondStage
    
    //Rocket id
    let id: String

    enum CodingKeys: String, CodingKey {
        case height, diameter, mass, name, country
        case firstStage = "first_stage"
        case secondStage = "second_stage"
        case payloadWeights = "payload_weights"
        case flickrImages = "flickr_images"
        case costPerLaunch = "cost_per_launch"
        case firstFlight = "first_flight"
        case id
    }
}

struct Diameter: Codable {
    let meters, feet: Double?
}

struct FirstStage: Codable {
    let engines: Int
    let fuelAmountTons: Double
    let burnTimeSEC: Int?

    enum CodingKeys: String, CodingKey {
        case engines
        case fuelAmountTons = "fuel_amount_tons"
        case burnTimeSEC = "burn_time_sec"
    }
}

struct Mass: Codable {
    let kg, lb: Int
}


struct PayloadWeight: Codable {
    let id, name: String
    let kg, lb: Int
}


struct SecondStage: Codable {
    let engines: Int
    let fuelAmountTons: Double
    let burnTimeSEC: Int?

    enum CodingKeys: String, CodingKey {
        case engines
        case fuelAmountTons = "fuel_amount_tons"
        case burnTimeSEC = "burn_time_sec"
    }
}


