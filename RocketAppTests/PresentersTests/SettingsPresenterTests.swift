//
//  SettingsPresenterTests.swift
//  RocketAppTests
//
//  Created by Podgainy Sergei on 27.02.2023.
//

import XCTest
@testable import RocketApp

final class SettingsPresenterTests: XCTestCase {

    private var presenter: SettingsPresenter!
    private var view: SettingsMockView!

    override func setUp() {
        super.setUp()
        presenter = SettingsPresenter()
        view = SettingsMockView()
        presenter.settingsView = view
    }

    func testSetSettingsAndGetData() {

        presenter.setSettings(setting: .height, selectedUnit: .metric)
        presenter.setSettings(setting: .diameter, selectedUnit: .imperial)
        presenter.setSettings(setting: .mass, selectedUnit: .metric)
        presenter.setSettings(setting: .payloadWeights, selectedUnit: .imperial)

        presenter.getData()

        XCTAssertEqual(view.settings, [
            Settings(settingType: .height, units: [.m, .ft], selectedUnits: .metric),
            Settings(settingType: .diameter, units: [.m, .ft], selectedUnits: .imperial),
            Settings(settingType: .mass, units: [.kg, .lb], selectedUnits: .metric),
            Settings(settingType: .payloadWeights, units: [.kg, .lb], selectedUnits: .imperial)
        ])
    }

}

// MARK: - MockView

private extension SettingsPresenterTests {
    final class SettingsMockView: SettingsViewProtocol {

        var settings = [Settings]()

        func present(settings: [Settings]) {
            self.settings = settings
        }
    }
}
