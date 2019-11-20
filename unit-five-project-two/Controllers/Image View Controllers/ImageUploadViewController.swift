//
//  ImageUploadViewController.swift
//  unit-five-project-two
//
//  Created by Levi Davis on 11/18/19.
//  Copyright © 2019 Levi Davis. All rights reserved.
//

import UIKit
import Photos

class ImageUploadViewController: UIViewController {
    //MARK: UI Objects
    
    var imageURL = URL? = nil
    
    
    lazy var postButton: UIButton = {
        let button = UIButton()
        button.showsTouchWhenHighlighted = true
        button.isEnabled = true
        button.backgroundColor = .white
        button.setTitle("Post", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(postButtonPressed), for: .touchUpInside)
        return button
    }()
    
    //MARK: Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupPostButton()
    }
    
    //MARK: Obj-C Methods
    
    @objc func postButtonPressed() {
        
        
//        guard let user = FirebaseAuthService.manager.currentUser else {
//            showAlert(with: "Error", and: "You must be logged in to create a post")
//            return
//        }
//
//        let newPost = Post(photoURL: <#T##String#>, id: <#T##String#>, creatorID: <#T##String#>)
//        FirestoreService.manager.createPost(post: newPost) { (result) in
//            self.handlePostResponse(withResult: result)
//        }
    }
    
    //MARK: Private methods
    
    private func handlePostResponse(withResult result: Result<Void, Error>) {
        switch result {
        case .success:
            let alertVC = UIAlertController(title: "Yay", message: "New post was added", preferredStyle: .alert)
            
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { [weak self] (action)  in
                DispatchQueue.main.async {
                    self?.navigationController?.popViewController(animated: true)
                }
            }))
            
            present(alertVC, animated: true, completion: nil)
        case let .failure(error):
            print("An error occurred creating the post: \(error)")
        }
    }
    
    private func showAlert(with title: String, and message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    //MARK: UI Setup
    
   
    
    private func setupPostButton() {
        view.addSubview(postButton)
        postButton.translatesAutoresizingMaskIntoConstraints = false
        [postButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
         postButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)].forEach{$0.isActive = true}
    }
    
}

extension ImageUploadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            //MARK: TODO - handle couldn't get image :(
            return
        }
        self.image = image
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            //MARK: TODO - gracefully fail out without interrupting UX
            return
        }
        
        FirebaseStorageService.manager.storeImage(image: imageData, completion: { [weak self] (result) in
            switch result{
            case .success(let url):
                //Note - defer UI response, update user image url in auth and in firestore when save is pressed
                self?.imageURL = url
            case .failure(let error):
                //MARK: TODO - defer image not save alert, try again later. maybe make VC "dirty" to allow user to move on in nav stack
                print(error)
            }
        })
        dismiss(animated: true, completion: nil)
    }
}
