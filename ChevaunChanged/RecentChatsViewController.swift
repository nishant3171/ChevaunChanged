//
//  RecentChatsViewController.swift
//  ChevaunChanged
//
//  Created by Nishant Punia on 25/05/17.
//  Copyright © 2017 MLBNP. All rights reserved.
//

import UIKit
import Firebase

class RecentChatsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    var users: [User]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .purple
        
        collectionView?.register(RecentChatsCell.self, forCellWithReuseIdentifier: cellId)
        
        observeMessages()
//        collectionView?.reloadData()
    }
    
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    
    fileprivate func observeMessages() {
        guard let currentUserId = FIRAuth.auth()?.currentUser?.uid else { return }
        
        let ref = FIRDatabase.database().reference().child("user-messages").child(currentUserId)
        ref.observe(.childAdded, with: { (snapshot) in
            
            let userId = snapshot.key
            
            FIRDatabase.database().reference().child("user-messages").child(currentUserId).child(userId).observe(.childAdded, with: { (snapshot) in
                
                let messageId = snapshot.key
                self.fetchMessageWithMessageId(messageId)
                
            }, withCancel: { (error) in
                print("Unable to fetch message from the server:", error)
            })
            
        }) { (error) in
            print("Unable to fetch messages from the server:", error)
        }
    }
    
    fileprivate func fetchMessageWithMessageId(_ messageId: String) {
        let messageRef = FIRDatabase.database().reference().child("messages").child(messageId)
        
        messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let messageDictionary = snapshot.value as? [String: Any] else { return }
            
            let message = Message(dictionary: messageDictionary)
            
            guard let chatPartnerId = message.chatPartnerId() else { return }
            self.messagesDictionary[chatPartnerId] = message
            
            self.messages = Array(self.messagesDictionary.values)
            
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
            
            
        }) { (error) in
            print("Unable to fetch messages from the server:", error)
        }
    }
    
    
    //MARK: CollectionViewSetup
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let message = messages[indexPath.item]
        guard let chatUserId = message.chatPartnerId() else { return }
        
        FIRDatabase.fetchUserWithUID(uid: chatUserId) { (user) in
            let expertChatController = ExpertsChatController(collectionViewLayout: UICollectionViewFlowLayout())
            expertChatController.user = user
            
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(expertChatController, animated: true)
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! RecentChatsCell
        cell.message = messages[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 70
        height += 16
        return CGSize(width: view.frame.width, height: height)
        
    }
}
