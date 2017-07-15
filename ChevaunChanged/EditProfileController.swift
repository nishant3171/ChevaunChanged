//
//  EditProfileController.swift
//  ChevaunChanged
//
//  Created by Nishant Punia on 10/07/17.
//  Copyright © 2017 MLBNP. All rights reserved.
//

import UIKit
import Firebase

class EditProfileController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let cellId = "cellId"
    var scrollView: UIScrollView!
    var containerView = UIView()
    
    let userProfileImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+ Add Image", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = .white
        button.imageView?.contentMode = .scaleAspectFill
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(profileImageButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let userProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Name"
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.cornerRadius = 5
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 0.5
        return textView
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
        containerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .mainGray()
        view.isUserInteractionEnabled = true
        
        usernameTextField.delegate = self
        nameTextField.delegate = self
        
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height * 2)
        scrollView.keyboardDismissMode = .interactive
        self.view.addSubview(scrollView)
    
        containerView = UIView()
        scrollView.addSubview(containerView)
        
        anchoringViewsOnContainerView()
        settingUpNavigationBar()
        
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        observeKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        NotificationCenter.default.removeObserver(self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    fileprivate func settingUpNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveButtonTapped))
        navigationItem.title = "Edit Profile"
    }
    
    fileprivate func anchoringViewsOnContainerView() {
        
        containerView.addSubview(userProfileImageButton)
        containerView.addSubview(usernameLabel)
        containerView.addSubview(usernameTextField)
        containerView.addSubview(nameLabel)
        containerView.addSubview(nameTextField)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(descriptionTextView)
        
        userProfileImageButton.anchor(top: containerView.topAnchor, left: nil, bottom: nil, right: nil, centerX: containerView.centerXAnchor, centerY: nil, topPadding: 16, leftPadding: 0, bottomPadding: 0, rightPadding: 0, height: 150, width: 281)
        
        usernameLabel.anchor(top: userProfileImageButton.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, centerX: nil, centerY: nil, topPadding: 16, leftPadding: 16, bottomPadding: 0, rightPadding: 16, height: 0, width: 0)
        
        usernameTextField.anchor(top: usernameLabel.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, centerX: nil, centerY: nil, topPadding: 8, leftPadding: 16, bottomPadding: 0, rightPadding: 16, height: 48, width: 0)
        
        nameLabel.anchor(top: usernameTextField.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, centerX: nil, centerY: nil, topPadding: 16, leftPadding: 16, bottomPadding: 0, rightPadding: 16, height: 0, width: 0)
        
        nameTextField.anchor(top: nameLabel.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, centerX: nil, centerY: nil, topPadding: 8, leftPadding: 16, bottomPadding: 0, rightPadding: 16, height: 48, width: 0)
        
        descriptionLabel.anchor(top: nameTextField.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, centerX: nil, centerY: nil, topPadding: 16, leftPadding: 16, bottomPadding: 0, rightPadding: 16, height: 0, width: 0)
        
        descriptionTextView.anchor(top: descriptionLabel.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, centerX: nil, centerY: nil, topPadding: 8, leftPadding: 16, bottomPadding: 0, rightPadding: 16, height: 100, width: 0)
    }
    
    
//    func profileImageButtonTapped() {
//        print("I am being tapped.")
//    }
    
    func profileImageButtonTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            userProfileImageButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            userProfileImageButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func saveButtonTapped() {
        
        let imageName = NSUUID().uuidString
        
        
        //if usernamefield is empty, use previous username.
        guard let username = usernameTextField.text else { return }
        guard let currentUserId = FIRAuth.auth()?.currentUser?.uid else { return }
        
        print(currentUserId)
        guard let profileImage = userProfileImageButton.imageView?.image else { return }
        guard let data = UIImageJPEGRepresentation(profileImage, 0.4) else { return }
        
        let imageStorage = FIRStorage.storage().reference().child("profile-pics").child(imageName)
        imageStorage.put(data, metadata: nil) { (metadata, error) in
            if let error = error {
                print("Unable to store profile image:", error)
                return
            }
            
            guard let profileImageUrl = metadata?.downloadURL()?.absoluteString else { return }
            print(profileImageUrl)
            
            let valuesDictionary = ["username": username, "name": self.nameTextField.text ?? "","description": self.descriptionTextView.text, "profileImageUrl": profileImageUrl] as [String : Any]
            
            let reference = FIRDatabase.database().reference().child("users").child(currentUserId)
            
            reference.updateChildValues(valuesDictionary) { (error, ref) in
                if let error = error {
                    print("Unable to update user information.", error)
                    return
                }
                print("Successfully updated the information.")
                
                DispatchQueue.main.async {
                    _ = self.navigationController?.popViewController(animated: true)
                }
                
            }
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    fileprivate func observeKeyboardNotifications() {
        let center = NotificationCenter.default
        
        center.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(notification: Notification) {
        
        if usernameTextField.isEditing && UIDevice.current.orientation.isPortrait {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.frame = CGRect(x: 0, y: -50, width: self.view.frame.width, height: self.view.frame.height)
            }, completion: nil)

        } else {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= keyboardSize.height
                }
            }
        }
        
    }
    
    func keyboardWillHide(notification: Notification) {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)

    }
    
}
