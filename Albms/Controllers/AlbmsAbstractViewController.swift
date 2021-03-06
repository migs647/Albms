//
//  AlbmsAbstractViewController.swift
//  Albms
//
//  Created by Cody Garvin on 5/7/19.
//  Copyright © 2019 Cody Garvin. All rights reserved.
//

import UIKit


/// A base class that does some nice set up and handles some memory clean up.
class AlbmsAbstractViewController: UIViewController {
    
    let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make sure we're using the correct color status bar
        self.setNeedsStatusBarAppearanceUpdate()
        
        // Make sure the background color is proper
        view.backgroundColor = UIColor.albDarkGray()
        
        view.addSubview(activityIndicator)
        activityIndicator.isHidden = true
        var centerPoint = view.center
        centerPoint.y -= 80
        activityIndicator.center = centerPoint
        
        let backButtonItem: UIBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Back", comment: "Back Button"), style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButtonItem
    }
    
    func animateProcess(_ animate: Bool) {
        if animate {
            view.bringSubviewToFront(activityIndicator)
            activityIndicator.startAnimating()
            activityIndicator.isHidden = false
        } else {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Clear the cache out as that should be the first high memory purge
        // that should happen.
        ALBImageCache.shared.clear()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
