//
//  FeedViewController.swift
//  unit-five-project-two
//
//  Created by Levi Davis on 11/18/19.
//  Copyright © 2019 Levi Davis. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    
    var posts = [Post]()
    let user = FirebaseAuthService.manager.currentUser
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(<#T##cellClass: AnyClass?##AnyClass?#>, forCellWithReuseIdentifier: <#T##String#>)
        return collectionView
    }()
    
    /**
     let layout = UICollectionViewFlowLayout()
     layout.scrollDirection = .horizontal
     let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
     collectionView.backgroundColor = .clear
     collectionView.register(MapCollectionViewCell.self, forCellWithReuseIdentifier: ReuseIdentifier.mapCollectionViewCell.rawValue)
     */

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadPosts()
    }
    
    private func loadPosts() {
        guard let user = user else {return}
        FirestoreService.manager.getPosts(forUserID: user.uid) { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let posts):
                self.posts = posts
                print(posts)
            }
        }
    }

}
