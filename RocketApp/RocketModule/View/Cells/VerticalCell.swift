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
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure Cell
extension VerticalCell {
    func configure(for item: ItemType) {
        switch item {
        case .info(let name, let value, _):
            nameLabel.text = name.rawValue
            valueLabel.text = value
        default: break
        }
    }

    private func configureCell() {

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false

        valueLabel.textAlignment = .right
        valueLabel.textColor = .white
        nameLabel.textColor = UIColor(red: 0.792, green: 0.792, blue: 0.792, alpha: 1)

        contentView.addSubview(nameLabel)
        contentView.addSubview(valueLabel)

        createConstraints()
    }
}

// MARK: - Create Constraints
private extension VerticalCell {
    func createConstraints() {
        nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true

        valueLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        valueLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        valueLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }
}
