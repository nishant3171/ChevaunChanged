//
//  UserProfileHeader.swift
//  ChevaunChanged
//
//  Created by Nishant Punia on 04/07/17.
//  Copyright © 2017 MLBNP. All rights reserved.
//

import UIKit
import Firebase

class UserProfileHeader: UICollectionViewCell {
    
    var completion: (() -> Void)?
    
    lazy var editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(.mainBlue(), for: .normal)
        button.layer.borderColor = UIColor.mainBlue().cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .white
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
        
        addSubview(profileImageView)
        addSubview(editButton)
        
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, centerX: nil, centerY: nil, topPadding: 0, leftPadding: 0, bottomPadding: 0, rightPadding: 0, height: 250, width: 0)
        
        editButton.anchor(top: nil, left: nil, bottom: profileImageView.bottomAnchor, right: rightAnchor, centerX: nil, centerY: nil, topPadding: 0, leftPadding: 0, bottomPadding: 16, rightPadding: 16, height: 30, width: 50)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func editButtonTapped() {
        completion?()
        print("I am not working.")
    }
    
}
