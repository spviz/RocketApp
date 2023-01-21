//
//  UITableViewCellExtension.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 15.01.2023.
//

import UIKit

extension UITableViewCell {
    static var identifier: String {
        return String(describing: Self.self)
    }
}
