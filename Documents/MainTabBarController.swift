//
//  MainTabBarController.swift
//  Documents
//
//  Created by Vadim on 16.07.2022.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {

    private lazy var documentsNC: UINavigationController = {
        let navigation = UINavigationController(rootViewController: DocViewController())
        navigation.tabBarItem = UITabBarItem(
            title: "Documents",
            image: UIImage(systemName: "doc.circle"),
            selectedImage: UIImage(systemName: "doc.circle.fill"))
        navigation.navigationBar.topItem?.title = "Documents"
        return navigation
    }()

    private lazy var settingsNC: UINavigationController = {
        let navigation = UINavigationController(rootViewController: SettingsViewController())
        navigation.tabBarItem = UITabBarItem(
            title: "Settings",
            image: UIImage(systemName: "pills.circle"),
            selectedImage: UIImage(systemName: "pills.circle.fill"))
        navigation.navigationBar.topItem?.title = "Settings"
        return navigation
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = .systemGray
        tabBar.tintColor = .systemBlue
        viewControllers = [documentsNC, settingsNC]
    }
}
