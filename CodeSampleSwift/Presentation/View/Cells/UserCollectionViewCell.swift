//
//  CollectionViewCell.swift
//  SwipeCollectionTest
//
//  Copyright © 2017 godstar124. All rights reserved.
//

import UIKit

class UserCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var likeIcon: UIImageView!
    @IBOutlet weak var dislikeIcon: UIImageView!
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userbio: UILabel!
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupShadow()
        hideIcons()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userAvatar.image = nil
        hideIcons()
    }
    
    fileprivate func hideIcons() {
        dislikeIcon.alpha = 0
        likeIcon.alpha = 0
    }
    
    fileprivate func setupShadow() {
        self.layer.cornerRadius = 4
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width:1, height:1)
    }
}
