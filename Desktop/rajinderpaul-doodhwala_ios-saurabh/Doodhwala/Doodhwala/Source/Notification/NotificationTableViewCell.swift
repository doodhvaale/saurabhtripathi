//
//  NotificationTableViewCell.swift
//  Doodhvale
//
//  Created by localadmin on 4/15/19.
//  Copyright © 2019 appzpixel. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var datelabel: UILabel!
    @IBOutlet weak var messageview: UIView!
 
    @IBOutlet weak var messagetext: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        messagetext.isSelectable = false
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
            messagetext.isEditable = false
             messagetext.dataDetectorTypes = UIDataDetectorTypes.link
             messagetext.isSelectable = true
 
        // Configure the view for the selected state
    }
           func configure(productDict: [String: Any]) {
  
            if let meaagevalue = productDict["message_text"] as? String {
                
                
             messagetext.text   = meaagevalue
            }
            if let date = productDict["message_time"] as? String {
                datelabel.text   = date
            }
            
    }
}
