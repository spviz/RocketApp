//
//  UICollectionReusableViewExtension.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 26.01.2023.
//

import UIKit

extension UICollectionReusableView {
    static var identifier: String {
        return String(describing: Self.self)
    }
}
