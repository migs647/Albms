//
//  AlbumTableViewCell.swift
//  Albms
//
//  Created by Cody Garvin on 5/7/19.
//  Copyright © 2019 Cody Garvin. All rights reserved.
//

import UIKit

class AlbumTableViewCell: UITableViewCell {
    
    @IBOutlet var albumImageView: UIImageView!
    @IBOutlet var albumLabel: UILabel!
    @IBOutlet var artistLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumImageView.image = UIImage(named: "Albm Generic")
    }
    
    private func configureViews() {
        backgroundColor = UIColor.albDarkGray()
        
        albumImageView.layer.cornerRadius = 5.0
        albumLabel.textColor = UIColor.albPeach()
        artistLabel.textColor = UIColor.albMelon()
    }
    
}
