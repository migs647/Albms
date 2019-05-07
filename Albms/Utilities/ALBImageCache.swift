//
//  ALBImageCache.swift
//  Albms
//
//  Created by Cody Garvin on 5/6/19.
//  Copyright © 2019 Cody Garvin. All rights reserved.
//

import UIKit

struct ALBImageCache {
    
    static let shared = ALBImageCache()
    private let albImageCache = NSCache<AnyObject, AnyObject>()
    
    /// Stores an image to cache once it is downloaded and retrieves from cache
    /// when necessary.
    ///
    /// - Parameter urlString: The URL that points to where the image is currently
    func cacheImage(urlString: String) -> UIImage? {
        
        var returnImage: UIImage?
        
        // Make sure we have a valid url before moving forward
        guard let url = URL(string: urlString) else { return returnImage }
        
        // First check if the image is in cache, if it is set it and forget it
        if let imageFromCache = albImageCache.object(forKey: urlString as AnyObject) as? UIImage {
            returnImage = imageFromCache
        } else {
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if data != nil {
                    
                    ALBUtility.executeInBackgroundAndWait({
                        let imageToCache = UIImage(data: data!)
                        self.albImageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
                        returnImage = imageToCache
                    })
                }
            }.resume()
        }
        
        return returnImage
    }

}
