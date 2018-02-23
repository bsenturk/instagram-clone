//
//  HomeController.swift
//  Instagram
//
//  Created by Burak Şentürk on 26.08.2017.
//  Copyright © 2017 Burak Şentürk. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController , UICollectionViewDelegateFlowLayout, HomePostCellDelegate{
    
    let cellId = "cellId"
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: SharePhotoController.updateFeed, object: nil)
        
        collectionView?.backgroundColor = .white
        
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
        setupNavItems()
        refreshControl()
        fetchAllPost()
    }
    
    func handleUpdateFeed() {
        
        refreshControl()
    }
    
    func refreshControl() {
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
        
        
    }
    
    func handleRefresh() {
        posts.removeAll()
        fetchAllPost()
        
    }
    
    fileprivate func fetchAllPost() {
        fetchPosts()
        fetchFollowingUserIds()
        
    }
    
    func setupNavItems() {
        
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2"))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "camera3").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleCamera))
        
    }
    
    func handleCamera() {
        print("camera")
        let cameraController = CameraController()
        self.present(cameraController, animated: true, completion: nil)
    }
    
    fileprivate func fetchFollowingUserIds(){
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("following").child(currentUserUID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let userIdsDictionary = snapshot.value as? [String : Any] else { return }
            userIdsDictionary.forEach({ (key,value) in
                Database.fetchUserWithUID(uid: key, completion: { (user) in
                    
                    self.fetchPostWithUser(user: user)
                })
            })
            
        }) { (err) in
            print("Failed to fetch post following user",err)
        }
        
        
    }
    
    var posts = [Post]()
    fileprivate func fetchPosts() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
       Database.fetchUserWithUID(uid: uid) { (user) in
            self.fetchPostWithUser(user: user)
        }
        
        
        
       
        
    }
    
    fileprivate func fetchPostWithUser(user : User){
        
        let ref = Database.database().reference().child("posts").child(user.uid)
        ref.observe(.value, with: { (snapshot) in
            
            self.collectionView?.refreshControl?.endRefreshing()
            
            
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            dictionaries.forEach({ (key,value) in
                
                guard let dictionary = value as? [String : Any] else { return }
                
                var post = Post(user: user, dictionary: dictionary)
                post.postId = key
                guard let uid = Auth.auth().currentUser?.uid else { return }
                Database.database().reference().child("likes").child(key).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    print(snapshot)
                    if let values = snapshot.value as? Int,values == 1 {
                        post.hasLiked = true
                    }
                    else {
                        post.hasLiked = false
                    }
                    
                    
                    self.posts.append(post)
                    
                    self.posts.sort(by: { (p1, p2) -> Bool in
                        return p1.creationDate.compare(p2.creationDate) == .orderedDescending
                    })
                    self.collectionView?.reloadData()

                    
                }, withCancel: { (err) in
                    print("Failed to fetch like info for post :",err)
                })
                
                
                
                
            })
            
            
            
        }) { (err) in
            
            print("Failed to fetch posts :",err)
            
        }

        
        }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height : CGFloat = 40 + 8 + 8 // username and profileimageview
        
        height += view.frame.width
        height += 50
        height += 60
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
        cell.post = posts[indexPath.item]
        
        cell.delegate = self
        
        return cell
    }
    
    func didTapComment(post: Post) {
        print("Messages from HomeController")
        print(post.postId ?? "")
        let layout = UICollectionViewFlowLayout()
        let commentsController = CommentsController(collectionViewLayout: layout)
        commentsController.post = post
        navigationController?.pushViewController(commentsController, animated: true)
        

    }
    
    func didLike(for cell: HomePostCell) {
        print("handling like")
        
        guard let indexPath = collectionView?.indexPath(for: cell) else { return }
        var post = self.posts[indexPath.item]
        print(post.caption)
        guard let postId = post.postId else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let values = [uid : post.hasLiked == true ? 0 : 1]
        Database.database().reference().child("likes").child(postId).updateChildValues(values) { (err, _) in
            
            if let err = err {
                print("Failed to like post :",err)
            }
            
            print("Successfully to like post")
            
            post.hasLiked = !post.hasLiked
            self.posts[indexPath.item] = post
            
            self.collectionView?.reloadItems(at: [indexPath])
            
        }
        
        
        
        
    }
}
