//
//  ButtonCell.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 23.01.2023.
//

import UIKit

final class ButtonCell: UICollectionViewCell {

    private let launchesButton = UIButton()
    var onPushLaunches: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func pushLaunches() {
        onPushLaunches?()
    }
}

// MARK: - Configure Cell

private extension ButtonCell {
    func configureCell() {
        launchesButton.frame = contentView.bounds
        launchesButton.center = contentView.center
        launchesButton.setTitle("Посмотреть запуски", for: .normal)
        launchesButton.backgroundColor = Colors.horizontalCellColor
        launchesButton.layer.cornerRadius = 10
        launchesButton.addTarget(self, action: #selector(pushLaunches), for: .touchUpInside)
        contentView.addSubview(launchesButton)
    }
}
