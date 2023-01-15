//
//  DataManager.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 15.01.2023.
//

import Foundation

protocol DataManagerProtocol {
    var settings: [Settings] { get }
    func setSettings(for tag: Int, selectedIndex: Int)
    func getSettings(for tag: Int) -> Int
}

class DataManager: DataManagerProtocol {

    var settings = [Settings(parameterName: .height, units: [.m, .ft]),
                    Settings(parameterName: .diameter, units: [.m, .ft]),
                    Settings(parameterName: .mass, units: [.kg, .lb]),
                    Settings(parameterName: .payloadWeights, units: [.kg, .lb])]

    func setSettings(for tag: Int, selectedIndex: Int) {
        UserDefaults.standard.set(selectedIndex, forKey: settings[tag].parameterName.rawValue)
    }

    func getSettings(for tag: Int) -> Int {
        return UserDefaults.standard.integer(forKey: settings[tag].parameterName.rawValue)
    }
}
