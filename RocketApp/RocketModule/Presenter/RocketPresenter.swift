//
//  RocketPresenter.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 02.02.2023.
//

import Foundation

protocol RocketPresenterProtocol {
    func getData()
}

final class RocketPresenter: RocketPresenterProtocol {

    enum Constants: String {
        case noData = "Нет данных"
        case firstStage = "ПЕРВАЯ СТУПЕНЬ"
        case secondStage = "ВТОРАЯ СТУПЕНЬ"
        case million = "млн"
        case ton = "ton"
        case sec = "sec"
    }

    private let dataManager: DataManagerProtocol
    private let rocket: Rocket
    private let dateFormatter = DateFormatter()

    weak var rocketView: RocketViewProtocol?

    init(rocket: Rocket, dataManager: DataManagerProtocol = DataManager()) {
        self.rocket = rocket
        self.dataManager = dataManager
        dateFormatter.dateFormat = "d MMMM, yyyy"
    }

    func getData() {

        let height = dataManager.getSelectedUnit(for: .height) == .metric
        ? String(rocket.height.meters)
        : String(rocket.height.feet)

        let diameter = dataManager.getSelectedUnit(for: .diameter) == .metric
        ? String(rocket.diameter.meters)
        : String(rocket.diameter.feet)

        let mass = dataManager.getSelectedUnit(for: .mass) == .metric
        ? String(rocket.mass.kg)
        : String(rocket.mass.lb)

        let payloadWeights = dataManager.getSelectedUnit(for: .payloadWeights) == .metric
        ? String(rocket.payloadWeights[0].kg)
        : String(rocket.payloadWeights[0].lb)

        let burnTimeFirstStage: String
        let burnTimeSecondStage: String

        if let burnTime = rocket.firstStage.burnTimeSec {
            burnTimeFirstStage = String(burnTime) + " " + Constants.sec.rawValue
        } else {
            burnTimeFirstStage = Constants.noData.rawValue
        }

        if let burnTime = rocket.secondStage.burnTimeSec {
            burnTimeSecondStage = String(burnTime) + " " + Constants.sec.rawValue
        } else {
            burnTimeSecondStage = Constants.noData.rawValue
        }

        let headSection = Section(type: .header, items: [
            .header(rocket.flickrImages[Int.random(in: 0...rocket.flickrImages.count - 1)], rocket.name)])

        let horizontalSection = Section(type: .horizontal, items: [
            .info(dataManager.getSelectedUnit(for: .height) == .metric ? .heightMetric : .heightImperial, height),
            .info(dataManager.getSelectedUnit(for: .diameter) == .metric ? .diameterMetric : .diameterImperial, diameter),
            .info(dataManager.getSelectedUnit(for: .mass) == .metric ? .massMetric : .massImperial, mass),
            .info(dataManager.getSelectedUnit(for: .payloadWeights) == .metric ? .payloadWeightsMetric : .payloadWeightsImperial, payloadWeights)])

        let infoSection = Section(type: .vertical, items: [
            .info(.firstFlight, dateFormatter.string(from: rocket.firstFlight)),
            .info(.country, rocket.country),
            .info(.costPerLaunch,
                  "$" + String(format: "%.0f", Double(rocket.costPerLaunch) / 1000000) + " " + Constants.million.rawValue
                 )])

        let firstStageSection = Section(title: Constants.firstStage.rawValue, type: .vertical, items: [
            .info(.engines, String(rocket.firstStage.engines)),
            .info(.fuelAmountTons, String(format: "%.0f", rocket.firstStage.fuelAmountTons) + " " + Constants.ton.rawValue),
            .info(.burnTimeSec, burnTimeFirstStage)])

        let secondStageSection = Section(title: Constants.secondStage.rawValue, type: .vertical, items: [
            .info(.engines, String(rocket.secondStage.engines)),
            .info(.fuelAmountTons, String(format: "%.0f", rocket.secondStage.fuelAmountTons) + " " + Constants.ton.rawValue),
            .info(.burnTimeSec, burnTimeSecondStage)])

        let buttonSection = Section(type: .button, items: [.button])

        let sections = [headSection, horizontalSection, infoSection, firstStageSection, secondStageSection, buttonSection]

        rocketView?.present(sections: sections)
    }
}
