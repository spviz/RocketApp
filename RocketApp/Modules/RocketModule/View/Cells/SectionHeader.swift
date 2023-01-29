//
//  SectionHeader.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 25.01.2023.
//

import UIKit

final class SectionHeader: UICollectionReusableView {

    private var headerText = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        headerText.text = nil
    }
    func configure(with title: String) {
        headerText.text = title
    }
}

// MARK: - Configure UI

private extension SectionHeader {
    func configureView() {
        headerText.frame = bounds
        headerText.textColor = .white
        headerText.font = .systemFont(ofSize: 16, weight: .bold)
        addSubview(headerText)
    }
}
