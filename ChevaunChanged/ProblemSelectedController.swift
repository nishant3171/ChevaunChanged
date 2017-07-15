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
    }
    
    //MARK: CollectionViewSetup
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ProblemSelectedCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 70
        height += 16
        return CGSize(width: view.frame.width, height: height)
    }

}
