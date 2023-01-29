//
//  RocketInfoCell.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 21.01.2023.
//

import UIKit

final class VerticalCell: UICollectionViewCell {

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

private extension VerticalCell {
    func configureCell() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false

        valueLabel.textAlignment = .right
        valueLabel.textColor = .white
        nameLabel.textColor = Colors.verticalCellNameColor

        contentView.addSubview(nameLabel)
        contentView.addSubview(valueLabel)
    }

    func createConstraints() {
        nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: valueLabel.leftAnchor).isActive = true
        nameLabel.widthAnchor.constraint(lessThanOrEqualToConstant: contentView.frame.width * 0.8).isActive = true

        valueLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        valueLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        valueLabel.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        valueLabel.widthAnchor.constraint(lessThanOrEqualToConstant: contentView.frame.width * 0.8).isActive = true
    }
}
