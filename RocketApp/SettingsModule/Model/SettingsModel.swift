//
//  SettingsModel.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 12.01.2023.
//

import Foundation

struct Settings: Equatable {
    let settingType: SettingType
    let units: [Unit]
    let selectedUnits: SelectedUnit

    init(settingType: SettingType, units: [Unit], selectedUnits: SelectedUnit = .metric) {
        self.settingType = settingType
        self.units = units
        self.selectedUnits = selectedUnits
    }
}

extension Settings {
    enum Unit: String {
        case kg
        case lb
        case m
        case ft
    }
}

enum SettingType: String {
    case height = "Высота"
    case diameter = "Диаметр"
    case mass = "Масса"
    case payloadWeights = "Полезная нагрузка"
}

enum SelectedUnit: Int {
    case metric
    case imperial
}
