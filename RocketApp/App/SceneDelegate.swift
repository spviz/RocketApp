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

        let pagePresenter = PagePresenter()
        let pageViewController = PageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, presenter: pagePresenter)
        pagePresenter.pageView = pageViewController

        let navigationController = UINavigationController(rootViewController: pageViewController)

            pagePresenter.presentSettingsClosure = {
                let settingsPresenter = SettingsPresenter()
                let settingsView = SettingsViewController(presenter: settingsPresenter)
                settingsPresenter.settingsView = settingsView
                settingsView.onChangeSettings = pagePresenter.onChangeSettings
                pageViewController.present(settingsView, animated: true)
            }

            pagePresenter.pushLaunchesClosure = { id, name in
                let launchesPresenter = LaunchesPresenter(selectedRocketID: id, selectedRocketName: name)
                let launchesView = LaunchesViewController(presenter: launchesPresenter)
                launchesPresenter.launchesView = launchesView
                navigationController.pushViewController(launchesView, animated: true)
            }

        window?.rootViewController = navigationController
    }
}
