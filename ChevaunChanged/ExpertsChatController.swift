//
//  ExpertsChatController.swift
//  ChevaunChanged
//
//  Created by Nishant Punia on 22/07/17.
//  Copyright © 2017 MLBNP. All rights reserved.
//

import UIKit
import Firebase

class ExpertsChatController: UICollectionViewController {
    
    var user: User? {
        didSet {
            print(user?.uid)
            observeMessages()
        }
    }
    
    fileprivate func observeMessages() {
        guard let currentUserId = FIRAuth.auth()?.currentUser?.uid else { return }
        guard let toId = user?.uid else { return }
        
        let userMessagesRef = FIRDatabase.database().reference().child("user-messages").child(currentUserId).child(toId)
        
        userMessagesRef.observe(.childAdded, with: { (snapshot) in
            print(snapshot.key)
        }) { (error) in
            print("Unable to fetch messages from the server:", error)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .darkGray
    }
    
    lazy var containerView: UIView = {
        
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        
        let submitCommentButton = UIButton(type: .system)
        submitCommentButton.setTitle("Send", for: .normal)
        submitCommentButton.titleLabel?.textColor = .black
        submitCommentButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        submitCommentButton.addTarget(self, action: #selector(sendMessageButtonTapped), for: .touchUpInside)
        
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        
        containerView.addSubview(submitCommentButton)
        containerView.addSubview(self.messageTextField)
        containerView.addSubview(separatorLineView)
        
        submitCommentButton.anchor(top: containerView.topAnchor, left: nil, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, centerX: nil, centerY: nil, topPadding: 0, leftPadding: 0, bottomPadding: 0, rightPadding: 8, height: 0, width: 50)
        
        self.messageTextField.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: submitCommentButton.leftAnchor, centerX: nil, centerY: nil, topPadding: 0, leftPadding: 8, bottomPadding: 0, rightPadding: 0, height: 0, width: 0)
        
        separatorLineView.anchor(top: self.messageTextField.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, centerX: nil, centerY: nil, topPadding: 0, leftPadding: 0, bottomPadding: 0, rightPadding: 0, height: 0.5, width: 0)
        
        return containerView
    }()
    
    let messageTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Message"
        return textField
    }()
    
    //Not Working.
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        return true
//    }
    
    func sendMessageButtonTapped() {
        
        guard let fromId = FIRAuth.auth()?.currentUser?.uid else { return }
        guard let toId = user?.uid else { return }
        guard let message = messageTextField.text else { return }
        
        let messageRef = FIRDatabase.database().reference().child("messages").childByAutoId()
        
        let valuesDictionary = ["toId": toId, "fromId": fromId, "creationDate": Date().timeIntervalSince1970, "message": message] as [String: Any]
        
        messageRef.updateChildValues(valuesDictionary) { (error, ref) in
            if let error = error {
                print("Unable to send the message", error)
                return
            }
            
            self.messageTextField.text = nil
            
            let userMessagesRef = FIRDatabase.database().reference().child("user-messages").child(fromId).child(toId)
            
            let messageId = messageRef.key
            let userMessageDictionary = [messageId: 1]
            userMessagesRef.updateChildValues(userMessageDictionary, withCompletionBlock: { (error, ref) in
                if let error = error {
                    //Not for the user.
                    print("Unable to update reference dictionary.", error)
                    return
                }
                
                let recipientUserMessageRef = FIRDatabase.database().reference().child("user-messages").child(toId).child(fromId)
                let recipientUserMessageDictionary = [messageId: 1]
                recipientUserMessageRef.updateChildValues(recipientUserMessageDictionary, withCompletionBlock: { (error, ref) in
                    if let error = error {
                        //Not for the user.
                        print("Unable to update recipient message list", error)
                    }
                })
            })
            
            print("Successfully uploaded the message to the server.")
        }
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }

    
}
