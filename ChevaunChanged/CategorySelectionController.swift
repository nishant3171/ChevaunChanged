//
//  CategorySelectionController.swift
//  ChevaunChanged
//
//  Created by Nishant Punia on 05/07/17.
//  Copyright © 2017 MLBNP. All rights reserved.
//

import UIKit
import Firebase

class CategorySelectionController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    let headerId = "headerId"
    
    var category = [String]()
    var categories = ["RELATIONSHIP", "FASHION", "PEOPLE SKILLS", "DESIGN"]
    var categoryImages = [#imageLiteral(resourceName: "RelationshipImage"), #imageLiteral(resourceName: "FashionImage"), #imageLiteral(resourceName: "PeopleSkillsImage"), #imageLiteral(resourceName: "DesignImage")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        collectionView?.allowsMultipleSelection = true
        
        collectionView?.register(CategorySelectionCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(CategorySelectionHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        
        settingUpNavigationBar()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    func settingUpNavigationBar() {
        
        navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.title = "Categories"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneTapped))
    }
    
    func doneTapped() {
        print("DoneTapped")
        
        var valueDictionary = [String: Any]()
        
        for cat in category {
            valueDictionary[cat] = 1
        }
        
        guard let currentUserId = FIRAuth.auth()?.currentUser?.uid else { return }
        
        let ref = FIRDatabase.database().reference().child("categories").child(currentUserId)
        ref.updateChildValues(valueDictionary) { (error, ref) in
            if let error = error {
                print("Unable to select your category preferences", error)
                return
            }
            print("Successfully uploaded category preferences.")
            
            guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
            mainTabBarController.setupViewControllers()
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: CollectionViewSetup
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let indexPaths = collectionView.indexPathsForSelectedItems! as [IndexPath]
        for indexPath in indexPaths {
            print(categories[indexPath.item])
            category.append(categories[indexPath.item])
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CategorySelectionCell
        cell.label = categories[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! CategorySelectionHeader
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 1) / 2
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 98)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    
}
