//
//  ProfileViewController.swift
//  unit-five-project-two
//
//  Created by Levi Davis on 11/18/19.
//  Copyright © 2019 Levi Davis. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    var user: AppUser!
    var isCurrentUser = false
    
    var posts = [Post]()
    
    lazy var profileImageView: UIImageView = {
        let profileImage = UIImageView()
        profileImage.image = UIImage(systemName: "person.circle.fill")
        return profileImage
    }()
    
    lazy var postCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.text = "You have \(posts.count) posts"
        return label
    }()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .white
            addSubviews()
            constrainSubviews()
            setupNavigation()
            let button = UIBarButtonItem(title: "logout", style: .plain, target: self, action: #selector(logout))
            self.navigationItem.rightBarButtonItem = button
            
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            getPostsForThisUser()
        }
    
    @objc private func logout() {
        FirebaseAuthService.manager.logoutUser()
    }
        
        @objc private func editProfile() {
            navigationController?.pushViewController(EditProfileViewController(), animated: true)
        }
        
        private func getPostsForThisUser() {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                FirestoreService.manager.getPosts(forUserID: self?.user.uid ?? "") { (result) in
                    switch result {
                    case .success(let posts):
                        self?.posts = posts
                    case .failure(let error):
                        print(":( \(error)")
                    }
                }
            }
        }
        
        private func setupNavigation() {
            self.title = "Profile"
            if isCurrentUser {
                self.navigationItem.rightBarButtonItem =
                    UIBarButtonItem(image: UIImage(systemName: "pencil.circle"), style: .plain, target: self, action: #selector(editProfile))
            }
        }
        
    }

extension ProfileViewController {
    private func addSubviews() {
        view.addSubview(profileImageView)
        view.addSubview(postCountLabel)
    }
    
    private func constrainSubviews() {
        constrainProfileImageView()
        constrainPostCountLabel()
    }
    
    private func constrainProfileImageView() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        [profileImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
         profileImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -100),
         profileImageView.widthAnchor.constraint(equalToConstant: 90),
         profileImageView.heightAnchor.constraint(equalToConstant: 90)].forEach{$0.isActive = true}
    }
    
    private func constrainPostCountLabel() {
        postCountLabel.translatesAutoresizingMaskIntoConstraints = false
        [postCountLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
         postCountLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 100)].forEach{$0.isActive = true}
    }
}

