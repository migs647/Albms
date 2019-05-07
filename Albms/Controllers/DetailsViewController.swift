//
//  DetailsViewController.swift
//  Albms
//
//  Created by Cody Garvin on 5/7/19.
//  Copyright © 2019 Cody Garvin. All rights reserved.
//

import UIKit

class DetailsViewController: AlbmsAbstractViewController {
    
    @IBOutlet var albumImageView: UIImageView!
    @IBOutlet var viewIniTunesButton: UIButton!
    
    var albumDetails: Album? {
        didSet {
            loadAlbumData(albumDetails)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the colors and post nib lovelies.
        configureViews()
    }
    
    @IBAction func loadItunes() {
        if let url = albumDetails?.url {
            let itunesURLString = url.replacingOccurrences(of: "https", with: "itms")
            if let itunesURL = URL(string: itunesURLString) {
                UIApplication.shared.open(itunesURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    private func configureViews() {
        albumImageView.layer.cornerRadius = 10.0
        viewIniTunesButton.layer.cornerRadius = 6.0
        viewIniTunesButton.backgroundColor = UIColor.albPollution()
    }
    
    private func loadAlbumData(_ album: Album?) {
        // Could be turned into a view model
        guard let album = album, let artistThumbUrl = album.artistThumbUrl else { return }
        
        ALBImageCache.shared.cacheImage(urlString: artistThumbUrl, indexPath: nil) { [weak self] (cachedImage, _) in
            self?.albumImageView.image = cachedImage
        }
    }
}
