//
//  ProblemSelectedController.swift
//  ChevaunChanged
//
//  Created by Nishant Punia on 07/07/17.
//  Copyright © 2017 MLBNP. All rights reserved.
//

import UIKit
import Firebase

class ProblemSelectedController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var categoryLabel: String?
    var users = [User]()
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = categoryLabel
        
        collectionView?.backgroundColor = .orange
        collectionView?.register(ProblemSelectedCell.self, forCellWithReuseIdentifier: cellId)
        
        fetchExperts()
    }
    
    fileprivate func fetchExperts() {
        guard let categoryString = categoryLabel else { return }
        
        let ref = FIRDatabase.database().reference().child("selectedCategory").child(categoryString)
        ref.observe(.value, with: { (snapshot) in
            guard let valueDictionary = snapshot.value as? [String: Any] else { return }
            
            valueDictionary.forEach({ (key, value) in
                
                if key == FIRAuth.auth()?.currentUser?.uid {
                    return
                }
                
                FIRDatabase.fetchUserWithUID(uid: key, completion: { (user) in
                    self.users.append(user)
                    self.collectionView?.reloadData()
                })
        
            })
        }) { (error) in
            print("Unable to find experts", error)
        }
        
    }
    
    //MARK: CollectionViewSetup
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = users[indexPath.item]
        
        let userProfileController = UserProfileViewController(collectionViewLayout: UICollectionViewFlowLayout())
        userProfileController.user = user
        navigationController?.pushViewController(userProfileController, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ProblemSelectedCell
        cell.user = users[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 70
        height += 16
        return CGSize(width: view.frame.width, height: height)
    }

}
