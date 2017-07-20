//
//  CategoryCollectionCell.swift
//  ChevaunChanged
//
//  Created by Nishant Punia on 17/07/17.
//  Copyright © 2017 MLBNP. All rights reserved.
//

import UIKit

class CategoryCollectionCell: UICollectionViewCell {
    
    var category: String? {
        didSet {
            categoryLabel.text = category
        }
    }
    
    let categoryLabel: CategoriesLabel = {
        let label = CategoriesLabel()
        label.text = "Marriage"
        label.textColor = .mainBlue()
        label.layer.borderColor = UIColor.mainBlue().cgColor
        label.layer.borderWidth = 2
        label.layer.cornerRadius = 4
        label.sizeToFit()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(categoryLabel)
        
        categoryLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, centerX: nil, centerY: nil, topPadding: 4, leftPadding: 16, bottomPadding: 4, rightPadding: 0, height: 0, width: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
