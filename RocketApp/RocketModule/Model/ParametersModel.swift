//
//  ParametersModel.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 27.01.2023.
//

import Foundation

enum ParameterItemName: String {
    case heightMetric = "Высота, m"
    case heightImperial = "Высота, ft"
    case diameterMetric = "Диаметр, m"
    case diameterImperial = "Диаметр, ft"
    case massMetric = "Масса, kg"
    case massImperial = "Масса, lb"
    case payloadWeightsMetric = "Нагрузка, kg"
    case payloadWeightsImperial = "Нагрузка, lb"
    case firstFlight = "Первый запуск"
    case country = "Cтрана"
    case costPerLaunch = "Стоимость запуска"
    case engines = "Количество двигателей"
    case fuelAmountTons = "Количество топлива"
    case burnTimeSec = "Время сгорания"
}

enum ParameterItem {
    case height
    case diameter
    case mass
    case payloadWeights
    case firstFlight
    case country
    case costPerLaunch
    case enginesFirstStage
    case fuelAmountTonsFirstStage
    case burnTimeSecFirstStage
    case enginesSecondStage
    case fuelAmountTonsSecondStage
    case burnTimeSecSecondStage
}
