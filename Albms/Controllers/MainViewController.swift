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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        animateProcess(true)
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            dataController = appDelegate.dataController
        }
        
        AlbmsNetworkController.shared.fetchLatestAlbums { [weak self] (success) in
            
            guard let controller = self?.dataController else { return }
            
            if let albums = controller.lookupAlbums(context: controller.privateObjectContext) {
                self?.albums = albums
                ALBUtility.executeOnMainQueue {
                    self?.animateProcess(false)
                    self?.tableview.reloadData()
                }
            }
        }
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let returnCell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell")!
        return returnCell
    }
}

extension MainViewController: UITableViewDelegate {
    
}
