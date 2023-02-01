//
//  DataManager.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 15.01.2023.
//

import Foundation

protocol DataManagerProtocol {
    var settings: [Settings] { get }
    func setSettings(for setting: SettingType, selectedUnit: SelectedUnit)
    func getSelectedIndex(for parameter: SettingType) -> SelectedUnit
}

final class DataManager: DataManagerProtocol {

    let settings = [Settings(settingType: .height, units: [.m, .ft]),
                    Settings(settingType: .diameter, units: [.m, .ft]),
                    Settings(settingType: .mass, units: [.kg, .lb]),
                    Settings(settingType: .payloadWeights, units: [.kg, .lb])]

    let selectedUnit = [SelectedUnit.metric,
                        SelectedUnit.imperial]

    func setSettings(for setting: SettingType, selectedUnit: SelectedUnit) {
        switch selectedUnit {
        case .metric:
            UserDefaults.standard.set(0, forKey: setting.rawValue)
        case .imperial:
            UserDefaults.standard.set(1, forKey: setting.rawValue)
        }
    }

    func getSelectedIndex(for setting: SettingType) -> SelectedUnit {
        let unitIndex = UserDefaults.standard.integer(forKey: setting.rawValue)
        return selectedUnit[unitIndex]
    }
}
