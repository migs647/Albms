//
//  DetailsViewController.swift
//  Albms
//
//  Created by Cody Garvin on 5/7/19.
//  Copyright © 2019 Cody Garvin. All rights reserved.
//

import UIKit


/// The view controller that displays a specific album and all of the details
/// associated with that album.
class DetailsViewController: AlbmsAbstractViewController {
    
    @IBOutlet var albumImageView: UIImageView!
    @IBOutlet var viewIniTunesButton: UIButton!
    @IBOutlet var albumNameLabel: UILabel!
    @IBOutlet var artistLabel: UILabel!
    @IBOutlet var genreLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var copyrightTextView: UITextView!
    
    var albumDetails: Album? {
        didSet {
            loadAlbumData(albumDetails)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the colors and post nib lovelies.
        configureViews()
        
        // Check if we loaded our data before our view was done loading
        if albumDetails != nil {
            loadAlbumData(albumDetails)
        }
    }
    
    @IBAction func loadiTunes() {
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
        albumNameLabel.textColor = UIColor.albPeach()
        artistLabel.textColor = UIColor.albMelon()
        genreLabel.textColor = UIColor.albPollution()
        dateLabel.textColor = UIColor.albPollution()
        copyrightTextView.textColor = UIColor.albPollution()
        copyrightTextView.backgroundColor = UIColor.clear
    }
    
    private func loadAlbumData(_ album: Album?) {
        // Could be turned into a view model
        guard let album = album, let artistThumbUrl = album.artistThumbUrl else { return }
        
        // Make sure we have already loaded
        guard albumNameLabel != nil else { return }
        
        albumNameLabel.text = album.name
        artistLabel.text = album.artistName
        genreLabel.text = album.genre
        dateLabel.text = album.releaseDate
        copyrightTextView.text = album.copyright
        
        ALBImageCache.shared.cacheImage(urlString: artistThumbUrl, indexPath: nil) { [weak self] (cachedImage, _) in
            self?.albumImageView.image = cachedImage
        }
    }
}
