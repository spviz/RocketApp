//
//  LaunchesPresenterTests.swift
//  RocketAppTests
//
//  Created by Podgainy Sergei on 28.02.2023.
//

import XCTest
@testable import RocketApp

final class LaunchesPresenterTests: XCTestCase {

    private var presenter: LaunchesPresenter!
    private var mockView = LaunchesMockView()
    private var mockNetwork = MockNetworkManager()

    override func setUp() {
        super.setUp()
        presenter = LaunchesPresenter(
            selectedRocketID: TestConstants.rocketId.rawValue,
            selectedRocketName: TestConstants.rocketName.rawValue,
            networkManager: mockNetwork)
        presenter.launchesView = mockView
    }

    func testGetDataSuccessfully() {

        let launch = Launch(docs: [.init(
            rocket: TestConstants.rocketName.rawValue,
            success: true,
            name: TestConstants.launchName.rawValue,
            dateUtc: Date(timeIntervalSince1970: 0)
        )])

        let actualLaunchItem = [LaunchItem(
            name: TestConstants.launchName.rawValue,
            date: TestConstants.date.rawValue,
            imageName: TestConstants.imageName.rawValue
        )]

        mockNetwork.resultLaunch = .success(launch)
        presenter.getData()

        XCTAssertEqual(mockView.launchesInfo?.rocketName, TestConstants.rocketName.rawValue)
        XCTAssertEqual(mockView.launchesInfo?.launches, actualLaunchItem)
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
