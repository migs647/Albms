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
    /// - Parameters:
    /// - Parameter urlString: The URL that points to where the image is currently
    ///   - indexPath: Used if the image should be associated with a specific
    ///   index, such as a UITableViewCell.
    ///   - completion: The completion handler that is called when the image is found.
    func cacheImage(urlString: String, indexPath: IndexPath?, completion: @escaping (UIImage?, IndexPath?) -> Void) {
        
        // Make sure we have a valid url before moving forward
        guard let url = URL(string: urlString) else {
            ALBUtility.executeOnMainQueue {
                completion(nil, indexPath)
            }
            return
        }
        
        // First check if the image is in cache, if it is set it and forget it
        if let imageFromCache = albImageCache.object(forKey: urlString as AnyObject) as? UIImage {
            ALBUtility.executeOnMainQueue {
                completion(imageFromCache, indexPath)
            }
        } else {
            // Fetch the image then cache it so we can retrieve it later
            URLSession.shared.dataTask(with: url) { data, response, error in
                if data != nil {
                    ALBUtility.executeInBackgroundAndWait({
                        let imageToCache = UIImage(data: data!)
                        self.albImageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
                        ALBUtility.executeOnMainQueue {
                            completion(imageToCache, indexPath)
                        }
                    })
                }
            }.resume()
        }
    }

}
