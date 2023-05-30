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
        createConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with name: String, value: String) {
        nameLabel.text = name
        valueLabel.text = value
    }
}

// MARK: - Configure UI

private extension HorizontalCell {
    func configureCell() {
        contentView.backgroundColor = Colors.horizontalCellColor
        contentView.layer.cornerRadius = 32

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false

        nameLabel.font = .systemFont(ofSize: 14)
        nameLabel.textColor = Colors.horizontalCellTextColor
        valueLabel.font = .systemFont(ofSize: 16, weight: .bold)
        valueLabel.textColor = .white

        contentView.addSubview(valueLabel)
        contentView.addSubview(nameLabel)
    }

    func createConstraints() {
        valueLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        valueLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 28).isActive = true
        valueLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        valueLabel.widthAnchor.constraint(lessThanOrEqualToConstant: contentView.frame.width).isActive = true

        nameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        nameLabel.widthAnchor.constraint(lessThanOrEqualToConstant: contentView.frame.width).isActive = true
    }
}
