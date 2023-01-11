//
//  RocketViewController.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 07.01.2023.
//

import UIKit

class RocketViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    init(color: UIColor) {
        super .init(nibName: nil, bundle: nil)
        self.view.backgroundColor = color
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
