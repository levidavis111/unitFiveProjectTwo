//
//  EditProfileViewController.swift
//  unit-five-project-two
//
//  Created by Levi Davis on 11/19/19.
//  Copyright © 2019 Levi Davis. All rights reserved.
//

import UIKit
import Photos

class EditProfileViewController: UITabBarController {
    
//    MARK: - Local Variables
    
    var settingFromLogin = false
    
    var image = UIImage() {
        didSet {
            self.imageView.image = image
        }
    }
    
    var imageURL: URL? = nil
    
//    MARK: - Instantiate UI Objects
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.image = UIImage(systemName: "person.circle.fill")
        return imageView
    }()
    
    lazy var addImageButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add Image", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "Verdana-Bold", size: 14)
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(addImagePressed), for: .touchUpInside)
        return button
    }()
    
    lazy var userNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter User Name"
        textField.font = UIFont(name: "Verdana", size: 14)
        textField.backgroundColor = .white
        textField.borderStyle = .bezel
        textField.layer.cornerRadius = 5
        textField.autocorrectionType = .no
        return textField
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save Profile", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "Verdana-Bold", size: 14)
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(savePressed), for: .touchUpInside)
        return button
    }()
    
//    MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        addSubviews()
        setupViews()
    }
    
//    MARK: - Objc Methods
    
    @objc private func savePressed(){
        guard let userName = userNameTextField.text, let imageURL = imageURL else {
            return
        }
        
        FirebaseAuthService.manager.updateUserFields(userName: userName, photoURL: imageURL) { (result) in
            switch result {
            case .success():
                FirestoreService.manager.updateCurrentUser(userName: userName, photoURL: imageURL) { [weak self] (nextResult) in
                    switch nextResult {
                    case .success():
                        self?.handleNavigationAwayFromVC()
                    case .failure(let error):
                        print(error)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
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
    
//    MARK: - Private Methods
    
    private func showAlert(with title: String, and message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
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
    
    private func handleNavigationAwayFromVC() {
        if settingFromLogin {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let sceneDelegate = windowScene.delegate as? SceneDelegate, let window = sceneDelegate.window
                else {
                    return
            }
            UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromBottom, animations: {
                window.rootViewController = TabBarViewController()
            }, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
//    MARK: - Setup UI Elements
    
    private func addSubviews() {
        view.addSubview(imageView)
        view.addSubview(userNameTextField)
        view.addSubview(addImageButton)
        view.addSubview(saveButton)
    }
    
    private func setupViews() {
        setupImageView()
        setupUserNameTextField()
        setupAddImageButton()
        setupSaveButton()
    }
    
    private func setupImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -100),
            imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            imageView.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func setupUserNameTextField() {
        userNameTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userNameTextField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30),
            userNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userNameTextField.heightAnchor.constraint(equalToConstant: 30),
            userNameTextField.widthAnchor.constraint(equalToConstant: view.bounds.width / 2)
        ])
    }
    
    private func setupAddImageButton() {
        addImageButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addImageButton.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor, constant: 50),
            addImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addImageButton.heightAnchor.constraint(equalToConstant: 50),
            addImageButton.widthAnchor.constraint(equalToConstant: view.bounds.width / 3)
        ])
    }
    
    private func setupSaveButton() {
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        [saveButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
         saveButton.topAnchor.constraint(equalTo: addImageButton.bottomAnchor, constant: 50)].forEach{$0.isActive = true}
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        self.image = image
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
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
}
