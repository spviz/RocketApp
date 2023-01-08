//
//  LaunchModel.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 07.01.2023.
//

import Foundation

struct LaunchPostStruct: Encodable {
    let query: Query
    
    struct Query: Encodable {
        let rocket: String
        let upcoming: Bool
    }
}

struct LaunchGetStruct: Codable {
    let docs: [Doc]
    let totalDocs, offset, limit, totalPages: Int
    let page, pagingCounter: Int
    let hasPrevPage, hasNextPage: Bool
    let nextPage: Int
}


struct Doc: Codable {
    let staticFireDateUTC: String?
    let staticFireDateUnix: Int?
    let net: Bool
    let window: Int
    let rocket: Rocket
    let success: Bool
    let failures: [Failure]
    let details: String?
    let ships, capsules, payloads: [String]
    let launchpad: Launchpad
    let flightNumber: Int
    let name, dateUTC: String
    let dateUnix: Int
    let dateLocal: Date
    let datePrecision: DatePrecision
    let upcoming: Bool
    let autoUpdate, tbd: Bool
    let id: String
}

enum DatePrecision: String, Codable {
    case hour = "hour"
}

// MARK: - Failure
struct Failure: Codable {
    let time: Int
    let altitude: Int?
    let reason: String
}


enum Launchpad: String, Codable {
    case the5E9E4501F509094Ba4566F84 = "5e9e4501f509094ba4566f84"
    case the5E9E4502F5090995De566F86 = "5e9e4502f5090995de566f86"
}

struct Patch: Codable {
    let small, large: String
}


enum Rocket: String, Codable {
    case the5E9D0D95Eda69955F709D1Eb = "5e9d0d95eda69955f709d1eb"
    case the5E9D0D95Eda69973A809D1Ec = "5e9d0d95eda69973a809d1ec"
}

