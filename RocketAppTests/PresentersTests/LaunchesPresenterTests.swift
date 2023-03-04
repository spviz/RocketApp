//
//  LaunchesPresenterTests.swift
//  RocketAppTests
//
//  Created by Podgainy Sergei on 28.02.2023.
//

import XCTest
@testable import RocketApp

final class LaunchesPresenterTests: XCTestCase {

    struct ActualResult {
        let name: String
        let imageName: String
        let date: String
    }

    private var presenter: LaunchesPresenter!
    private var mockView = LaunchesMockView()
    private var mockNetwork = MockNetworkManager()

    override func setUp() {
        super.setUp()
        let (rocketId, rocketName) = ("rocketId", "rocketName")
        presenter = LaunchesPresenter(selectedRocketID: rocketId, selectedRocketName: rocketName, networkManager: mockNetwork)
        presenter.launchesView = mockView
    }

    func testGetDataSuccessfully() {

        let launch = Launch(docs: [.init(
            rocket: "rocket",
            success: true,
            name: "launchName",
            dateUtc: Date(timeIntervalSince1970: 0)
        )])
        mockNetwork.resultLaunch = .success(launch)
        //        mockNetwork.launches =

        presenter.getData()

        let actualLaunchItem = LaunchItem(name: "launchName", date: "1 января, 1970", imageName: "rocket_true")
        XCTAssertEqual(mockView.launchesInfo?.rocketName, "rocketName")
        XCTAssertEqual(mockView.launchesInfo?.launches[0], actualLaunchItem)
    }

    func testGetDataWithError() {
        mockNetwork.resultLaunch = .failure(NetworkError.serverError)
        presenter.getData()
        XCTAssertNotNil(mockView.alertError)
    }
}

// MARK: - MockView

private extension LaunchesPresenterTests {
    final class LaunchesMockView: LaunchesViewProtocol {

        var launchesInfo: LaunchesInfo?
        var alertError: Error?

        func present(launchesInfo: LaunchesInfo) {
            self.launchesInfo = launchesInfo
        }

        func present(alert: Error) {
            self.alertError = alert
        }
    }

}
