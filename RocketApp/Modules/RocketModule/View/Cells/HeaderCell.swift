//
//  HeaderCell.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 23.01.2023.
//

import UIKit
import Kingfisher

final class HeaderCell: UICollectionViewCell {

    private let rocketImage = UIImageView()
    private let blackView = UIView()
    private let rocketName = UILabel()
    private let settingsButton = UIButton()
    var onPresentSettings: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
        createConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        rocketImage.kf.cancelDownloadTask()
        rocketImage.image = nil
    }

    func configure(with url: URL, name: String) {
        rocketImage.kf.setImage(with: url)
        rocketName.text = name
    }

    @objc func presentSettings() {
        onPresentSettings?()
    }
}

// MARK: - Configure UI

private extension HeaderCell {
    func configureCell() {
        rocketImage.translatesAutoresizingMaskIntoConstraints = false
        blackView.translatesAutoresizingMaskIntoConstraints = false
        rocketName.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.translatesAutoresizingMaskIntoConstraints = false

        rocketImage.backgroundColor = .white
        rocketImage.contentMode = .scaleAspectFill

        blackView.backgroundColor = .black
        blackView.layer.cornerRadius = 32
        blackView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        rocketName.textColor = .white
        rocketName.font = .systemFont(ofSize: 24, weight: .medium)

        settingsButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        settingsButton.setBackgroundImage(UIImage(systemName: "gearshape"), for: .normal)
        settingsButton.tintColor = .white
        settingsButton.addTarget(self, action: #selector(presentSettings), for: .touchUpInside)
        settingsButton.center = contentView.center

        contentView.addSubview(rocketImage)
        contentView.addSubview(blackView)
        blackView.addSubview(rocketName)
        blackView.addSubview(settingsButton)
    }

    func createConstraints() {
        rocketImage.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        rocketImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
        rocketImage.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        rocketImage.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true

        blackView.heightAnchor.constraint(equalToConstant: 112).isActive = true
        blackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        blackView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        blackView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true

        rocketName.heightAnchor.constraint(equalToConstant: 32).isActive = true
        rocketName.leftAnchor.constraint(equalTo: blackView.leftAnchor, constant: 32).isActive = true
        rocketName.topAnchor.constraint(equalTo: blackView.topAnchor, constant: 48).isActive = true
        rocketName.rightAnchor.constraint(equalTo: settingsButton.leftAnchor).isActive = true

        settingsButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        settingsButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        settingsButton.centerYAnchor.constraint(equalTo: rocketName.centerYAnchor).isActive = true
        settingsButton.rightAnchor.constraint(equalTo: blackView.rightAnchor, constant: -32).isActive = true
    }
}
