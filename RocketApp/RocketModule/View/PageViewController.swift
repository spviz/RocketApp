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

    func getRockets() {
        networkManager.getRockets { result in
            switch result {
            case .success(let rockets):
                DispatchQueue.main.async {
                for i in 0...rockets.count - 1 {
                    self.rocketViewControllersArray.append(RocketViewController(rocket: rockets[i], networkManager: self.networkManager, dataManager: self.dataManager))
                }
                    self.setViewControllers([self.rocketViewControllersArray[0]], direction: .forward, animated: true)
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }

    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey: Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
        view.backgroundColor = UIColor(red: 0.071, green: 0.071, blue: 0.071, alpha: 1)
        self.dataSource = self
        getRockets()
//        setViewControllers([rocketViewControllersArray[0]], direction: .forward, animated: true)
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
