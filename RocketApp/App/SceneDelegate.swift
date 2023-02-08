//
//  SceneDelegate.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 07.01.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.makeKeyAndVisible()
        window?.rootViewController = makeNavigationController()
    }

    private func makeNavigationController() -> UINavigationController {

        let pagePresenter = PagePresenter()
        let pageView = PageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, presenter: pagePresenter)
        pagePresenter.pageView = pageView

        let navigationController = UINavigationController(rootViewController: pageView)

        pagePresenter.presentSettingsClosure = { [weak pageView] in
            let settingsPresenter = SettingsPresenter()
            let settingsView = SettingsViewController(presenter: settingsPresenter)
            settingsPresenter.settingsView = settingsView
            settingsView.onChangeSettings = {
                guard let rocketViewControllersArray = pageView?.viewControllers as? [RocketViewController] else { return }
                for rocketView in rocketViewControllersArray {
                    rocketView.reloadCollectionView()
                }
            }
            pageView?.present(settingsView, animated: true)
        }

        pagePresenter.pushLaunchesClosure = { id, name in
            let launchesPresenter = LaunchesPresenter(selectedRocketID: id, selectedRocketName: name)
            let launchesView = LaunchesViewController(presenter: launchesPresenter)
            launchesPresenter.launchesView = launchesView
            navigationController.pushViewController(launchesView, animated: true)
        }

        return navigationController
    }
}
