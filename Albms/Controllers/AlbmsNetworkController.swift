//
//  AlbmsNetworkController.swift
//  Albms
//
//  Created by Cody Garvin on 5/6/19.
//  Copyright © 2019 Cody Garvin. All rights reserved.
//

import UIKit

struct AlbmsNetworkController {
    
    static let shared = AlbmsNetworkController()
    private let albumsURL = "https://rss.itunes.apple.com/api/v1/us/apple-music/top-albums/all/100/explicit.json"
    private var dataController: AlbmsDataController?
    
    init() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            dataController = appDelegate.dataController
        }
    }
    
    func fetchLatestAlbums(_ closure: @escaping (Bool) -> (Void)) {
        
        guard let url = URL(string: albumsURL) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            // Verify we actually have data before moving forward
            guard let jsonData = data else { return }
            
            // Make sure the coding key we're using is valid, else bail since
            // something went very wrong
            guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext else {
                fatalError("Failed to retrieve context")
            }
            
            guard let mainObjectContext = self.dataController?.mainObjectContext else { return }
            
            // Clear out the cache in core data so we don't duplicate results
            self.dataController?.clearStorage()
            
            var success = false
            do {
                let decoder = JSONDecoder()
                decoder.userInfo[codingUserInfoKeyManagedObjectContext] = mainObjectContext
                _ = try decoder.decode(Feed.self, from: jsonData)
                try mainObjectContext.save()
                success = true
            } catch {
                print("Error fetching iTunes albums: \(error)")
            }
            
            ALBUtility.executeOnMainQueue {
                closure(success)
            }
        }.resume()
    }
}
