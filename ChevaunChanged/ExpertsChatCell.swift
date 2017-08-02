//
//  ExpertsChatCell.swift
//  ChevaunChanged
//
//  Created by Nishant Punia on 28/07/17.
//  Copyright © 2017 MLBNP. All rights reserved.
//

import UIKit

class ExpertsChatCell: UICollectionViewCell {
    
    var message: Message? {
        didSet {
            messageTextView.text = message?.message
        }
    }
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleLeftAnchor: NSLayoutConstraint?
    var bubbleRightAnchor: NSLayoutConstraint?
    
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainBlue()
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    let messageTextView: UITextView = {
        let tv = UITextView()
        tv.text = "Some kind of text."
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.backgroundColor = .clear
        tv.textColor = .white
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(bubbleView)
        addSubview(messageTextView)
        
        bubbleView.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: nil, centerX: nil, centerY: nil, topPadding: 0, leftPadding: 0, bottomPadding: 0, rightPadding: 0, height: self.bounds.height, width: 0)
        
        bubbleRightAnchor = bubbleView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8)
        bubbleRightAnchor?.isActive = true
        
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        
        bubbleLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8)
        
        messageTextView.anchor(top: topAnchor, left: bubbleView.leftAnchor, bottom: bubbleView.bottomAnchor, right: bubbleView.rightAnchor, centerX: nil, centerY: nil, topPadding: 0, leftPadding: 8, bottomPadding: 0, rightPadding: 8, height: self.bounds.height, width: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
