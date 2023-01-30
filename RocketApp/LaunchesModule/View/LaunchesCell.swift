//
//  LaunchesCell.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 18.01.2023.
//

import UIKit

final class LaunchesCell: UICollectionViewCell {

    private let nameLabel = UILabel()
    private let dateLabel = UILabel()
    private let rocketImage = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
        createConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureValues(name: String, date: String, image: UIImage) {
        nameLabel.text = name
        dateLabel.text = date
        rocketImage.image = image
    }
}

// MARK: - Configure UI
private extension LaunchesCell {

    func configureCell() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        rocketImage.translatesAutoresizingMaskIntoConstraints = false

        contentView.backgroundColor = Colors.horizontalCellColor
        contentView.layer.cornerRadius = 24

        nameLabel.textColor = .white
        nameLabel.font = .systemFont(ofSize: 20)

        dateLabel.textColor = .lightGray
        dateLabel.font = .systemFont(ofSize: 16)

        contentView.addSubview(nameLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(rocketImage)
    }

    func createConstraints() {
        nameLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 28).isActive = true
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: dateLabel.topAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 24).isActive = true

        dateLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 24).isActive = true

        rocketImage.widthAnchor.constraint(equalToConstant: 32).isActive = true
        rocketImage.heightAnchor.constraint(equalToConstant: 32).isActive = true
        rocketImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        rocketImage.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -33).isActive = true
    }
}
