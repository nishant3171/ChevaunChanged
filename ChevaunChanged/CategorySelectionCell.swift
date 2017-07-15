//
//  CategorySelectionCell.swift
//  ChevaunChanged
//
//  Created by Nishant Punia on 06/07/17.
//  Copyright © 2017 MLBNP. All rights reserved.
//

import UIKit

class CategorySelectionCell: UICollectionViewCell {
    
    var label: String? {
        didSet {
            categoryLabel.text = label
        }
    }
    
    override var isSelected: Bool {
        didSet {
            selectedView.backgroundColor = isSelected ? UIColor(white: 1, alpha: 0.6) : UIColor(white: 1, alpha: 0)
        }
    }
    
    let selectedView: UIView = {
        let view = UIView()
        return view
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "FAMILY"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .blue
        
        addSubview(categoryLabel)
        addSubview(selectedView)
        
        categoryLabel.anchor(top: nil, left: nil, bottom: nil, right: nil, centerX: centerXAnchor, centerY: centerYAnchor, topPadding: 0, leftPadding: 0, bottomPadding: 0, rightPadding: 0, height: 0, width: 0)
        
        selectedView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, centerX: nil, centerY: nil, topPadding: 0, leftPadding: 0, bottomPadding: 0, rightPadding: 0, height: 0, width: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
