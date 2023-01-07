//
//  PageViewController.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 07.01.2023.
//

import UIKit

class PageViewController: UIPageViewController {

    
    let firstRocket = RocketViewController(color: .lightGray)
    let secondRocket = RocketViewController(color: .gray)
    let thirdRocket = RocketViewController(color: .darkGray)
    
    //let network = NetworkManager()
    
    var rocketsArray = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        rocketsArray.append(firstRocket)
        rocketsArray.append(secondRocket)
        rocketsArray.append(thirdRocket)

//        network.requestRocketInfo()
//        network.requestLaunchesInfo()
        
    }
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
        view.backgroundColor = .black
        self.dataSource = self
        self.delegate = self
        setViewControllers([rocketsArray[0]], direction: .forward, animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? RocketViewController else { return nil }
        if let index = rocketsArray.firstIndex(of: viewController) {
            if index > 0 {
                return rocketsArray[index - 1]
            }
        }
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? RocketViewController else { return nil }
        if let index = rocketsArray.firstIndex(of: viewController) {
            if index < rocketsArray.count - 1 {
                return rocketsArray[index + 1]
            }
        }
        return nil

    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return rocketsArray.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }

}
