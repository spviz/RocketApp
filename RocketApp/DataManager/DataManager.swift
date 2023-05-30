//
//  DataManager.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 15.01.2023.
//

import Foundation

protocol DataManagerProtocol {
    func setSettings(for setting: SettingType, selectedUnit: SelectedUnit)
    func getSelectedUnit(for parameter: SettingType) -> SelectedUnit
}

final class DataManager: DataManagerProtocol {

    private let userDefaults: UserDefaults

    let selectedUnit = [SelectedUnit.metric,
                        SelectedUnit.imperial]

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func setSettings(for setting: SettingType, selectedUnit: SelectedUnit) {
        userDefaults.set(selectedUnit.rawValue, forKey: setting.rawValue)
    }

    func getSelectedUnit(for setting: SettingType) -> SelectedUnit {
        let unitIndex = userDefaults.integer(forKey: setting.rawValue)
        return selectedUnit[unitIndex]
    }
}
