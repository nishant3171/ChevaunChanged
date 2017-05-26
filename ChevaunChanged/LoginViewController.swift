//
//  LoginViewController.swift
//  ChevaunChanged
//
//  Created by Nishant Punia on 25/05/17.
//  Copyright © 2017 MLBNP. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate {
    
    let logoContainerView: UIView = {
        let view = UIView()
        let logoView = UIImageView()
        logoView.image = #imageLiteral(resourceName: "ChevaunLogo")
        logoView.contentMode = .scaleAspectFill
        view.addSubview(logoView)
        
        logoView.anchor(top: nil, left: nil, bottom: nil, right: nil, centerX: view.centerXAnchor, centerY: view.centerYAnchor, topPadding: 0, leftPadding: 0, bottomPadding: 0, rightPadding: 0, height: 51, width: 250)
        
        view.backgroundColor = UIColor.rgb(red: 24, green: 118, blue: 216)
        return view
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(inputFormValid), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.isSecureTextEntry = true
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(inputFormValid), for: .editingChanged)
        return tf
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.layer.cornerRadius = 5.0
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    let orImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "OR")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let facebookButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.rgb(red: 59, green: 89, blue: 152)
        button.layer.cornerRadius = 5
        
        let facebookImageView = UIImageView()
        facebookImageView.image = #imageLiteral(resourceName: "Facebook")
        facebookImageView.contentMode = .scaleAspectFill
        
        button.addSubview(facebookImageView)
        
        facebookImageView.anchor(top: nil, left: button.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: button.centerYAnchor, topPadding: 0, leftPadding: 15, bottomPadding: 0, rightPadding: 0, height: 0, width: 0)
        
        let facebookLabel = UILabel()
        facebookLabel.text = "Facebook"
        facebookLabel.font = UIFont.boldSystemFont(ofSize: 16)
        facebookLabel.textColor = .white
        
        button.addSubview(facebookLabel)
        
        facebookLabel.anchor(top: nil, left: facebookImageView.rightAnchor, bottom: nil, right: nil, centerX: nil, centerY: button.centerYAnchor, topPadding: 0, leftPadding: 15, bottomPadding: 0, rightPadding: 0, height: 0, width: 0)
        
        button.addTarget(self, action: #selector(facebookButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    let googleButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        
        let googleImageView = UIImageView()
        googleImageView.image = #imageLiteral(resourceName: "GoogleLogo")
        googleImageView.contentMode = .scaleAspectFill
        
        button.addSubview(googleImageView)
        
        googleImageView.anchor(top: nil, left: button.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: button.centerYAnchor, topPadding: 0, leftPadding: 15, bottomPadding: 0, rightPadding: 0, height: 0, width: 0)
        
        let googleLabel = UILabel()
        googleLabel.text = "Google"
        googleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        googleLabel.textColor = .black
        
        button.addSubview(googleLabel)
        
        googleLabel.anchor(top: nil, left: googleImageView.rightAnchor, bottom: nil, right: nil, centerX: nil, centerY: button.centerYAnchor, topPadding: 0, leftPadding: 15, bottomPadding: 0, rightPadding: 0, height: 0, width: 0)
        
        button.addTarget(self, action: #selector(googleButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedString = NSMutableAttributedString(string: "Don't have an account? ", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.darkGray])
        attributedString.append(NSAttributedString(string: "Sign Up", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.rgb(red: 24, green: 118, blue: 216)]))
        button.setAttributedTitle(attributedString, for: .normal)
        button.addTarget(self, action: #selector(handlingSignUpController), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.rgb(red: 243, green: 244, blue: 244)
        navigationController?.isNavigationBarHidden = true
        
        view.addSubview(logoContainerView)
        view.addSubview(signUpButton)
        
        logoContainerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, centerX: nil, centerY: nil, topPadding: 0, leftPadding: 0, bottomPadding: 0, rightPadding: 0, height: 150, width: 0)
        
        signUpButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, centerX: view.centerXAnchor
            , centerY: nil, topPadding: 0, leftPadding: 0, bottomPadding: 12, rightPadding: 0, height: 50, width: 0)
        
        addingLoginForm()
        addingOtherLoginButtons()
        
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    fileprivate func addingOtherLoginButtons() {
        let stackView = UIStackView(arrangedSubviews: [facebookButton, googleButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        view.addSubview(stackView)
        
        stackView.anchor(top: orImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, centerX: nil, centerY: nil, topPadding: 30, leftPadding: 40, bottomPadding: 0, rightPadding: 40, height: 44, width: 0)
    }
    
    func inputFormValid() {
        let inputFormValid = emailTextField.text?.characters.count ?? 0 > 0 && passwordTextField.text?.characters.count ?? 0 > 0
        
        if inputFormValid {
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
    }
    
    fileprivate func addingLoginForm() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        view.addSubview(stackView)
        view.addSubview(orImageView)
        
        stackView.anchor(top: logoContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, centerX: nil, centerY: nil, topPadding: 40, leftPadding: 40, bottomPadding: 0, rightPadding: 40, height: 140, width: 0)
        
        orImageView.anchor(top: stackView.bottomAnchor, left: stackView.leftAnchor, bottom: nil, right: stackView.rightAnchor, centerX: nil, centerY: nil, topPadding: 30, leftPadding: 0, bottomPadding: 0, rightPadding: 0, height: 0, width: 0)
    }
    
    func loginButtonTapped() {
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if let err = error {
                print("Error logging in the user:", err)
                return
            }
            print("Logged in with user", user?.uid ?? "")
            
            guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
            mainTabBarController.setupViewControllers()
            
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    func facebookButtonTapped() {
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("Unable to authenticate with Facebook.")
            } else if result?.isCancelled == true {
                print("You are not giving the permissions.")
            } else {
                print("Successfully authenticated")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuthentication(credential)
            }
        }
    }
    
    func googleButtonTapped() {
        GIDSignIn.sharedInstance().signIn()
    }
    
    func firebaseAuthentication(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if let error = error {
                print("Unable to create new user:", error)
            } else {
                guard let uid = user?.uid else { return }
                let userData = ["username": "Profile"]
                let values = [uid: userData]
                FIRDatabase.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (err, ref) in
                    if let err = err {
                        print("Unable to store user info: ", err)
                        return
                    }
                    print("Check Firebase Storage.")
                    
                    guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
                    mainTabBarController.setupViewControllers()
                    
                    self.dismiss(animated: true, completion: nil)
                })
                
            }
        })
    }
    
    func handlingSignUpController() {
        
        let signUpController = SignUpViewController()
        navigationController?.pushViewController(signUpController, animated: true)
        
    }

}
