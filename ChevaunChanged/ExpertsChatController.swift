//
//  ExpertsChatController.swift
//  ChevaunChanged
//
//  Created by Nishant Punia on 22/07/17.
//  Copyright © 2017 MLBNP. All rights reserved.
//

import UIKit
import Firebase

class ExpertsChatController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    var messages = [Message]()
    
    var user: User? {
        didSet {
            observeMessages()
        }
    }
    
    fileprivate func observeMessages() {
        guard let currentUserId = FIRAuth.auth()?.currentUser?.uid else { return }
        guard let toId = user?.uid else { return }
        
        let userMessagesRef = FIRDatabase.database().reference().child("user-messages").child(currentUserId).child(toId)
        
        userMessagesRef.observe(.childAdded, with: { (snapshot) in
            
            let messageId = snapshot.key
            let messagesRef = FIRDatabase.database().reference().child("messages").child(messageId)
            
            messagesRef.observe(.value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                let message = Message(dictionary: dictionary)
                
                self.messages.append(message)
                
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
                
            }, withCancel: { (error) in
                print("Unable to load messages from the server:", error)
            })
            
        }) { (error) in
            print("Unable to fetch messages from the server:", error)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        //implement keyboard dismissal with tap on the screen
        collectionView?.keyboardDismissMode = .interactive
        collectionView?.alwaysBounceVertical = true
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        collectionView?.register(ExpertsChatCell.self, forCellWithReuseIdentifier: cellId)
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
    
    fileprivate func setupCell(cell: ExpertsChatCell, message: Message) {
        if message.fromId == FIRAuth.auth()?.currentUser?.uid {
            cell.bubbleView.backgroundColor = .mainBlue()
            cell.messageTextView.textColor = .white
            cell.bubbleLeftAnchor?.isActive = false
            cell.bubbleRightAnchor?.isActive = true
            
        } else {
            cell.bubbleView.backgroundColor = .mainGray()
            cell.messageTextView.textColor = .black
            cell.bubbleLeftAnchor?.isActive = true
            cell.bubbleRightAnchor?.isActive = false
        }
    }
    
    //MARK: CollectionViewSetup
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ExpertsChatCell
        let message = messages[indexPath.item]
        cell.message = message
        
        let text = messages[indexPath.item].message
        cell.bubbleWidthAnchor?.constant = estimatedFrameForText(text: text).width + 28
        
        setupCell(cell: cell, message: message)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let text = messages[indexPath.item].message
        
        var height: CGFloat = 80
        height = estimatedFrameForText(text: text).height + 20
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    fileprivate func estimatedFrameForText(text: String) -> CGRect {
        
        let size = CGSize(width: 200, height: 10000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
    }

    
}
