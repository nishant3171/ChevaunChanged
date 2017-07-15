//
//  NewProblemViewController.swift
//  ChevaunChanged
//
//  Created by Nishant Punia on 25/05/17.
//  Copyright © 2017 MLBNP. All rights reserved.
//

import UIKit

class NewProblemViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let categoryCell = "Category"
    var categories = ["RELATIONSHIP", "FASHION", "PEOPLE SKILLS", "DESIGN"]
    var categoryImages = [#imageLiteral(resourceName: "RelationshipImage"), #imageLiteral(resourceName: "FashionImage"), #imageLiteral(resourceName: "PeopleSkillsImage"), #imageLiteral(resourceName: "DesignImage")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.delegate = self
        collectionView?.alwaysBounceVertical = true
        
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        
        collectionView?.register(NewProblemCategoryCell.self, forCellWithReuseIdentifier: categoryCell)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func cancelButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryCell, for: indexPath) as! NewProblemCategoryCell
//        cell.backgroundColor = .purple
        cell.label = categories[indexPath.item]
        cell.categoryImage = categoryImages[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let problemSelectedController = ProblemSelectedController(collectionViewLayout: UICollectionViewFlowLayout())
        problemSelectedController.categoryLabel = categories[indexPath.item]
        navigationController?.pushViewController(problemSelectedController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    
}
