//
//  MainTabBarController.swift
//  Instagram
//
//  Created by Burak Şentürk on 15.08.2017.
//  Copyright © 2017 Burak Şentürk. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let index = viewControllers?.index(of: viewController)
        
        if index == 2 {
            
            let layout = UICollectionViewFlowLayout()
            let photoSelectorController = PhotoSelectorController(collectionViewLayout: layout)
            let photoSelectorNavController = UINavigationController(rootViewController: photoSelectorController)
            present(photoSelectorNavController, animated: true, completion: nil)
            
            return false
            
        }
        
        return true
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true, completion: nil)
            }
            return
        }
        
        setupViewControllers()
        
        
        
    }
    
    func setupViewControllers() {
        //home
        let homeNavController = templatesNavController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: HomeController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        //let homeNavController = templatesNavController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"))
        
    
        //search
        let searchNavController = templatesNavController(unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"), rootViewController: UserSearchController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        
        //camera
        let cameraNavController = templatesNavController(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected"))
        //like
        let likeNavController = templatesNavController(unselectedImage: #imageLiteral(resourceName: "like_unselected"), selectedImage: #imageLiteral(resourceName: "like_selected"))
        
        //user profile
        let layout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        let userProfileNavController = UINavigationController(rootViewController: userProfileController)
        userProfileNavController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        userProfileNavController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected").withRenderingMode(.alwaysOriginal)
        viewControllers = [homeNavController,
                            searchNavController,
                            cameraNavController,
                            likeNavController,
                            userProfileNavController]
        
       
        guard let items = tabBar.items else { return }
        
        for item in items {
            
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
            
        }

    }
    fileprivate func templatesNavController(unselectedImage : UIImage, selectedImage: UIImage , rootViewController : UIViewController = UIViewController()) -> UINavigationController {
        let viewControllers = rootViewController
        let navControllers = UINavigationController(rootViewController: viewControllers)
        navControllers.tabBarItem.image = unselectedImage.withRenderingMode(.alwaysOriginal)
        navControllers.tabBarItem.selectedImage = selectedImage.withRenderingMode(.alwaysOriginal)
        
        return navControllers
        
    }
}
