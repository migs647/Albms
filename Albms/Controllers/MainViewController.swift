//
//  ViewController.swift
//  Albms
//
//  Created by Cody Garvin on 5/6/19.
//  Copyright © 2019 Cody Garvin. All rights reserved.
//

import UIKit

class MainViewController: AlbmsAbstractViewController {
    
    @IBOutlet var tableview: UITableView!
    private var albums: [Album]?
    private var dataController: AlbmsDataController?
    private var selectedAlbum: Album?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start an animation of the loading of the albums
        animateProcess(true)
        tableview.separatorStyle = .none
        
        // Grab the data controller so we can use it to load all of the albums
        // from Core Data
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            dataController = appDelegate.dataController
        }
        
        // Send a request out to grab the albums
        AlbmsNetworkController.shared.fetchLatestAlbums { [weak self] (success) in
            
            guard let controller = self?.dataController else { return }
            
            if let albums = controller.lookupAlbums(context: controller.privateObjectContext) {
                self?.albums = albums
                ALBUtility.executeOnMainQueue {
                    self?.animateProcess(false)
                    self?.tableview.separatorStyle = .singleLine
                    self?.tableview.reloadData()
                }
            }
        }
        
        // Configure views
        configureViews()
        
        // TODO: Grab the albums out of cache in case the network does not
        // return any results.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let nextViewController = segue.destination as? DetailsViewController,
            let selectedAlbum = selectedAlbum {
            nextViewController.albumDetails = selectedAlbum
        }
    }
    
    private func configureViews() {
        view.backgroundColor = UIColor.albDarkGray()
        tableview.backgroundColor = UIColor.albDarkGray()
        tableview.separatorColor = UIColor.albMediumGray()
    }
}

////////////////////////////////////////////////////////////////////////////////
// MARK: - MainViewController UITableViewDataSource Methods
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Verify we can grab a cell, then fill out the details of the album
        guard let returnCell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell") as? AlbumTableViewCell else {
            fatalError("Could not dequeue a cell -- fix for production code")
        }
        
        if let albums = albums, albums.count > indexPath.row {
            let album = albums[indexPath.row]
            returnCell.albumLabel.text = album.name
            returnCell.artistLabel.text = album.artistName
            
            if let albumThumbUrl = album.artistThumbUrl {
                ALBImageCache.shared.cacheImage(urlString: albumThumbUrl, indexPath: indexPath) { [weak self] (returnedImaged, returnedIndexPath) in
                    if let returnedIndexPath = returnedIndexPath {
                        if let cellToUse = self?.tableview?.cellForRow(at: returnedIndexPath) as? AlbumTableViewCell {
                            cellToUse.albumImageView.image = returnedImaged
                        }
                    }
                }
            }
        }
        
        return returnCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

////////////////////////////////////////////////////////////////////////////////
// MARK: - MainViewController UITableViewDelegate Methods
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableview.deselectRow(at: indexPath, animated: true)
        
        if let albums = albums, albums.count > indexPath.row {
            selectedAlbum = albums[indexPath.row]
        }
        
        performSegue(withIdentifier: "DetailsID", sender: self)
    }
}
