//
//  SettingsModel.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 12.01.2023.
//

import Foundation

struct Settings {
    let parameterName: Parameters
    let units: [Units]
}

extension Settings {
    enum Parameters: String {
        case height = "Высота"
        case diameter = "Диаметр"
        case mass = "Масса"
        case payloadWeights = "Полезная нагрузка"
    }

    enum Units: String {
        case kg
        case lb
        case m
        case ft
    }
}

enum SelectedUnit: Int {
    case metric
    case imperial
}
