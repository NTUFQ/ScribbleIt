//
//  ArtworkGalleryCellTableViewCell.swift
//  ScribbleIt
//
//  Created by Fu Qiang on 10/14/16.
//  Copyright © 2016 Fu Qiang. All rights reserved.
//

import UIKit

class ArtworkGalleryTableViewCell: UITableViewCell {
    // properties
    @IBOutlet weak var Picture: UIImageView!
    @IBOutlet weak var owner: UILabel!
    @IBOutlet weak var like: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
