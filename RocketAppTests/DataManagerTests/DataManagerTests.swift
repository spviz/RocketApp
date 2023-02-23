//
//  DataManagerTests.swift
//  RocketAppTests
//
//  Created by Podgainy Sergei on 17.02.2023.
//

import XCTest
@testable import RocketApp

final class DataManagerTests: XCTestCase {

    private var dataManager: DataManagerProtocol!
    private var userDefaults: UserDefaults!

    override func setUp() {
        super.setUp()

        userDefaults = UserDefaults(suiteName: #file)
        userDefaults.removePersistentDomain(forName: #file)
        dataManager = DataManager(userDefaults: userDefaults)
    }

    func testSetSettingsWorks() {

        dataManager.setSettings(for: .height, selectedUnit: .metric)
        dataManager.setSettings(for: .diameter, selectedUnit: .imperial)
        dataManager.setSettings(for: .mass, selectedUnit: .metric)
        dataManager.setSettings(for: .payloadWeights, selectedUnit: .imperial)

        XCTAssertEqual(dataManager.getSelectedUnit(for: .height), .metric)
        XCTAssertEqual(dataManager.getSelectedUnit(for: .diameter), .imperial)
        XCTAssertEqual(dataManager.getSelectedUnit(for: .mass), .metric)
        XCTAssertEqual(dataManager.getSelectedUnit(for: .payloadWeights), .imperial)
    }
}
