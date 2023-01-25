//
//  SectionHeader.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 25.01.2023.
//

import UIKit

final class SectionHeader: UICollectionReusableView {

    static let identifier = "SectionHeader"
    private var headerText = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure UI

extension SectionHeader {
    private func configureView() {
        headerText.frame = bounds
        headerText.textColor = .white
        headerText.font = .systemFont(ofSize: 16, weight: .bold)
        addSubview(headerText)
    }

    func configureHeader(with name: String) {
        headerText.text = name
    }

}
