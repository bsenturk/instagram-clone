//
//  ViewController.swift
//  Instagram
//
//  Created by Burak Şentürk on 11.08.2017.
//  Copyright © 2017 Burak Şentürk. All rights reserved.
//

import UIKit
import Firebase

class SignUpController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    let plusPhotobutton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handlePickPhoto), for: .touchUpInside)
        
        
        return button
        
    }()
    
    func handlePickPhoto(){
        let imagePicker = UIImagePickerController()
        present(imagePicker, animated: true, completion: nil)
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            plusPhotobutton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
            
        }
        
        else if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            
            plusPhotobutton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        plusPhotobutton.layer.cornerRadius = plusPhotobutton.frame.width/2
        plusPhotobutton.layer.masksToBounds = true
        plusPhotobutton.layer.borderColor = UIColor.black.cgColor
        plusPhotobutton.layer.borderWidth = 3
        dismiss(animated: true , completion: nil)
    }
    
    let emailTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.borderStyle = .roundedRect
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        
        return tf
        
    }()
    
    func handleTextInputChange(){
        
        let isFormValid = emailTextField.text?.characters.count ?? 0 > 0  && usernameTextField.text?.characters.count ?? 0 > 0 && passwordTextField.text?.characters.count ?? 0 > 0
        
        if isFormValid {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        }
        else{
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)

        }
        
    }
    
    let usernameTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.borderStyle = .roundedRect
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)

        return tf
        
    }()
    let passwordTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.borderStyle = .roundedRect
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)

        return tf
        
    }()
    
    let signUpButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    func handleSignUp(){
        
        guard let email = emailTextField.text, email.characters.count>0 else {
            
            return
        }
        guard let username = usernameTextField.text, username.characters.count>0 else{
            return
        }
        guard let password = passwordTextField.text, password.characters.count>0 else {
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            if error != nil {
                print(error!)
            }
            else {
                print("Created Successfully", user?.uid ?? "")
            }
            
            guard let profileImage = self.plusPhotobutton.imageView?.image else{ return }
            guard let uploadData = UIImageJPEGRepresentation(profileImage, 0.3) else { return }
            
            let fileName = NSUUID().uuidString
            
            Storage.storage().reference().child("Profile_Pictures").child(fileName).putData(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if let err = error {
                    print("Failed to upload data ", err)
                    return
                }
                guard let profileImageUrl = metadata?.downloadURL()?.absoluteString else { return }
                 print("Successfully to upload data " , profileImageUrl)
                
                guard let uid = user?.uid else{ return }
                
                
                
                
                let values = ["Email" : email, "Username" : username , "Password" : password, "ProfileImageURL" : profileImageUrl]
                
                Database.database().reference().child("Users").child(uid).updateChildValues(values, withCompletionBlock: { (error,ref) in
                    
                    
                    if let err = error {
                        
                        print("Failed to saved into db", err)
                    }
                    else{
                        print("Successfully to saved into db", ref)
                        
                        guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
                        
                        mainTabBarController.setupViewControllers()
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                })

                
            })
            
            
        }
        
        
    }
    
    let alreadyHaveAnAccountButton : UIButton = {
        let button = UIButton(type:.system)
        let attributeTitle = NSMutableAttributedString(string: "Already have an account?  ", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14),NSForegroundColorAttributeName: UIColor.lightGray])
        attributeTitle.append(NSMutableAttributedString(string: "Sign In", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.rgb(red: 17, green: 154, blue: 237)]))
        button.setAttributedTitle(attributeTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return button
    }()
    
    func handleShowLogin(){
       navigationController?.popViewController(animated: true)
        
    }
    fileprivate func setupAlreadyHaveButton(){
        view.addSubview(alreadyHaveAnAccountButton)
        alreadyHaveAnAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(plusPhotobutton)
        setPlusPhotoConstraints()
        view.addSubview(emailTextField)
        setupInputFields()
        setupAlreadyHaveButton()
        
        
    }
    
    
    func setPlusPhotoConstraints(){
        //anchors 
        plusPhotobutton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        plusPhotobutton.widthAnchor.constraint(equalToConstant: 140).isActive = true
//        plusPhotobutton.heightAnchor.constraint(equalToConstant: 140).isActive = true
//        plusPhotobutton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        plusPhotobutton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
        
        
        
    }
    fileprivate func setupInputFields(){
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField,usernameTextField,passwordTextField,signUpButton])
        
        view.addSubview(stackView)
        
        
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        
        NSLayoutConstraint.activate([
//            
//            stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40),
//            stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40),
//            stackView.topAnchor.constraint(equalTo: plusPhotobutton.bottomAnchor, constant: 20),
//            stackView.heightAnchor.constraint(equalToConstant: 200)
//            
        
            
            
            ])
        
        stackView.anchor(top: plusPhotobutton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: -40, width: 0, height: 200)
        
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

extension UIView {
    
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat,paddingBottom : CGFloat, paddingRight: CGFloat,width: CGFloat, height: CGFloat) {
        
            translatesAutoresizingMaskIntoConstraints = false

        
        if let top = top {
            
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true

        }
        if let left = left {
            
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true

        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true

            
        }
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: paddingRight).isActive = true

            
        }
        if width != 0 {
            
            self.widthAnchor.constraint(equalToConstant: width).isActive = true

        }
        if height != 0 {
             self.heightAnchor.constraint(equalToConstant: height).isActive = true
            
        }
        
       
        
        
    }
    
}

