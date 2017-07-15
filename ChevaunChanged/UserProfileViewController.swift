//
//  UserProfileViewController.swift
//  ChevaunChanged
//
//  Created by Nishant Punia on 24/05/17.
//  Copyright © 2017 MLBNP. All rights reserved.
//

import UIKit
import Firebase

class UserProfileViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var user: User?
    let cellId = "cellId"
    let headerId = "headerId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .brown
        
        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        fetchUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        settingUpClearNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        settingUpNormalNavigationBar()
    }
    
    
    //Consider Extension: NavigationBar for setting it up.
    func settingUpClearNavigationBar() {
        
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain
            , target: nil, action: nil)
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Settings").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(settingsButtonTapped))
        
    }
    
    func settingUpNormalNavigationBar() {
        
        navigationController?.navigationBar.barStyle = UIBarStyle.default
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = nil
        
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
    
    //MARK: CollectionViewSetup
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! UserProfileHeader
        header.completion = {
            let editProfileController = EditProfileController()
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(editProfileController, animated: false)
            }
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 300)
    }
}
