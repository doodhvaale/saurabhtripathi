//
//  editSubscriptionTableViewCell.swift
//  Doodhvale
//
//  Created by localadmin on 3/7/19.
//  Copyright © 2019 appzpixel. All rights reserved.
//

import UIKit


protocol OptionButtonsDelegate{
    func closeFriendsTapped(productDict1 : [String: Any]? )
}

class editSubscriptionTableViewCell: UITableViewCell {
    
     var delegate:OptionButtonsDelegate!
    @IBOutlet weak var changeQuantityLabel: UILabel!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var productNameLabel: UILabel!
    var Disableview : Bool! = false
   
    @IBOutlet weak var deliveryStatusLabel: UILabel!
  
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    var products  =   editSubscriptiontabelViewController.product
    var productretrive: [String: Any]!
    

    


    @IBAction func addAction(_ sender: UIButton) {
        
        
        var indexpath = sender.tag

        if let quantity = Int(self.changeQuantityLabel.text!) {
            if   quantity < 9 {
             self.changeQuantityLabel.text = "\(quantity + 1)"
            products[indexpath].change = quantity + 1
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.changeQuantityLabel =  self.changeQuantityLabel.text!

            }
        }
    }
    var sau = [""]
    
    @IBAction func minusAction(_ sender: UIButton) {
        
          var indexpath = sender.tag
        if let quantity = Int(self.changeQuantityLabel.text!) {
            
              if quantity > 0 {
                 self.changeQuantityLabel.text = "\(quantity - 1)"
                 products[indexpath].change = quantity - 1
                 self.sau =    [self.changeQuantityLabel.text!]

            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    self.Disableview = appDelegate.changeView
                    if self.Disableview == true {
                        
                        self.minusButton.isHidden = true
                        self.plusButton.isHidden = true
                           
                    }
                      else  if self.Disableview == false {
                            self.minusButton.isHidden = false
                            self.plusButton.isHidden =   false
                            
                        }
                    }
        
        
    }
