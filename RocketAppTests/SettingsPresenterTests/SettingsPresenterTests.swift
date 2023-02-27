//
//  SettingsPresenterTests.swift
//  RocketAppTests
//
//  Created by Podgainy Sergei on 27.02.2023.
//

import XCTest
@testable import RocketApp

final class SettingsPresenterTests: XCTestCase {

    private var presenter: SettingsPresenterProtocol!
    private var view: MockView!

    override func setUp() {
        super.setUp()
        presenter = SettingsPresenter()
        view = MockView()
        presenter.settingsView = view
    }

    func testGetData() {

        presenter.getData()

        XCTAssertEqual(view.settings.count, 4)

        XCTAssertEqual(view.settings[0].settingType, .height)
        XCTAssertEqual(view.settings[1].settingType, .diameter)
        XCTAssertEqual(view.settings[2].settingType, .mass)
        XCTAssertEqual(view.settings[3].settingType, .payloadWeights)

        XCTAssertEqual(view.settings[0].units, [.m, .ft])
        XCTAssertEqual(view.settings[1].units, [.m, .ft])
        XCTAssertEqual(view.settings[2].units, [.kg, .lb])
        XCTAssertEqual(view.settings[3].units, [.kg, .lb])
    }

    func testSetSettingsSuccesfully() {
        presenter.setSettings(setting: .height, selectedIndex: 0)
        presenter.setSettings(setting: .diameter, selectedIndex: 0)
        presenter.setSettings(setting: .mass, selectedIndex: 1)
        presenter.setSettings(setting: .payloadWeights, selectedIndex: 1)

        presenter.getData()

        XCTAssertEqual(view.settings[0].selectedUnits, .metric)
        XCTAssertEqual(view.settings[1].selectedUnits, .metric)
        XCTAssertEqual(view.settings[2].selectedUnits, .imperial)
        XCTAssertEqual(view.settings[3].selectedUnits, .imperial)
    }

    func testSetSettingsWithError() {
        presenter.setSettings(setting: .height, selectedIndex: 5)
        presenter.setSettings(setting: .diameter, selectedIndex: 9)
        presenter.setSettings(setting: .mass, selectedIndex: 11)
        presenter.setSettings(setting: .payloadWeights, selectedIndex: 15)

        presenter.getData()

        XCTAssertEqual(view.settings[0].selectedUnits, .imperial)
        XCTAssertEqual(view.settings[1].selectedUnits, .imperial)
        XCTAssertEqual(view.settings[2].selectedUnits, .imperial)
        XCTAssertEqual(view.settings[3].selectedUnits, .imperial)
    }
}
