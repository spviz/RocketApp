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

    private enum MockAPI {
        static let rockets = Bundle.main.url(forResource: "rockets", withExtension: "json")
        static let rocketsFail = Bundle.main.url(forResource: "rocketsFail", withExtension: "json")
        static let launches = Bundle.main.url(forResource: "launches", withExtension: "json")
        static let launchesFail = Bundle.main.url(forResource: "launchesFail", withExtension: "json")
    }

    private var networkManager: NetworkManagerProtocol!
    private var dateFormatter: DateFormatter!

    override func setUp() {
        super.setUp()

        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)
        networkManager = NetworkManager(session: session)
        dateFormatter = DateFormatter()
    }
}

// MARK: - getRockets method tests

extension NetworkManagerTests {
    func testGetRocketsParsedSuccessfully() {

        guard let rocketsUrl = URL(string: API.rockets) else { return }
        guard let rocketsMockDataURL = MockAPI.rockets else { return }
        guard let rocketsMockData = try? Data(contentsOf: rocketsMockDataURL) else { return }

        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let firstFlightDate = dateFormatter.date(from: "2006-03-24") else { return }

        MockURLProtocol.mockURLs[rocketsUrl] = (
            error: nil,
            data: rocketsMockData,
            response: nil
        )

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
        XCTAssertEqual(actualRockets[0].firstFlight, firstFlightDate)
        XCTAssertEqual(actualRockets[0].costPerLaunch, 6700000)
        XCTAssertEqual(actualRockets[0].country, "Republic of the Marshall Islands")
    }

    func testGetRocketsFailWithDecodingError() {

        guard let rocketsUrl = URL(string: API.rockets) else { return }
        guard let rocketsMockDataURL = MockAPI.rocketsFail else { return }
        guard let rocketsMockData = try? Data(contentsOf: rocketsMockDataURL) else { return }

        MockURLProtocol.mockURLs[rocketsUrl] = (
            error: nil,
            data: rocketsMockData,
            response: nil
        )

        let expectation = expectation(description: #function)

        networkManager.getRockets { result in
            switch result {
            case .success:
                XCTFail("\(#function) unexpected result")
            case let .failure(error):
                guard let error = error as? NetworkError else { return }
                XCTAssertEqual(error.description, "decodingError")
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 5)
    }

    func testGetRocketsFailWithServerError() {

        guard let rocketsUrl = URL(string: API.rockets) else { return }
        guard let rocketsMockDataURL = MockAPI.rockets else { return }
        guard let rocketsMockData = try? Data(contentsOf: rocketsMockDataURL) else { return }

        MockURLProtocol.mockURLs[rocketsUrl] = (
            error: MockError(),
            data: rocketsMockData,
            response: nil
        )

        let expectation = expectation(description: #function)

        networkManager.getRockets { result in
            switch result {
            case .success:
                XCTFail("\(#function) unexpected result")
            case let .failure(error):
                guard let error = error as? NetworkError else { return }
                XCTAssertEqual(error.description, "serverError")
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 5)
    }
}

// MARK: - getLaunches method tests

extension NetworkManagerTests {
    func testGetLaunchesParsedSuccessfully() {

        guard let launchesUrl = URL(string: API.launches) else { return }
        guard let launchesMockDataURL = MockAPI.launches else { return }
        guard let launchesMockData = try? Data(contentsOf: launchesMockDataURL) else { return }

        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        guard let firstFlightDate = dateFormatter.date(from: "2009-07-13T03:35:00.000Z") else { return }

        MockURLProtocol.mockURLs[launchesUrl] = (
            error: nil,
            data: launchesMockData,
            response: nil
        )

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
        XCTAssertEqual(actualLaunches[0].dateUtc, firstFlightDate)
        XCTAssertEqual(actualLaunches[0].rocket, "5e9d0d95eda69955f709d1eb")
        XCTAssertEqual(actualLaunches[0].success, true)
    }

    func testGetLaunchesFailWithDecodingError() {

        guard let launchesUrl = URL(string: API.launches) else { return }
        guard let launchesMockDataURL = MockAPI.launchesFail else { return }
        guard let launchesMockData = try? Data(contentsOf: launchesMockDataURL) else { return }

        MockURLProtocol.mockURLs[launchesUrl] = (
            error: nil,
            data: launchesMockData,
            response: nil
        )

        let expectation = expectation(description: #function)

        networkManager.getLaunches(for: "5e9d0d95eda69955f709d1eb") { result in
            switch result {
            case .success:
                XCTFail("\(#function) unexpected result")
            case let .failure(error):
                guard let error = error as? NetworkError else { return }
                XCTAssertEqual(error.description, "decodingError")
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 5)
    }

    func testGetLaunchesFailWithServerError() {

        guard let launchesUrl = URL(string: API.launches) else { return }
        guard let launchesMockDataURL = MockAPI.launches else { return }
        guard let launchesMockData = try? Data(contentsOf: launchesMockDataURL) else { return }

        MockURLProtocol.mockURLs[launchesUrl] = (
            error: MockError(),
            data: launchesMockData,
            response: nil
        )

        let expectation = expectation(description: #function)

        networkManager.getLaunches(for: "5e9d0d95eda69955f709d1eb") { result in
            switch result {
            case .success:
                XCTFail("\(#function) unexpected result")
            case let .failure(error):
                guard let error = error as? NetworkError else { return }
                XCTAssertEqual(error.description, "serverError")
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 5)
    }
}
