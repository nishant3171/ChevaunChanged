//
//  FirebaseUtils.swift
//  ChevaunChanged
//
//  Created by Nishant Punia on 16/07/17.
//  Copyright © 2017 MLBNP. All rights reserved.
//

import Foundation
import Firebase

extension FIRDatabase {
    static func fetchUserWithUID(uid: String, completion: @escaping (User) -> ()) {
        
        let userDatabaseRef = FIRDatabase.database().reference().child("users").child(uid)
        userDatabaseRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userDictionary = snapshot.value as? [String: Any] else { return }
            
            let user = User(uid: uid, dictionary: userDictionary)
            
            completion(user)
            
        }) { (error) in
            print("Unable to fetch the user:", error)
        }
        
    }
}
