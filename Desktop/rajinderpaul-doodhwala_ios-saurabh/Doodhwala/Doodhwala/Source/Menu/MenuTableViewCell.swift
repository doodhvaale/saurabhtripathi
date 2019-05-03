//
//  MenuTableViewCell.swift
//  Doodhwala
//
//  Created by Rajinder Paul on 28/09/17.
//  Copyright © 2017 appzpixel. All rights reserved.
//

import UIKit
import SDWebImage

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var backgroundSubView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var menuIcon: UIImageView!
    
    @IBOutlet weak var wiedth: NSLayoutConstraint!
    @IBOutlet weak var height: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
      //  menuIcon.layer.cornerRadius = menuIcon.bounds.width / 2
     //   menuIcon.layer.borderWidth = 2
      //  menuIcon.layer.borderColor = UIColor.black.cgColor
    //    menuIcon.clipsToBounds = true
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
     self.menuIcon.layoutMargins = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state

        if selected {
      
            backgroundSubView.backgroundColor = UIColor.darkOrange
            nameLabel.textColor = UIColor.white
            menuIcon.tintColor = UIColor.white
       
        } else {
     
            backgroundSubView.backgroundColor = UIColor.white
            nameLabel.textColor = UIColor.black
            menuIcon.tintColor = UIColor.darkGray
        
        }
    }
}
