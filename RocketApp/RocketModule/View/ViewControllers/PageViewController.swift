//
//  PageViewController.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 07.01.2023.
//

import UIKit

final class PageViewController: UIPageViewController {

    private let networkManager = NetworkManager()
    private let dataManager = DataManager()
    private var rocketViewControllersArray = [UIViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func getRocketScreens() {
        networkManager.getRockets { result in
            switch result {
            case .success(let rockets):
                DispatchQueue.main.async {
                    self.rocketViewControllersArray.append(contentsOf: rockets.map({ rocket in
                        let rocketVC = RocketViewController(rocket: rocket, dataManager: self.dataManager)
                        return rocketVC
                    }))
                    self.setViewControllers([self.rocketViewControllersArray[0]], direction: .forward, animated: true)
                }
            case .failure(let failure):
                let alert = UIAlertController(title: "Error", message: failure.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey: Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
        view.backgroundColor = Colors.settingsBackgroundColor
        self.dataSource = self
        self.delegate = self
        getRocketScreens()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UIPageViewControllerDataSource

extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? RocketViewController else { return nil }
        if let index = rocketViewControllersArray.firstIndex(of: viewController), index > 0 {
            return rocketViewControllersArray[index - 1]
        }
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? RocketViewController else { return nil }
        if let index = rocketViewControllersArray.firstIndex(of: viewController), index < rocketViewControllersArray.count - 1 {
            return rocketViewControllersArray[index + 1]
        }
        return nil
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        rocketViewControllersArray.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        0
    }
}

// MARK: - UIPageViewControllerDelegate
extension PageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        let pendingViewController = pendingViewControllers[0] as? RocketViewController
        pendingViewController?.reloadCollectionView()
    }
}
