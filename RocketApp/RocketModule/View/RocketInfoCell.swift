//
//  RocketInfoCell.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 21.01.2023.
//

import UIKit

final class RocketInfoCell: UICollectionViewCell {

    private let name = UILabel()
    private let value = UILabel()
    private let dateFormatter = DateFormatter()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureElements(item: Item, rocket: Rocket, sectionType: SectionType) {

        switch sectionType {
        case .rocketInfo:
            name.text = item.rocketInfoName?.rawValue
            switch item.rocketInfoName {
            case .firstFlight: value.text = dateFormatter.string(from: rocket.firstFlight)
            case .country: value.text = rocket.country
            case .costPerLaunch: value.text = String(rocket.costPerLaunch)
            default: break
            }
        case .firstStageInfo:
            name.text = item.firstStageInfoName?.rawValue
            switch item.firstStageInfoName {
            case .engines: value.text = String(rocket.firstStage.engines)
            case .fuelAmountTons: value.text = String(rocket.firstStage.fuelAmountTons) + " ton"
            case .burnTimeSEC:
                if let burnTime = rocket.firstStage.burnTimeSec {
                    value.text = String(burnTime) + " sec"
                } else {
                    value.text = "Нет данных"
                }
            default: break
            }
        case .secondStageInfo:
            name.text = item.secondStageInfoName?.rawValue
            switch item.secondStageInfoName {
            case .engines: value.text = String(rocket.secondStage.engines)
            case .fuelAmountTons: value.text = String(rocket.secondStage.fuelAmountTons) + " ton"
            case .burnTimeSEC:
                if let burnTime = rocket.secondStage.burnTimeSec {
                    value.text = String(burnTime) + " sec"
                } else {
                    value.text = "Нет данных"
                }
            default: break
            }
        default: break
        }
    }

    func configureCell() {

        value.textAlignment = .right
        value.textColor = .white
        name.textColor = UIColor(red: 0.792, green: 0.792, blue: 0.792, alpha: 1)
        name.translatesAutoresizingMaskIntoConstraints = false
        value.translatesAutoresizingMaskIntoConstraints = false

        dateFormatter.dateFormat = "d MMMM, yyyy"
        contentView.addSubview(name)
        contentView.addSubview(value)

        createConstraints()
    }

    func createConstraints() {
        name.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        name.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        name.widthAnchor.constraint(equalToConstant: 200).isActive = true

        value.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        value.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        value.widthAnchor.constraint(equalToConstant: 200).isActive = true

    }
}
