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
        let rocket = Rocket(
            flickrImages: [URL(string: "https://imgur.com/DaCfMsj.jpg")!],
            name: "rocket.name",
            height: .init(meters: 1, feet: 1),
            diameter: .init(meters: 1, feet: 1),
            mass: .init(kg: 1, lb: 1),
            payloadWeights: [.init(kg: 1, lb: 1)],
            firstFlight: Date(timeIntervalSince1970: 0),
            country: "USA",
            costPerLaunch: 1000000,
            firstStage: .init(engines: 1, fuelAmountTons: 1, burnTimeSec: 1),
            secondStage: .init(engines: 1, fuelAmountTons: 1, burnTimeSec: 1),
            id: "878077"
        )
        mockNetwork.resultRockets = .success([rocket])

        presenter.getData()

//        XCTAssertNotNil(mockView.controllers)
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

        func present(rocketViewControllers: [RocketViewController]) {
            controllers = rocketViewControllers
        }

        func present(alert: Error) {
            alertError = alert
        }
    }
}
