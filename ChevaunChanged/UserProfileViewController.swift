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
    var categories = [String]()
    let cellId = "cellId"
    let headerId = "headerId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 64, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 64, right: 0)
        
        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView?.register(CategoryCollectionCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView?.reloadData()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        fetchUser()
        fetchCategories()
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
//        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        
        let uid = user?.uid ?? FIRAuth.auth()?.currentUser?.uid ?? ""
        
        FIRDatabase.fetchUserWithUID(uid: uid) { (user) in
            self.user = user
            
            print(user.profileImageUrl)
            
            if let username = self.user?.username {
                self.navigationItem.title = username
                self.collectionView?.reloadData()
            } else {
                self.navigationItem.title = "Profile"
                self.collectionView?.reloadData()
            }
        }
    }
    
    fileprivate func fetchCategories() {
        
        guard let currentUserId = FIRAuth.auth()?.currentUser?.uid else { return }
        let categoriesRef = FIRDatabase.database().reference().child("categories").child(currentUserId)
        categoriesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let categoriesDictionary = snapshot.value as? [String: Any] else { return }
            categoriesDictionary.forEach({ (key, value) in
                print(key)
                self.categories.append(key)
                print(self.categories.count)
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            })
        }) { (error) in
            print("Unable to set your selected categories", error)
        }
        
    }
    
    //MARK: CollectionViewSetup
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(categories.count)
        return categories.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CategoryCollectionCell
        cell.category = categories[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 46)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! UserProfileHeader
        header.user = user
        header.completion = {
            let editProfileController = EditProfileController()
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(editProfileController, animated: false)
            }
        }
        header.chatController = {
            let expertsChatController = ExpertsChatController(collectionViewLayout: UICollectionViewFlowLayout())
            expertsChatController.user = self.user
            expertsChatController.title = self.user?.username
            self.navigationController?.pushViewController(expertsChatController, animated: true)
        }
    
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        
        
        var headerHeight: CGFloat = 250
        headerHeight += 32 + 24 + 4 + 32 + 44 + 32 + 20
        
        if let descriptionText = user?.description {
            headerHeight += estimatedFrameForText(text: descriptionText).height
        }
        
        
        return CGSize(width: view.frame.width, height: headerHeight)
    }
    
    fileprivate func estimatedFrameForText(text: String) -> CGRect {
        
        let size = CGSize(width: 200, height: 10000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
    }
}
