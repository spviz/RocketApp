//
//  PageViewController.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 07.01.2023.
//

import UIKit

protocol PageViewProtocol: AnyObject {
    func present(rocketViewControllers: [RocketViewController])
    func present(alert: Error)
}

final class PageViewController: UIPageViewController {

    private var rocketViewControllers = [RocketViewController]()
    private let presenter: PagePresenterProtocol

    init(
        transitionStyle style: UIPageViewController.TransitionStyle,
        navigationOrientation: UIPageViewController.NavigationOrientation,
        options: [UIPageViewController.OptionsKey: Any]? = nil,
        presenter: PagePresenterProtocol
    ) {
        self.presenter = presenter
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
        view.backgroundColor = Colors.settingsBackgroundColor
        self.dataSource = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        presenter.getData()
    }
}

// MARK: - PageViewProtocol

extension PageViewController: PageViewProtocol {

    func present(rocketViewControllers: [RocketViewController]) {
        self.rocketViewControllers = rocketViewControllers
        self.setViewControllers([self.rocketViewControllers[0]], direction: .forward, animated: true)
    }

    func present(alert: Error) {
        let alert = UIAlertController(title: "Error", message: alert.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - UIPageViewControllerDataSource

extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? RocketViewController else { return nil }
        if let index = rocketViewControllers.firstIndex(of: viewController), index > 0 {
            return rocketViewControllers[index - 1]
        }
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? RocketViewController else { return nil }
        if let index = rocketViewControllers.firstIndex(of: viewController), index < rocketViewControllers.count - 1 {
            return rocketViewControllers[index + 1]
        }
        return nil
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        rocketViewControllers.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        0
    }
}
