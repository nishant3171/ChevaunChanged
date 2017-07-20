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
    
    var user: User? {
        didSet {
            guard let imageUrl = user?.profileImageUrl else { return }
            profileImageView.settingUpImage(urlString: imageUrl)
        }
    }
    
    var completion: (() -> Void)?
    
    lazy var chatButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = .mainBlue()
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(chatButtonTapped), for: .touchUpInside)
        return button
    }()
    
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
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.backgroundColor = .white
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let categoriesLabel: UILabel = {
        let label = UILabel()
        label.text = "Categories"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(profileImageView)
        addSubview(editButton)
        addSubview(categoriesLabel)
        addSubview(chatButton)
        
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, centerX: nil, centerY: nil, topPadding: 0, leftPadding: 0, bottomPadding: 0, rightPadding: 0, height: 250, width: 0)
        
        editButton.anchor(top: nil, left: nil, bottom: profileImageView.bottomAnchor, right: rightAnchor, centerX: nil, centerY: nil, topPadding: 0, leftPadding: 0, bottomPadding: 16, rightPadding: 16, height: 30, width: 50)
        
        chatButton.anchor(top: profileImageView.bottomAnchor, left: nil, bottom: nil, right: nil, centerX: centerXAnchor, centerY: nil, topPadding: 32, leftPadding: 0, bottomPadding: 0, rightPadding: 0, height: 44, width: 216)
        
        categoriesLabel.anchor(top: chatButton.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, centerX: nil, centerY: nil, topPadding: 32, leftPadding: 16, bottomPadding: 12, rightPadding: 16, height: 0, width: 0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func editButtonTapped() {
        completion?()
        print("I am not working.")
    }
    
    func chatButtonTapped() {
        print("I am being chatted.")
    }
    
}

class CategoriesLabel: UILabel {
    
    var topInset: CGFloat = 8
    var bottomInset: CGFloat = 8
    var leftInset: CGFloat = 8
    var rightInset: CGFloat = 8
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += topInset + bottomInset
            contentSize.width += leftInset + rightInset
            return contentSize
        }
    }
    
}
