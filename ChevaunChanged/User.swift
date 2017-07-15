//
//  User.swift
//  ChevaunChanged
//
//  Created by Nishant Punia on 13/07/17.
//  Copyright © 2017 MLBNP. All rights reserved.
//

import Foundation

struct User {
    
    var profileImageUrl: String
    var username: String
    var name: String?
    var description: String?
    
    init(dictionary: [String: Any]) {
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.name = dictionary["name"] as? String
        self.description = dictionary["description"] as? String
    }
}
