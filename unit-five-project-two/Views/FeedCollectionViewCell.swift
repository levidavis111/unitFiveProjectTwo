//
//  FeedCollectionViewCell.swift
//  unit-five-project-two
//
//  Created by Levi Davis on 11/20/19.
//  Copyright © 2019 Levi Davis. All rights reserved.
//

import UIKit

class FeedCollectionViewCell: UICollectionViewCell {
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        constrainSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        contentView.addSubview(imageView)
    }
    
    private func constrainSubviews() {
        constrainImageView()
    }
    
    private func constrainImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        [imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
         imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
         imageView.heightAnchor.constraint(equalToConstant: 200),
         imageView.widthAnchor.constraint(equalToConstant: 300)].forEach{$0.isActive = true}
    }
    
}

