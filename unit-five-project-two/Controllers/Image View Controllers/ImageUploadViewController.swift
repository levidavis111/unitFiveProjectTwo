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
//   MARK: - Local Variables
    
    var image = UIImage(named: "default") {
        didSet {
            selectedImageView.image = image
        }
    }
    
    var imageURL: URL? = nil
    
     //MARK: - UI Objects
    
    lazy var selectedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = self.image
        return imageView
    }()
    
    lazy var addImageButton: UIButton = {
        let button = UIButton()
        button.showsTouchWhenHighlighted = true
        button.isEnabled = true
        button.backgroundColor = .white
        button.setTitle("Add Image", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(addImagePressed), for: .touchUpInside)
        return button
    }()
    
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
        addSubviews()
        setupImageView()
        setupAddImageButton()
        setupPostButton()
    }
    
    //MARK: Objc Methods
    
    @objc private func addImagePressed() {
        switch PHPhotoLibrary.authorizationStatus() {
        case .notDetermined, .denied, .restricted:
            PHPhotoLibrary.requestAuthorization({[weak self] status in
                switch status {
                case .authorized:
                    self?.presentPhotoPickerController()
                case .denied:
                    print("Denied photo library permissions")
                default:
                    print("No usable status")
                }
            })
        default:
            presentPhotoPickerController()
        }
    }
    
    @objc func postButtonPressed() {
        storeImage()
        createPost()
    }
    
    //MARK: Private methods
    
    private func createPost() {

        guard let photoURL = self.imageURL else {return}
        let photoURLString = "\(photoURL)"
        guard let user = FirebaseAuthService.manager.currentUser else {return}
        
        let newPost = Post(photoURL: photoURLString, creatorID: user.uid)
        FirestoreService.manager.createPost(post: newPost) { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(()):
                self.showAlert(with: "Posted!", and: "Yay!")

            }
        }
        
    }
    
    private func storeImage() {
        guard let image = self.image else {
            return
        }

        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            return
        }
        FirebaseStorageService.manager.storeImage(image: imageData, completion: { [weak self] (result) in
            switch result{
            case .success(let url):
                self?.imageURL = url
            case .failure(let error):
                print(error)
            }
        })
        dismiss(animated: true, completion: nil)
    }
    
    private func presentPhotoPickerController() {
        DispatchQueue.main.async{
            let imagePickerViewController = UIImagePickerController()
            imagePickerViewController.delegate = self
            imagePickerViewController.sourceType = .photoLibrary
            imagePickerViewController.allowsEditing = true
            self.present(imagePickerViewController, animated: true, completion: nil)
        }
    }
    
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
    
    private func addSubviews() {
        view.addSubview(selectedImageView)
        view.addSubview(postButton)
        view.addSubview(addImageButton)
    }
    
    private func setupImageView() {
        selectedImageView.translatesAutoresizingMaskIntoConstraints = false
        [selectedImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
         selectedImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -100),
         selectedImageView.heightAnchor.constraint(equalToConstant: 200),
         selectedImageView.widthAnchor.constraint(equalToConstant: 200)].forEach{$0.isActive = true}
    }
    
    private func setupPostButton() {
        postButton.translatesAutoresizingMaskIntoConstraints = false
        [postButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
         postButton.topAnchor.constraint(equalTo: addImageButton.bottomAnchor, constant: 30)].forEach{$0.isActive = true}
    }
    
    private func setupAddImageButton() {
        addImageButton.translatesAutoresizingMaskIntoConstraints = false
        [addImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
         addImageButton.topAnchor.constraint(equalTo: selectedImageView.bottomAnchor, constant: 30)].forEach{$0.isActive = true}
    }
    
}

extension ImageUploadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        self.image = image
        
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            return
        }
        
        FirebaseStorageService.manager.storeImage(image: imageData, completion: { [weak self] (result) in
            switch result{
            case .success(let url):
                //Note - defer UI response, update user image url in auth and in firestore when save is pressed
                self?.imageURL = url
            case .failure(let error):
                print(error)
            }
        })
        dismiss(animated: true, completion: nil)
    }
}
