//
//  NetworkManagerTests.swift
//  RocketAppTests
//
//  Created by Podgainy Sergei on 12.02.2023.
//

import XCTest
@testable import RocketApp

final class NetworkManagerTests: XCTestCase {

    struct MockError: Error {

    }

    private var networkManager: NetworkManagerProtocol!
    private var dateFormatter: DateFormatter!
    private let rocketsUrl = URL(string: API.rockets)!
    private let launchesUrl = URL(string: API.launches)!

    override func setUp() {
        super.setUp()

        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)
        networkManager = NetworkManager(session: session)
        dateFormatter = DateFormatter()
    }

    func testGetRocketsParsedSuccessfully() {

        let rocketsMockData = Bundle.main.getJSON(filename: "rockets")

        MockURLProtocol.mockURLs[rocketsUrl] = (error: nil, data: rocketsMockData, response: nil)

        let expectation = expectation(description: #function)
        var actualRockets = [Rocket]()

        networkManager.getRockets { result in
            switch result {
            case let .success(rockets):
                actualRockets = rockets
                expectation.fulfill()
            case let .failure(error):
                XCTFail(error.localizedDescription)
            }
        }

        wait(for: [expectation], timeout: 5)

        XCTAssertEqual(actualRockets[0].name, "Falcon 1")
        XCTAssertEqual("\(actualRockets[0].firstFlight)", "2006-03-23 21:00:00 +0000")
        XCTAssertEqual(actualRockets[0].costPerLaunch, 6700000)
        XCTAssertEqual(actualRockets[0].country, "Republic of the Marshall Islands")
    }

    func testGetRocketsFailWithDecodingError() {

        let rocketsMockData = Bundle.main.getJSON(filename: "rocketsFail")

        MockURLProtocol.mockURLs[rocketsUrl] = (error: nil, data: rocketsMockData, response: nil)

        let expectation = expectation(description: #function)

        networkManager.getRockets { result in
            switch result {
            case .success:
                XCTFail("\(#function) unexpected result")
            case let .failure(error):
                guard let error = error as? NetworkError else { return }
                XCTAssertEqual(error, NetworkError.decodingError)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 5)
    }

    func testGetRocketsFailWithServerError() {

        let rocketsMockData = Bundle.main.getJSON(filename: "rockets")

        MockURLProtocol.mockURLs[rocketsUrl] = (error: MockError(), data: rocketsMockData, response: nil)

        let expectation = expectation(description: #function)

        networkManager.getRockets { result in
            switch result {
            case .success:
                XCTFail("\(#function) unexpected result")
            case let .failure(error):
                guard let error = error as? NetworkError else { return }
                XCTAssertEqual(error, NetworkError.serverError)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 5)
    }

    func testGetLaunchesParsedSuccessfully() {

        let launchesMockData = Bundle.main.getJSON(filename: "launches")

        MockURLProtocol.mockURLs[launchesUrl] = (error: nil, data: launchesMockData, response: nil)

        let expectation = expectation(description: #function)
        var actualLaunches = [Launch.Doc]()

        networkManager.getLaunches(for: "5e9d0d95eda69955f709d1eb") { result in
            switch result {
            case let .success(launches):
                actualLaunches = launches.docs
                expectation.fulfill()
            case let .failure(error):
                XCTFail(error.localizedDescription)
            }
        }

        wait(for: [expectation], timeout: 5)

        XCTAssertEqual(actualLaunches[0].name, "RazakSat")
        XCTAssertEqual("\(actualLaunches[0].dateUtc)", "2009-07-13 03:35:00 +0000")
        XCTAssertEqual(actualLaunches[0].rocket, "5e9d0d95eda69955f709d1eb")
        XCTAssertEqual(actualLaunches[0].success, true)
    }

    func testGetLaunchesFailWithDecodingError() {

        let launchesMockData = Bundle.main.getJSON(filename: "launchesFail")

        MockURLProtocol.mockURLs[launchesUrl] = (error: nil, data: launchesMockData, response: nil)

        let expectation = expectation(description: #function)

        networkManager.getLaunches(for: "5e9d0d95eda69955f709d1eb") { result in
            switch result {
            case .success:
                XCTFail("\(#function) unexpected result")
            case let .failure(error):
                guard let error = error as? NetworkError else { return }
                XCTAssertEqual(error, NetworkError.decodingError)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 5)
    }

    func testGetLaunchesFailWithServerError() {

        let launchesMockData = Bundle.main.getJSON(filename: "launches")

        MockURLProtocol.mockURLs[launchesUrl] = (error: MockError(), data: launchesMockData, response: nil)

        let expectation = expectation(description: #function)

        networkManager.getLaunches(for: "5e9d0d95eda69955f709d1eb") { result in
            switch result {
            case .success:
                XCTFail("\(#function) unexpected result")
            case let .failure(error):
                guard let error = error as? NetworkError else { return }
                XCTAssertEqual(error, NetworkError.serverError)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 5)
    }
}
