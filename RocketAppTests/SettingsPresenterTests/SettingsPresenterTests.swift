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
    private var view: MockView!

    override func setUp() {
        super.setUp()
        presenter = SettingsPresenter()
        view = MockView()
        presenter.settingsView = view
    }

    func testSetSettingsAndGetData() {
        presenter.setSettings(setting: .height, selectedUnit: .metric)
        presenter.setSettings(setting: .diameter, selectedUnit: .imperial)
        presenter.setSettings(setting: .mass, selectedUnit: .metric)
        presenter.setSettings(setting: .payloadWeights, selectedUnit: .imperial)

        presenter.getData()

        XCTAssertEqual(view.settings.count, 4)

        XCTAssertEqual(view.settings, [
            Settings(settingType: .height, units: [.m, .ft],
                     selectedUnits: SelectedUnit.metric),
            Settings(settingType: .diameter, units: [.m, .ft],
                     selectedUnits: SelectedUnit.imperial),
            Settings(settingType: .mass, units: [.kg, .lb],
                     selectedUnits: SelectedUnit.metric),
            Settings(settingType: .payloadWeights, units: [.kg, .lb],
                     selectedUnits: SelectedUnit.imperial)
        ])
    }

}

// MARK: - MockView

private extension SettingsPresenterTests {
    final class MockView: SettingsViewProtocol {

        var settings = [Settings]()

        func present(settings: [Settings]) {
            self.settings = settings
        }
    }
}
