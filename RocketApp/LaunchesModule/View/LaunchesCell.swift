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
    private let successImage = UIImageView()
    private let dateFormatter = DateFormatter()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure UI

extension LaunchesCell {
    private func configureCell() {

        name.translatesAutoresizingMaskIntoConstraints = false
        date.translatesAutoresizingMaskIntoConstraints = false
        rocketImage.translatesAutoresizingMaskIntoConstraints = false
        successImage.translatesAutoresizingMaskIntoConstraints = false

        name.textColor = .white
        name.font = .systemFont(ofSize: 20)

        date.textColor = .lightGray
        date.font = .systemFont(ofSize: 16)
        dateFormatter.dateFormat = "d MMMM, yyyy"

        rocketImage.addSubview(successImage)
        contentView.addSubview(name)
        contentView.addSubview(date)
        contentView.addSubview(rocketImage)

        createConstraints()
    }
    func configureValues(for launch: Launch, indexPath: Int) {

        name.text = launch.docs[indexPath].name
        date.text = dateFormatter.string(from: launch.docs[indexPath].dateUtc)

        if launch.docs[indexPath].success ?? false {
            rocketImage.image = UIImage(named: "rocket")?.withTintColor(.lightGray)
            successImage.image = UIImage(systemName: "checkmark.circle.fill")
            successImage.tintColor = .systemGreen
        } else {
            rocketImage.image = UIImage(named: "rocket")?.withTintColor(.lightGray).rotate(radians: .pi)
            successImage.image = UIImage(systemName: "xmark.circle.fill")
            successImage.tintColor = .systemRed
        }
    }
}

// MARK: - Create Constraints

private extension LaunchesCell {
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

        successImage.widthAnchor.constraint(equalToConstant: 12).isActive = true
        successImage.heightAnchor.constraint(equalToConstant: 12).isActive = true
        successImage.rightAnchor.constraint(equalTo: rocketImage.rightAnchor, constant: 0).isActive = true
        successImage.bottomAnchor.constraint(equalTo: rocketImage.bottomAnchor, constant: 0).isActive = true
    }
}
