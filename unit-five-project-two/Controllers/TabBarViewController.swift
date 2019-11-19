//
//  TabBarViewController.swift
//  unit-five-project-two
//
//  Created by Levi Davis on 11/19/19.
//  Copyright © 2019 Levi Davis. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
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
        // Do any additional setup after loading the view.
    }
    
    private func addViewControllers() {
        feedVC.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(systemName: "photo"), tag: 0)
        imageUploadVC.tabBarItem = UITabBarItem(title: "Add Image", image: UIImage(systemName: "photo.on.rectangle"), tag: 1)
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), tag: 2)
        self.viewControllers = [feedVC, imageUploadVC, profileVC]
    }
    
}

/**
 lazy var postsVC = UINavigationController(rootViewController: PostsListViewController())
 
 lazy var usersVC = UINavigationController(rootViewController: UsersListViewController())
 
 lazy var profileVC: UINavigationController = {
     let userProfileVC = UserProfileViewController()
     userProfileVC.user = AppUser(from: FirebaseAuthService.manager.currentUser!)
     userProfileVC.isCurrentUser = true
     return UINavigationController(rootViewController: userProfileVC)
 }()
 
 override func viewDidLoad() {
     super.viewDidLoad()
     postsVC.tabBarItem = UITabBarItem(title: "Posts", image: UIImage(systemName: "list.dash"), tag: 0)
     usersVC.tabBarItem = UITabBarItem(title: "Users", image: UIImage(systemName: "person.3"), tag: 1)
     profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.crop.square"), tag: 2)
     self.viewControllers = [postsVC, usersVC,profileVC]
 }
 */
