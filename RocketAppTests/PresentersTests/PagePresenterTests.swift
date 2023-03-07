//
//  PagePresenterTests.swift
//  RocketAppTests
//
//  Created by Podgainy Sergei on 01.03.2023.
//

import XCTest
@testable import RocketApp

final class PagePresenterTests: XCTestCase {

    private var presenter: PagePresenter!
    private var mockView: PageMockView!
    private var mockNetwork: MockNetworkManager!
    private var pushLaunchesClosure: ((String, String) -> Void)!

    override func setUp() {
        super.setUp()
        mockNetwork = MockNetworkManager()
        mockView = PageMockView()
        presenter = PagePresenter(networkManager: mockNetwork)
        presenter.pageView = mockView
    }

    func testGetDataSuccessfully() {

        let expectation = XCTestExpectation(description: #function)
        let rocket = Rocket(
            flickrImages: [URL(string: TestConstants.url.rawValue)!],
            name: TestConstants.rocketName.rawValue,
            height: .init(meters: 20, feet: 20),
            diameter: .init(meters: 20, feet: 20),
            mass: .init(kg: 20, lb: 20),
            payloadWeights: [.init(kg: 20, lb: 20)],
            firstFlight: Date(timeIntervalSince1970: 0),
            country: TestConstants.country.rawValue,
            costPerLaunch: 1000000,
            firstStage: .init(engines: 20, fuelAmountTons: 20, burnTimeSec: 20),
            secondStage: .init(engines: 20, fuelAmountTons: 20, burnTimeSec: 20),
            id: TestConstants.rocketId.rawValue
        )

        mockNetwork.resultRockets = .success([rocket])
        mockView.expectation = expectation
        presenter.getData()

        wait(for: [expectation], timeout: 3)

        XCTAssertEqual(mockView.controllers?.count, 1)
    }

    func testGetDataWithError() {
        mockNetwork.resultRockets = .failure(NetworkError.serverError)
        presenter.getData()
        XCTAssertNotNil(mockView.alertError)
    }
}

// MARK: - MockView

private extension PagePresenterTests {
    final class PageMockView: PageViewProtocol {

        var controllers: [RocketViewController]?
        var alertError: Error?
        var expectation: XCTestExpectation?

        func present(rocketViewControllers: [RocketViewController]) {
            controllers = rocketViewControllers
            expectation!.fulfill()
        }

        func present(alert: Error) {
            alertError = alert
        }
    }
}
