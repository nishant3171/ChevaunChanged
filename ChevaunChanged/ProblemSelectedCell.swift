//
//  ProblemSelectedCell.swift
//  ChevaunChanged
//
//  Created by Nishant Punia on 07/07/17.
//  Copyright © 2017 MLBNP. All rights reserved.
//

import UIKit

class ProblemSelectedCell: UICollectionViewCell {
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .white
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Sikander Khan"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .blue
        
        addSubview(profileImageView)
        addSubview(usernameLabel)
        
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, centerX: nil, centerY: nil, topPadding: 8, leftPadding: 8, bottomPadding: 8, rightPadding: 0, height: 70, width: 70)
        profileImageView.layer.cornerRadius = 70 / 2
        
        usernameLabel.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, centerX: nil, centerY: nil, topPadding: 8, leftPadding: 16, bottomPadding: 8, rightPadding: 8, height: 24, width: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
