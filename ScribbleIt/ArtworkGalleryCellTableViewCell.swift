//
//  ArtworkGalleryCellTableViewCell.swift
//  ScribbleIt
//
//  Created by Fu Qiang on 10/14/16.
//  Copyright © 2016 Fu Qiang. All rights reserved.
//

import UIKit
import FaveButton
import FBSDKCoreKit
class ArtworkGalleryTableViewCell: UITableViewCell, FaveButtonDelegate {
    // properties
    @IBOutlet weak var Picture: UIImageView!
    @IBOutlet weak var owner: UILabel!
    @IBOutlet weak var like: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var profileImage: SwiftyAvatar!
    @IBOutlet weak var likeView: UIView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    var likeButton: FaveButton?
    var artwork: Artwork?
    var likePk: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        likeButton = FaveButton(
            frame: CGRect(x: 0, y: 0, width: 30, height: 30),
            faveIconNormal: UIImage(named: "heart")
        )
        likeButton?.delegate = self
        likeView.addSubview(likeButton!)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func faveButton(_ faveButton: FaveButton, didSelected selected: Bool){
        if !selected {
            API().deleteLike(pk: likePk!){
                result in
                if result{
                    self.like.text = String(Int(self.like.text!)! - 1)
                    //self.likeButton?.isSelected = false
                }
            }
        }
        else{
            API().postLike(ownerId: FBSDKAccessToken.current().userID, artworkId: (artwork?.pk)!){
                result in
                print(result)
                self.likePk = result
                    self.like.text = String(Int(self.like.text!)! + 1)
                    //self.likeButton?.isSelected = true
            }
        }
    }


}
