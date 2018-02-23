//
//  CustomImageView.swift
//  Instagram
//
//  Created by Burak Şentürk on 25.08.2017.
//  Copyright © 2017 Burak Şentürk. All rights reserved.
//

import UIKit
class CustomImageView: UIImageView {
    
    var imageCache = [String: UIImage]()
    
    var lastUrlUsedToLoadImage : String?
    func loadImage(urlString : String){
        print("Loading Image..")
        lastUrlUsedToLoadImage = urlString
        self.image = nil
    
        
        if let cachedImage = imageCache[urlString] {
            self.image = cachedImage
            
        }
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err {
                
                print("Failed to fetch image :",err)
            }
            
            if url.absoluteString != self.lastUrlUsedToLoadImage {
                return
                
            }
            
            guard let imageData = data else { return }
            let image = UIImage(data: imageData)
            
            self.imageCache[url.absoluteString] = image
            
            DispatchQueue.main.async {
                
                self.image = image
                
            }
            
            }.resume()

    }
}
