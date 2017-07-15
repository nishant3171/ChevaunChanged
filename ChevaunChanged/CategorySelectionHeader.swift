//
//  CategorySelectionHeader.swift
//  ChevaunChanged
//
//  Created by Nishant Punia on 06/07/17.
//  Copyright © 2017 MLBNP. All rights reserved.
//

import UIKit

class CategorySelectionHeader: UICollectionViewCell {
    
    let selectCategoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose one or more category in which you would like to help."
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(selectCategoryLabel)
        
        selectCategoryLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right:rightAnchor, centerX: nil, centerY: nil, topPadding: 16, leftPadding: 8, bottomPadding: 0, rightPadding: 8, height: 50, width: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
