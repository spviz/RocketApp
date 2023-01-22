//
//  RocketViewCharacteristicsCell.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 21.01.2023.
//

import UIKit

final class ParametersCell: UICollectionViewCell {

    private let parameterValue = UILabel()
    private let parameterName = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureElements(parameter: Item, rocket: Rocket, selectedUnit: SelectedUnit) {

        guard let parameterNameSafe = parameter.parameterName else { return }

        switch parameterNameSafe {
        case .height:
            if let heightMeters = rocket.height.meters, let heightFeet = rocket.height.feet {
                switch selectedUnit {
                case .metric:
                    parameterValue.text = String(heightMeters)
                    parameterName.text = parameterNameSafe.rawValue + ", m"
                case .imperial:
                    parameterValue.text = String(heightFeet)
                    parameterName.text = parameterNameSafe.rawValue + ", ft"
                }
            }
        case .diameter:
            if let diameterMeters = rocket.diameter.meters, let diameterFeet = rocket.diameter.feet {
                switch selectedUnit {
                case .metric:
                    parameterValue.text = String(diameterMeters)
                    parameterName.text = parameterNameSafe.rawValue + ", m"
                case .imperial:
                    parameterValue.text = String(diameterFeet)
                    parameterName.text = parameterNameSafe.rawValue + ", ft"
                }
            }
        case .mass:
            switch selectedUnit {
            case .metric:
                parameterValue.text = String(rocket.mass.kg)
                parameterName.text = parameterNameSafe.rawValue + ", kg"
            case .imperial:
                parameterValue.text = String(rocket.mass.lb)
                parameterName.text = parameterNameSafe.rawValue + ", lb"
            }
        case .payloadWeights:
            switch selectedUnit {
            case .metric:
                parameterValue.text = String(rocket.payloadWeights[0].kg)
                parameterName.text = parameterNameSafe.rawValue + ", kg"
            case .imperial:
                parameterValue.text = String(rocket.payloadWeights[0].lb)
                parameterName.text = parameterNameSafe.rawValue + ", lb"
            }
        }
    }
    func configureCell() {
        parameterName.translatesAutoresizingMaskIntoConstraints = false
        parameterValue.translatesAutoresizingMaskIntoConstraints = false

        parameterName.font = .systemFont(ofSize: 14)
        parameterName.textColor = UIColor(red: 0.557, green: 0.557, blue: 0.561, alpha: 1)
        parameterValue.font = .systemFont(ofSize: 16, weight: .bold)
        parameterValue.textColor = .white

        contentView.backgroundColor = UIColor(red: 0.129, green: 0.129, blue: 0.129, alpha: 1)
        contentView.layer.cornerRadius = 32

        contentView.addSubview(parameterValue)
        contentView.addSubview(parameterName)

        createConstraints()
    }
    func createConstraints() {
        parameterValue.heightAnchor.constraint(equalToConstant: 24).isActive = true
        parameterValue.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 28).isActive = true
        parameterValue.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true

        parameterName.heightAnchor.constraint(equalToConstant: 20).isActive = true
        parameterName.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24).isActive = true
        parameterName.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    }
}
