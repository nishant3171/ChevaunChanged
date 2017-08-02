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
                self.lastMessageLabel.text = self.message?.message
                
                guard let timeStampDate = self.message?.creationDate else { return }
//                let finalDate = Date().timeIntervalSince(timeStampDate)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm:ss a"
                
                self.timeLabel.text = dateFormatter.string(from: timeStampDate)
                
            }
            
        }
    }
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.backgroundColor = .black
//        iv.image = #imageLiteral(resourceName: "MainMedalSelected")
        
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "HH:MM:SS"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .darkGray
        label.textAlignment = .right
        return label
    }()
    
    let lastMessageLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(white: 0, alpha: 0.6)
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(profileImageView)
        addSubview(usernameLabel)
        addSubview(timeLabel)
        addSubview(lastMessageLabel)
        
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, centerX: nil, centerY: nil, topPadding: 8, leftPadding: 8, bottomPadding: 8, rightPadding: 0, height: 70, width: 70)
        profileImageView.layer.cornerRadius = 70 / 2
        
        usernameLabel.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: timeLabel.rightAnchor, centerX: nil, centerY: nil, topPadding: 8, leftPadding: 16, bottomPadding: 8, rightPadding: 4, height: 24, width: 0)
        
        timeLabel.anchor(top: topAnchor, left: nil, bottom: usernameLabel.bottomAnchor, right: rightAnchor, centerX: nil, centerY: nil, topPadding: 8, leftPadding: 0, bottomPadding: 0, rightPadding: 8, height: 0, width: 80)
        
        lastMessageLabel.anchor(top: usernameLabel.bottomAnchor, left: profileImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, centerX: nil, centerY: nil, topPadding: 4, leftPadding: 16, bottomPadding: 8, rightPadding: 8, height: 0, width: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
