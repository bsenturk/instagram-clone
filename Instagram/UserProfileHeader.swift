//
//  UserProfileHeader.swift
//  Instagram
//
//  Created by Burak Şentürk on 16.08.2017.
//  Copyright © 2017 Burak Şentürk. All rights reserved.
//

import UIKit
import Firebase

protocol UserProfileHeaderDelegate {
    func didChangeToListView()
    func didChangeToGridView()
}

class UserProfileHeader : UICollectionViewCell {
    
    var delegate : UserProfileHeaderDelegate?
    
    var user : User? {
        didSet {
            guard let profileImageUrl = user?.profileImageUrl else { return }
            profileImageView.loadImage(urlString: profileImageUrl)
            
            usernameLabel .text = user?.username
            
            setupEditFollowButton()
            
            
            
        }
    }
    
    fileprivate func setupEditFollowButton() {
        
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        guard let userId = user?.uid else { return }
        
        if currentLoggedInUserId == userId {
            //edit profile
        }
        else {
            
            Database.database().reference().child("following").child(currentLoggedInUserId).child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let isFollowing  = snapshot.value as? Int, isFollowing == 1 {
                    print(isFollowing)
                    self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
                }
                else {
                   self.setupFollowStyle()

                }
                
                
                
            }, withCancel: { (err) in
                print("Failed to check if following :",err)
            })
            
            
        }
        
        
        
        
    }
    
    let profileImageView : CustomImageView = {
       let iv = CustomImageView()
        iv.layer.cornerRadius = 40
        iv.clipsToBounds = true
        
        
        return iv
        
    }()
    
    
   
    
    
    let postLabel : UILabel = {
       let label = UILabel()
        let post = [Post]()
        
        
        let attributedText = NSMutableAttributedString(string: "11\n", attributes: [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "posts", attributes: [NSForegroundColorAttributeName: UIColor.lightGray, NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)]))
        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
        
    }()
    
    
    let followersLabel : UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "1.1m\n", attributes: [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "followers", attributes: [NSForegroundColorAttributeName: UIColor.lightGray, NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)]))
        label.attributedText = attributedText
        
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
        
    }()
    
    
    let followingLabel : UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "11\n", attributes: [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "following", attributes: [NSForegroundColorAttributeName: UIColor.lightGray, NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)]))
        label.attributedText = attributedText
        
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
        
    }()
    
    lazy var editProfileFollowButton : UIButton = {
        let button = UIButton(type:.system)
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        button.addTarget(self, action: #selector(handleEditProfileOrFollow), for: .touchUpInside)
        return button
        
    }()
    
    func handleEditProfileOrFollow(){
        print("Execute edit profile / follow / unfollow logic...")
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("following").child(currentLoggedInUserId)
        
        guard let userId = user?.uid else { return }
        
        if editProfileFollowButton.titleLabel?.text == "Unfollow" {
            Database.database().reference().child("following").child(currentLoggedInUserId).child(userId).removeValue(completionBlock: { (err, ref) in
                if let err = err {
                    print("Failed to unfollow user :",err)
                }
                print("Successfully to unfollow user",self.user?.username ?? "")
             self.setupFollowStyle()
            })
            
        }
        else {
            let values = [userId : 1]
            ref.updateChildValues(values) { (err, ref) in
                if let err = err {
                    print("Failed to following user :", err)
                    
                }
                
                print("Succesfully to following user :",self.user?.username ?? "")
                self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
                self.editProfileFollowButton.setTitleColor(.black, for: .normal)
                self.editProfileFollowButton.backgroundColor = .white
            }
        }
        
        
        
        
    }
    
    fileprivate func setupFollowStyle(){
        self.editProfileFollowButton.setTitle("Follow", for: .normal)
        self.editProfileFollowButton.setTitleColor(.white, for: .normal)
        self.editProfileFollowButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        self.editProfileFollowButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
    }
    
    override init(frame: CGRect) {
     super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        setupBottomToolBar()
        setupUsernameLabel()
        setupUserStats()
        setupEditProfile()
        
    }
   
    
    lazy var gridButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
        button.addTarget(self, action: #selector(handleChangeToGridView), for: .touchUpInside)
        
        
        return button
        
    }()
    
    func handleChangeToGridView() {
        print("grid view")
        gridButton.tintColor = .mainBlue()
        listButton.tintColor = UIColor(white: 0, alpha: 0.2)
        delegate?.didChangeToGridView()
        
    }
    lazy var listButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        button.addTarget(self, action: #selector(handleList), for: .touchUpInside)
   
        return button
        
    }()
    func handleList() {
        print("List button")
        listButton.tintColor = .mainBlue()
        gridButton.tintColor = UIColor(white: 0, alpha: 0.2)
        delegate?.didChangeToListView()
    }
    let bookmarkButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        
        return button
        
    }()
    
    let usernameLabel : UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
        
    }()
    
    fileprivate func setupEditProfile() {
        addSubview(editProfileFollowButton)
        //editProfileButton.anchor(top: postLabel.bottomAnchor, left: postLabel.leftAnchor, bottom: nil, right: followingLabel.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 34)
        editProfileFollowButton.anchor(top: postLabel.bottomAnchor, left: postLabel.leftAnchor, bottom: nil, right: followingLabel.rightAnchor, paddingTop: 2, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 34)
        
    }
    
    
    fileprivate func setupUserStats(){
        let stackView = UIStackView(arrangedSubviews: [postLabel,followersLabel,followingLabel])
        stackView.distribution = .fillEqually
        addSubview(stackView)
        
        stackView.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: -12, width: 0, height: 50)
        
        
        
    }
    
    fileprivate func setupUsernameLabel(){
        addSubview(usernameLabel)
        usernameLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, bottom:gridButton.topAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: -4, paddingRight: -12, width: 0, height: 0)
        
    }
    
    fileprivate func setupBottomToolBar(){
        
        let topDivider = UIView()
        topDivider.backgroundColor = UIColor.lightGray
        
        let bottomDivider = UIView()
        bottomDivider.backgroundColor = UIColor.lightGray
        
        addSubview(topDivider)
        addSubview(bottomDivider)
        
       
        
        let stackView = UIStackView(arrangedSubviews: [gridButton,listButton,bookmarkButton])
        addSubview(stackView)
       stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
         topDivider.anchor(top: stackView.topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        bottomDivider.anchor(top: stackView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}