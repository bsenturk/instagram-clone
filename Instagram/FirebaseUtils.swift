//
//  FirebaseUtils.swift
//  Instagram
//
//  Created by Burak Şentürk on 27.08.2017.
//  Copyright © 2017 Burak Şentürk. All rights reserved.
//

import Foundation
import Firebase

extension Database {
    static func fetchUserWithUID(uid: String , completion : @escaping (User) -> () ){
        
        Database.database().reference().child("Users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let userDictionary = snapshot.value as? [String : Any] else { return }
            
            let user = User(uid: uid, dictionary: userDictionary)
            completion(user)
            
            // self.fetchPostWithUser(user : user)
            
            
        }) { (err) in
            print("Failed to fetch user :", err)
        }
        
        
    }
}
