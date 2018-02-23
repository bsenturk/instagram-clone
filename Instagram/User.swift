//
//  User.swift
//  Instagram
//
//  Created by Burak Şentürk on 27.08.2017.
//  Copyright © 2017 Burak Şentürk. All rights reserved.
//

import Foundation

struct User {
    let uid : String
    let username : String
    let profileImageUrl : String
    init(uid : String,dictionary : [String: Any]) {
        self.uid = uid
        self.username = dictionary["Username"] as? String ?? ""
        self.profileImageUrl = dictionary["ProfileImageURL"] as? String ?? ""
        
        
    }
        
}
