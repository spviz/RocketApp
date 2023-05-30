//
//  MockDataManager.swift
//  RocketAppTests
//
//  Created by Podgainy Sergei on 02.03.2023.
//

import Foundation
@testable import RocketApp

final class MockDataManager: DataManagerProtocol {

    var selectedUnit: SelectedUnit?

    func setSettings(for setting: SettingType, selectedUnit: SelectedUnit) {
    }

    func getSelectedUnit(for parameter: SettingType) -> SelectedUnit {
        selectedUnit!
    }
}
