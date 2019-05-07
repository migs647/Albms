//
//  UIImageView+Albms.swift
//  Albms
//
//  Created by Cody Garvin on 5/6/19.
//  Copyright © 2019 Cody Garvin. All rights reserved.
//

//import UIKit
//
//let albImageCache = NSCache<AnyObject, AnyObject>()
//
//extension UIImageView {
//    
//    
//    /// Stores an image to cache once it is downloaded and retrieves from cache
//    /// when necessary.
//    ///
//    /// - Parameter urlString: The URL that points to where the image is currently
//    func cacheImage(urlString: String) {
//        guard let url = URL(string: urlString) else { return }
//        
//        image = nil
//        
//        // First check if the image is in cache, if it is set it and forget it
//        if let imageFromCache = albImageCache.object(forKey: urlString as AnyObject) as? UIImage {
//            self.image = imageFromCache
//            return
//        }
//        
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if data != nil {
//                
//                DispatchQueue.main.async {
//                    let imageToCache = UIImage(data: data!)
//                    albImageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
//                    self.image = imageToCache
//                }
//            }
//        }.resume()
//    }
//}
