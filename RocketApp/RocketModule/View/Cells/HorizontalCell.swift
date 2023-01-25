//
//  RocketViewCharacteristicsCell.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 21.01.2023.
//

import UIKit

final class HorizontalCell: UICollectionViewCell {

    private let nameLabel = UILabel()
    private let valueLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure Cell
extension HorizontalCell {
    func configure(with item: ItemType) {
        switch item {
        case .info(let name, let value, _):
            nameLabel.text = name.rawValue
            valueLabel.text = value
        default:
            break
        }
    }
    private func configureCell() {

        contentView.backgroundColor = .darkGray
        contentView.layer.cornerRadius = 32

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false

        nameLabel.font = .systemFont(ofSize: 14)
        nameLabel.textColor = UIColor(red: 0.557, green: 0.557, blue: 0.561, alpha: 1)
        valueLabel.font = .systemFont(ofSize: 16, weight: .bold)
        valueLabel.textColor = .white

        contentView.addSubview(valueLabel)
        contentView.addSubview(nameLabel)

        createConstraints()
    }
}

// MARK: - Create Constraints
private extension HorizontalCell {
    func createConstraints() {
        valueLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        valueLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 28).isActive = true
        valueLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true

        nameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    }
}
