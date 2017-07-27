//
//  RecentChatsCell.swift
//  ChevaunChanged
//
//  Created by Nishant Punia on 24/07/17.
//  Copyright © 2017 MLBNP. All rights reserved.
//

import UIKit
import Firebase

class RecentChatsCell: UICollectionViewCell {
    
    var message: Message? {
        didSet {
            guard let uid = message?.chatPartnerId() else { return }
            FIRDatabase.fetchUserWithUID(uid: uid) { (user) in
                
                self.profileImageView.settingUpImage(urlString: user.profileImageUrl)
                self.usernameLabel.text = user.username
            }
            
        }
    }
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.backgroundColor = .white
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Sikander Khan"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
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
