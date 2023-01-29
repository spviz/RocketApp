//
//  DataManager.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 15.01.2023.
//

import Foundation

protocol DataManagerProtocol {
    var settings: [Settings] { get }
    func setSettings(for indexPath: Int, selectedIndex: Int)
    func getSelectedIndex(for indexPath: Int) -> SelectedUnit
}

final class DataManager: DataManagerProtocol {

    let settings = [Settings(parameterName: .height, units: [.m, .ft]),
                    Settings(parameterName: .diameter, units: [.m, .ft]),
                    Settings(parameterName: .mass, units: [.kg, .lb]),
                    Settings(parameterName: .payloadWeights, units: [.kg, .lb])]

    let selectedUnit = [SelectedUnit.metric,
                        SelectedUnit.imperial]

    func setSettings(for indexPath: Int, selectedIndex: Int) {
        UserDefaults.standard.set(selectedIndex, forKey: settings[indexPath].parameterName.rawValue)
    }

    func getSelectedIndex(for indexPath: Int) -> SelectedUnit {
        let unitIndex = UserDefaults.standard.integer(forKey: settings[indexPath].parameterName.rawValue)
        return selectedUnit[unitIndex]
    }
}
