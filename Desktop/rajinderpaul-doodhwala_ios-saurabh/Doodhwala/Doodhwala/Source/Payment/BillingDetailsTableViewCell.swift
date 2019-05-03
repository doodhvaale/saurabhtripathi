//
//  BillingDetailsTableViewCell.swift
//  Doodhvale
//
//  Created by Rajinder on 8/28/18.
//  Copyright © 2018 appzpixel. All rights reserved.
//

import UIKit

class BillingDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var unitPriceLabel: UILabel!
    @IBOutlet weak var qtyLabel: UILabel!
    @IBOutlet weak var amtLabel: UILabel!

    @IBOutlet weak var bottomHorizotalSeparator: UIView!
    
    @IBOutlet weak var moreInfoButton: UIButton!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(data: [String: Any], row: Int, totalRows: Int, subTotalRows: Int, brokenBottleInfo: (count: Int, price: Double)) {
        
        if moreInfoButton != nil {
            moreInfoButton.isHidden = true
        }
        
        if (row == totalRows + subTotalRows - 1) {
            bottomHorizotalSeparator.isHidden = false
            
        } else  {
            bottomHorizotalSeparator.isHidden = true
        }
        
        if row >= totalRows {
            
            if row ==  totalRows {
                //Total row
                nameLabel.text = "Total"
                if let value = data["delivered_quantity"] as? Int {
                    qtyLabel.text = "\(value)"
                } else {
                    qtyLabel.text = ""
                }
                if let value = data["sub_total"] as? Double {
                  //   amtLabel.text
                         amtLabel.text! =   "₹" + String(format: "%.2f", value)
                    //amtLabel.text = "\(value)"
                } else {
                    amtLabel.text = ""
                }
            } else if brokenBottleInfo.count > 0 && ((totalRows + subTotalRows) - row) > 2 {
                
                //brokenBottleInfo.text = "Broken Bottle@ Rs "
                let text = "Broken Bottle@ Rs" + "\(brokenBottleInfo.price)"
                nameLabel.setUnderlineText(text: text)
                nameLabel.textColor = UIColor.blue
                qtyLabel.text = "\(brokenBottleInfo.count)"
                
                amtLabel.text = "\(brokenBottleInfo.count * Int(brokenBottleInfo.price))"
                
                moreInfoButton.isHidden = false

            }
            //Last 2 rows will be prev bal and total bal. on top of any number of if else can come
            else if ((totalRows + subTotalRows) - row) == 2 {
                //Total row
                nameLabel.text = "Previous Balance"
                qtyLabel.text = ""
                
                if let value = data["previous_due_amount"] as? Double{
             
                
                   // amtLabel.text = "\(value)"
                           amtLabel.text! =   "₹" + String(format: "%.2f", (value))
                } else {
                    amtLabel.text = ""
                }
            }
            else if ((totalRows + subTotalRows) - row) == 1 {
                //Total row
                nameLabel.text = "Total Bill Amount"
                qtyLabel.text = ""
                if let value = data["net_payable_amount"] as? Double {
                    amtLabel.text! =   "₹" + String(format: "%.2f", value)
                } else {
                    amtLabel.text = ""
                }
            }
            
        } else {
            
             if let value = data["delivery_date"] as? String {
                let dateString =  value
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let date = dateFormatter.date(from: dateString)
                dateFormatter.dateFormat = "dd-MM-yyyy"
                let s = dateFormatter.string(from: date!)
                
                dateLabel.text = s
                
                
              //  dateLabel.text = value
            } else {
                dateLabel.text = ""
            }
            if let value = data["product"] as? String {
                nameLabel.text = value
            } else {
                nameLabel.text = ""
            }
            
            if let value = data["mrp"] as? Double {
                unitPriceLabel.text =   "₹" + String(format: "%.2f", value)
                //unitPriceLabel.text = "\(value)"
            } else {
                unitPriceLabel.text = ""
            }
            
            if let value = data["delivered"] as? Int {
                qtyLabel.text = "\(value)"
            } else {
                qtyLabel.text = ""
            }
            
            if let value = data["row_amount"] as? Double {
            amtLabel.text! =   "₹" + String(format: "%.2f", value)
            } else {
                amtLabel.text = ""
            }
        }

    }

}
