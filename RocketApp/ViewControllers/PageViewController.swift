//
//  PageViewController.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 07.01.2023.
//

import UIKit

final class PageViewController: UIPageViewController {

    private let firstRocket = RocketViewController(color: .lightGray)
    private let secondRocket = RocketViewController(color: .gray)
    private let thirdRocket = RocketViewController(color: .darkGray)
    
    private let network = NetworkManager()
    
    private var rocketsArray = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rocketsArray.append(firstRocket)
        rocketsArray.append(secondRocket)
        rocketsArray.append(thirdRocket)

        network.getRockets(){ result in
            switch result {
            case .success(let rockets):
                print(rockets.count)
            case .failure(let failure):
                print(failure)
            }
        }
        
        network.getLaunches(for: "5e9d0d95eda69955f709d1eb") { result in
            switch result {
            case .success(let launches):
                print(launches.docs.count)
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
        view.backgroundColor = .black
        self.dataSource = self
        setViewControllers([rocketsArray[0]], direction: .forward, animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UIPageViewControllerDataSource

extension PageViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? RocketViewController else { return nil }
        if let index = rocketsArray.firstIndex(of: viewController), index > 0 {
                return rocketsArray[index - 1]
            }
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? RocketViewController else { return nil }
        if let index = rocketsArray.firstIndex(of: viewController), index < rocketsArray.count - 1 {
                return rocketsArray[index + 1]
            }
        return nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        rocketsArray.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        0
    }

}
