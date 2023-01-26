//
//  LaunchesCell.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 18.01.2023.
//

import UIKit

final class LaunchesCell: UICollectionViewCell {

    private let name = UILabel()
    private let date = UILabel()
    private let rocketImage = UIImageView()
    private let dateFormatter = DateFormatter()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
        createConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureValues(for launch: Launch.Doc) {

        name.text = launch.name
        date.text = dateFormatter.string(from: launch.dateUtc)

        if launch.success ?? false {
            rocketImage.image = UIImage(named: "rocket_true")
        } else {
            rocketImage.image = UIImage(named: "rocket_false")
        }
    }
}

// MARK: - Configure UI
private extension LaunchesCell {

    func configureCell() {
        name.translatesAutoresizingMaskIntoConstraints = false
        date.translatesAutoresizingMaskIntoConstraints = false
        rocketImage.translatesAutoresizingMaskIntoConstraints = false

        contentView.backgroundColor = Colors.horizontalCellColor
        contentView.layer.cornerRadius = 24

        name.textColor = .white
        name.font = .systemFont(ofSize: 20)

        date.textColor = .lightGray
        date.font = .systemFont(ofSize: 16)
        dateFormatter.dateFormat = "d MMMM, yyyy"

        contentView.addSubview(name)
        contentView.addSubview(date)
        contentView.addSubview(rocketImage)
    }

    func createConstraints() {
        name.widthAnchor.constraint(equalToConstant: 200).isActive = true
        name.heightAnchor.constraint(equalToConstant: 28).isActive = true
        name.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24).isActive = true
        name.bottomAnchor.constraint(equalTo: date.topAnchor).isActive = true
        name.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 24).isActive = true

        date.widthAnchor.constraint(equalToConstant: 200).isActive = true
        date.heightAnchor.constraint(equalToConstant: 24).isActive = true
        date.topAnchor.constraint(equalTo: name.bottomAnchor).isActive = true
        date.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24).isActive = true
        date.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 24).isActive = true

        rocketImage.widthAnchor.constraint(equalToConstant: 32).isActive = true
        rocketImage.heightAnchor.constraint(equalToConstant: 32).isActive = true
        rocketImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        rocketImage.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -33).isActive = true
    }
}
