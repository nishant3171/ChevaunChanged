//
//  Message.swift
//  ChevaunChanged
//
//  Created by Nishant Punia on 23/07/17.
//  Copyright © 2017 MLBNP. All rights reserved.
//

import Foundation
import Firebase

struct Message {
    
    let toId: String
    let fromId: String
    let creationDate: Date
    let message: String
    
    init(dictionary: [String: Any]) {
        
        self.toId = dictionary["toId"] as? String ?? ""
        self.fromId = dictionary["fromId"] as? String ?? ""
        self.message = dictionary["message"] as? String ?? ""
        
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
        
    }
    
    func chatPartnerId() -> String? {
        return fromId == FIRAuth.auth()?.currentUser?.uid ? toId : fromId
    }
}
