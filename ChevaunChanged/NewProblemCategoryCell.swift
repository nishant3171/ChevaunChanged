//
//  NewProblemCell.swift
//  ChevaunChanged
//
//  Created by Nishant Punia on 29/05/17.
//  Copyright © 2017 MLBNP. All rights reserved.
//

import UIKit

class NewProblemCategoryCell: UICollectionViewCell {
    
    var label: String? {
        didSet {
            categoryLabel.text = label
        }
    }
    
    var categoryImage: UIImage? {
        didSet {
            categoryImageView.image = categoryImage
        }
    }
    
    let categoryImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "FAMILY"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(categoryImageView)
        addSubview(categoryLabel)
        
        categoryImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, centerX: nil, centerY: nil, topPadding: 0, leftPadding: 0, bottomPadding: 0, rightPadding: 0, height: 0, width: 0)
        
        categoryLabel.anchor(top: nil, left: nil, bottom: nil, right: nil, centerX: categoryImageView.centerXAnchor, centerY: categoryImageView.centerYAnchor, topPadding: 0, leftPadding: 0, bottomPadding: 0, rightPadding: 0, height: 0, width: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
