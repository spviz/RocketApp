//
//  SettingsCell.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 12.01.2023.
//

import UIKit

final class SettingsCell: UITableViewCell {

    private let unitsSelector = UISegmentedControl()
    private let label = UILabel()
    var onChangeUnits: ((Int) -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
        createConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureElements(with setting: Settings) {

        label.text = setting.settingType.rawValue

        unitsSelector.removeAllSegments()
        unitsSelector.insertSegment(withTitle: setting.units[0].rawValue, at: 0, animated: false)
        unitsSelector.insertSegment(withTitle: setting.units[1].rawValue, at: 1, animated: false)
        unitsSelector.selectedSegmentIndex = setting.selectedUnits.rawValue
    }

    @objc func tapUnitsSelector(sender: UISegmentedControl) {
        onChangeUnits?(sender.selectedSegmentIndex)
    }
}

// MARK: - Configure UI

private extension SettingsCell {
    func configureCell() {
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false

        unitsSelector.backgroundColor = Colors.horizontalCellColor
        unitsSelector.addTarget(self, action: #selector(tapUnitsSelector), for: .valueChanged)
        unitsSelector.translatesAutoresizingMaskIntoConstraints = false

        contentView.backgroundColor = Colors.settingsBackgroundColor
        contentView.addSubview(unitsSelector)
        contentView.addSubview(label)
    }

    func createConstraints() {
        unitsSelector.widthAnchor.constraint(equalToConstant: 115).isActive = true
        unitsSelector.heightAnchor.constraint(equalToConstant: 40).isActive = true
        unitsSelector.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -28).isActive = true
        unitsSelector.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true

        label.heightAnchor.constraint(equalToConstant: 24).isActive = true
        label.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 28).isActive = true
        label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: unitsSelector.leftAnchor, constant: 20).isActive = true
    }
}
