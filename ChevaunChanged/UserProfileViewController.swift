//
//  UserProfileViewController.swift
//  ChevaunChanged
//
//  Created by Nishant Punia on 24/05/17.
//  Copyright © 2017 MLBNP. All rights reserved.
//

import UIKit
import Firebase

class UserProfileViewController: UICollectionViewController {
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .brown
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Settings"), style: .plain, target: self, action: #selector(settingsButtonTapped))
        
        fetchUser()
    }
    
    func settingsButtonTapped() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let logOutAction = UIAlertAction(title: "Log Out", style: .destructive) { (_) in
            do {
                try FIRAuth.auth()?.signOut()
                let loginController = LoginViewController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true, completion: nil)
            } catch let logOutError {
                print("Unable to log out:", logOutError)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(logOutAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    fileprivate func fetchUser() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        
        FIRDatabase.database().reference().child("users").child(uid).observe(.value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            self.user = User(dictionary: dictionary)
            if let username = self.user?.username {
                self.navigationItem.title = username
            } else {
                self.navigationItem.title = "Profile"
            }
        }) { (error) in
            print("Unable to fetch user:", error)
        }
    }
}

struct User {
    var username: String
    
    init(dictionary: [String: Any]) {
        self.username = dictionary["username"] as? String ?? ""
    }
}
