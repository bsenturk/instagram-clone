//
//  CommentCell.swift
//  Instagram
//
//  Created by Burak Şentürk on 6.09.2017.
//  Copyright © 2017 Burak Şentürk. All rights reserved.
//

import UIKit
class CommentCell: UICollectionViewCell {
    var comment : Comment? {
        didSet {
            guard let comment = comment else { return }
            let attributeText = NSMutableAttributedString(string: comment.user.username, attributes: [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 14)])
            
            attributeText.append(NSAttributedString(string: " " + comment.text, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)]))
            textView.attributedText = attributeText

            
         //   textLabel.text = comment.text
            profileImageView.loadImage(urlString: comment.user.profileImageUrl)
        }
    }
    
    let textView : UITextView = {
        let tf = UITextView()
        tf.font = UIFont.systemFont(ofSize : 14)
        tf.isScrollEnabled = false
        return tf
        
    }()
    
    let profileImageView : CustomImageView = {
       let iv = CustomImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .blue
        return iv
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
       // backgroundColor = .yellow
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
            profileImageView.layer.cornerRadius = 40 / 2
        
        addSubview(textView)
        textView.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: -4, paddingRight: -4, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
