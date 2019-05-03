//
//  BillingTableViewCell.swift
//  Doodhvale
//
//  Created by Rajinder on 8/28/18.
//  Copyright © 2018 appzpixel. All rights reserved.
//

import UIKit

class BillingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var billCycleLabel: UILabel!
    @IBOutlet weak var billGenerationDateLabel: UILabel!
    @IBOutlet weak var bottomHorizotalSeparator: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCell(data: [String: Any], row: Int, totalRows: Int) {
        
        if (row == totalRows - 1) {
            bottomHorizotalSeparator.isHidden = false
            
        } else  {
            bottomHorizotalSeparator.isHidden = true
        }
        
        if let value = data["bill_cycle"] as? String {
            billCycleLabel.text = value
        }
        
        if let value = data["billing_gen_date"] as? String {
            
            let dateString =  value.components(separatedBy: " ")[0]
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: dateString)
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let s = dateFormatter.string(from: date!)
            
            //  billGenerationDateLabel.text =    ":" + s
            
            billGenerationDateLabel.text = "Dated: " + s.components(separatedBy: " ")[0]
        }
        
        
        
    }
    
}


