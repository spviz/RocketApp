//
//  MockNetworkManager.swift
//  RocketAppTests
//
//  Created by Podgainy Sergei on 01.03.2023.
//

import Foundation
@testable import RocketApp

final class MockNetworkManager: NetworkManagerProtocol {

    var resultRockets: Result<[Rocket], Error>?
    var resultLaunch: Result<Launch, Error>?

    func getRockets(completionHandler: @escaping (Result<[Rocket], Error>) -> Void) {
        completionHandler(resultRockets!)
    }

    func getLaunches(for rocketID: String, completionHandler: @escaping (Result<Launch, Error>) -> Void) {
        completionHandler(resultLaunch!)
    }
}
