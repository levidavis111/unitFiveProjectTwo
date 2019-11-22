//
//  TabBarViewController.swift
//  unit-five-project-two
//
//  Created by Levi Davis on 11/19/19.
//  Copyright © 2019 Levi Davis. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
//    MARK: - UI Elements
    
    lazy var feedVC = UINavigationController(rootViewController: FeedViewController())
    lazy var imageUploadVC = UINavigationController(rootViewController: ImageUploadViewController())
    
    lazy var profileVC: UINavigationController = {
        let userProfileVC = ProfileViewController()
        userProfileVC.user = AppUser(from: FirebaseAuthService.manager.currentUser!)
        userProfileVC.isCurrentUser = true
        return UINavigationController(rootViewController: userProfileVC)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        addViewControllers()
    }
    
//    MARK: - Private Methods
    
    private func addViewControllers() {
        feedVC.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(systemName: "photo"), tag: 0)
        imageUploadVC.tabBarItem = UITabBarItem(title: "Add Image", image: UIImage(systemName: "photo.on.rectangle"), tag: 1)
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), tag: 2)
        self.viewControllers = [feedVC, imageUploadVC, profileVC]
    }
    
}
