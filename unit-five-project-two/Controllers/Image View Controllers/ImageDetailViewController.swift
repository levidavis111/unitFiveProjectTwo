//
//  ImageDetailViewController.swift
//  unit-five-project-two
//
//  Created by Levi Davis on 11/18/19.
//  Copyright © 2019 Levi Davis. All rights reserved.
//

import UIKit

class ImageDetailViewController: UIViewController {
    
    var imageURL: String!
    var createdBy: String!
    var dateCreated: String!
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var createdByLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .black
        label.text = "Created by: \(self.createdBy ?? "No Username")"
        return label
    }()
    
    lazy var createdDateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .black
        if let dateCreated = self.dateCreated {
            label.text = "Date Created: \(dateCreated.components(separatedBy: " ")[0])"
        } else {
            label.text = "No Date"
        }
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubviews()
        constrainSubviews()
        loadImageView()
        // Do any additional setup after loading the view.
    }
    
    private func addSubviews() {
        view.addSubview(imageView)
        view.addSubview(createdByLabel)
        view.addSubview(createdDateLabel)
    }
    
    private func constrainSubviews() {
        constrainImageView()
        constrainCreatedByLabel()
        constrainCreatedDateLabel()
    }
    
    private func constrainImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        [imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
         imageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -100),
         imageView.heightAnchor.constraint(equalToConstant: 150),
         imageView.widthAnchor.constraint(equalToConstant: 200)].forEach{$0.isActive = true}
    }
    
    public func constrainCreatedByLabel() {
        createdByLabel.translatesAutoresizingMaskIntoConstraints = false
        [createdByLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
         createdByLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 50),
         createdByLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor)].forEach{$0.isActive = true}
    }
    
    public func constrainCreatedDateLabel() {
        createdDateLabel.translatesAutoresizingMaskIntoConstraints = false
        [createdDateLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
         createdDateLabel.topAnchor.constraint(equalTo: createdByLabel.bottomAnchor, constant: 50),
         createdDateLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor)].forEach{$0.isActive = true}
    }
    
    private func loadImageView() {
        ImageManager.manager.getImage(urlStr: imageURL) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let image):
                    self.imageView.image = image
                }

            }
            
        }
    }

}
