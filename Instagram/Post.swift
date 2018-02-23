//
//  Post.swift
//  Instagram
//
//  Created by Burak Şentürk on 25.08.2017.
//  Copyright © 2017 Burak Şentürk. All rights reserved.
//

import Foundation

struct Post {
    var postId : String?
    let user : User
    let imageUrl : String
    let caption : String
    let creationDate : Date
    
    var hasLiked = true
    
    init(user : User,dictionary : [String : Any]) {
        self.user = user
        imageUrl = dictionary["imageUrl"] as? String ?? ""
        caption = dictionary["caption"] as?  String ?? ""
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
        
    }
}
