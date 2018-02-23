//
//  PreviewImageContainerView.swift
//  Instagram
//
//  Created by Burak Şentürk on 31.08.2017.
//  Copyright © 2017 Burak Şentürk. All rights reserved.
//

import UIKit
import Photos
class PreviewImageContainerView: UIView {
    
    let previewImageView : UIImageView = {
       let iv = UIImageView()
        return iv
    }()
    
    let cancelButton : UIButton = {
        let button = UIButton(type : .system)
        button.setImage(#imageLiteral(resourceName: "cancel_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()
    
    let saveImageButton : UIButton = {
            let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "save_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleSaveImage), for: .touchUpInside)
        return button
        
    }()
    
    func handleCancel() {
        self.removeFromSuperview()
        
    }
    
    func handleSaveImage() {
        let library = PHPhotoLibrary.shared()
        library.performChanges({
            guard let previewImage = self.previewImageView.image else { return }
            PHAssetChangeRequest.creationRequestForAsset(from: previewImage)
            
        }) { (success, err) in
            if let err = err {
                print("Failed saved image to library:",err)
            }
            print("Successfully saved image to library")
            DispatchQueue.main.async {
                
                let savedLabel = UILabel()
                savedLabel.text = "Saved Successfully"
                savedLabel.numberOfLines = 0
                savedLabel.font = UIFont.boldSystemFont(ofSize: 18)
                savedLabel.textAlignment = .center
                savedLabel.textColor = .white
                savedLabel.backgroundColor = UIColor(white: 0, alpha: 0.3)
                savedLabel.frame = CGRect(x: 0, y: 0, width: 150, height: 80)
                savedLabel.center = self.center
                
                self.addSubview(savedLabel)
                
                savedLabel.layer.transform = CATransform3DMakeScale(0, 0, 0)
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: { 
                    
                    savedLabel.layer.transform = CATransform3DMakeScale(1, 1, 1)
                    
                    
                }, completion: { (completion) in
                    //completion
                    
                    UIView.animate(withDuration: 0.5, delay: 0.75, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: { 
                        
                        savedLabel.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
                        savedLabel.alpha = 0
                        
                    }, completion: { (_) in
                        savedLabel.removeFromSuperview()
                    })
                    
                })
            }
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
            backgroundColor = .yellow
        addSubview(previewImageView)
        previewImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        addSubview(cancelButton)
        
        cancelButton.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        
        addSubview(saveImageButton)
        
        
        saveImageButton.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 24, paddingBottom: -24, paddingRight: 0, width: 40, height: 40)
        
        }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
