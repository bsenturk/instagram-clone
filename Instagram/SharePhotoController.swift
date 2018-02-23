//
//  SharePhotoController.swift
//  Instagram
//
//  Created by Burak Şentürk on 25.08.2017.
//  Copyright © 2017 Burak Şentürk. All rights reserved.
//

import UIKit
import Firebase

class SharePhotoController : UIViewController {
    var selectedImage : UIImage? {
        didSet {            
            imageView.image = selectedImage
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
        
        setupImageAndTextView()
        
    }
    
    let imageView : UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .red
        iv.clipsToBounds = true
        return iv
        
    }()
    
    let textView : UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        return tv
    }()
    
    func setupImageAndTextView() {
        let containerView = UIView()
        containerView.backgroundColor = .white
        view.addSubview(containerView)
        containerView.anchor(top: topLayoutGuide.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
        
        containerView.addSubview(imageView)
        imageView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: -8, paddingRight: 0, width: 84 , height: 0)
        
        containerView.addSubview(textView)
        textView.anchor(top: containerView.topAnchor, left: imageView.rightAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
    }
    
    func handleShare() {
        
        print("Sharing")
        let filename = UUID().uuidString
        
        guard let image = selectedImage else { return }
        
        guard let uploadData = UIImageJPEGRepresentation(image, 0.5) else { return }
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        Storage.storage().reference().child("posts").child(filename).putData(uploadData, metadata: nil) { (metadata, err) in
            
            if let err = err {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to upload post image :", err)
                
            }
            guard let imageUrl = metadata?.downloadURL()?.absoluteString else { return }
            
            print("Successfully to upload post image :",imageUrl)
            
                self.saveToDatabaseWithImageUrl(imageUrl: imageUrl , image: image)
        }
        
        
        
    }
    
    static let updateFeed = NSNotification.Name(rawValue: "UpdatedFeed")

    
    fileprivate func saveToDatabaseWithImageUrl(imageUrl : String , image : UIImage) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let caption = textView.text else { return }
        
       let postRef = Database.database().reference().child("posts").child(uid)
           let ref = postRef.childByAutoId()
        let values = ["imageUrl" : imageUrl , "caption" : caption, "imageWidth" : image.size.width, "imageHeight" : image.size.height , "creationDate" : Date().timeIntervalSince1970] as [String : Any]
        
            ref.updateChildValues(values) { (err, ref) in
                
                if let err = err {
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    print("Failed to save image into DB :", err)
                    return
                }
                print("Succesfully to saved image into DB :", ref)
                self.dismiss(animated: true, completion: nil)
                
                NotificationCenter.default.post(name: SharePhotoController.updateFeed, object: nil)
                
                
        }
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    
    
    
}
