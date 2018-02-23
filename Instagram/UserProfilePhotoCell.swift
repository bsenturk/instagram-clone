//
//  UserProfilePhotoCell.swift
//  Instagram
//
//  Created by Burak Şentürk on 25.08.2017.
//  Copyright © 2017 Burak Şentürk. All rights reserved.
//

import UIKit
class UserProfilePhotoCell: UICollectionViewCell {
    
    
    var post : Post? {
        didSet {
            
            
           guard let imageUrl = post?.imageUrl else { return }
            
            profileImageView.loadImage(urlString: imageUrl)
            
                        
        }
        
    }
    
    let profileImageView : CustomImageView = {
       let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
