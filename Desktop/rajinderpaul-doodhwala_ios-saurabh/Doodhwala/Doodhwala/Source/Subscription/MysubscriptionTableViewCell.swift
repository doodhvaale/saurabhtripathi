//
//  MysubscriptionTableViewCell.swift
//  Doodhvale
//
//  Created by localadmin on 4/2/19.
//  Copyright © 2019 appzpixel. All rights reserved.
//

import UIKit

class MysubscriptionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var subscriptionview: UIView!
    @IBOutlet weak var paymentMode: UILabel!
    @IBOutlet weak var packingLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    
    @IBOutlet weak var WeekDayStackView: WeekDaysStackView!
    @IBOutlet weak var scheduleLabel: UILabel!
    
    var     typeofscheduleLabel : String!
    
    
    @IBOutlet weak var sundaylabel: UILabel!
    @IBOutlet weak var mondayalbel: UILabel!
    
    @IBOutlet weak var tuesdayLAbeldayLabel: UILabel!
    
    @IBOutlet weak var wednesdayLabel: UILabel!
    
    @IBOutlet weak var thusdayLabel: UILabel!
    
    @IBOutlet weak var saturdayLabel: UILabel!
    @IBOutlet weak var fridayLabel: UILabel!
    @IBOutlet weak var product: UILabel!
    @IBOutlet weak var Qunatity: UILabel!
    @IBOutlet weak var Statuslabel: UILabel!
    @IBOutlet weak var Schedule: UILabel!
    @IBOutlet weak var PaymentModelabel: UILabel!
    @IBOutlet weak var Price: UILabel!
    @IBOutlet weak var Packing: UILabel!
    
    @IBOutlet weak var  sun: UIButton!
    @IBOutlet weak var mon: UIButton!
    @IBOutlet weak var tues: UIButton!
    @IBOutlet weak var wed: UIButton!
    @IBOutlet weak var thus: UIButton!
    @IBOutlet weak var fri: UIButton!
    @IBOutlet weak var sat: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.subscriptionview.layer.cornerRadius = 8
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    
    func setupCell(ProductDict: [String: Any] ,indexPath: IndexPath) {
        
        print(indexPath)
        
        func hexStringToUIColor (hex:String) -> UIColor {
            var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
            
            if (cString.hasPrefix("#")) {
                cString.remove(at: cString.startIndex)
            }
            
            if ((cString.count) != 6) {
                return UIColor.gray
            }
            
            var rgbValue:UInt32 = 0
            Scanner(string: cString).scanHexInt32(&rgbValue)
            
            return UIColor(
                red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: CGFloat(1.0)
            )
        }
        
        let buttoncolor =    ProductDict["font_color"] as! String
        if let value = ProductDict["product_name"] as? String {
            self.productName.text = value
            
            self.productName.textColor  =  hexStringToUIColor(hex: buttoncolor)
            self.product.textColor  =  hexStringToUIColor(hex: buttoncolor)
            
        }
        
        
        if let value = ProductDict["status"] as? String {
            self.status.text = value
            self.status.textColor  =  hexStringToUIColor(hex: buttoncolor)
            self.Statuslabel.textColor  =  hexStringToUIColor(hex: buttoncolor)
        }
        
        if let value = ProductDict["price"] as? Double {
         
            self.priceLabel.text =   "₹" + String(format: "%.2f",  value)
            self.priceLabel.textColor  =  hexStringToUIColor(hex: buttoncolor)
            self.Price.textColor  =  hexStringToUIColor(hex: buttoncolor)
        }
        
        
        if let value = ProductDict["packing"] as? String {
            self.packingLabel.text = value
            self.packingLabel.textColor  =  hexStringToUIColor(hex: buttoncolor)
            self.Packing.textColor  =  hexStringToUIColor(hex: buttoncolor)
        }
        
        
        if let value = ProductDict["payment"] as? String {
            self.paymentMode.text = value
            self.paymentMode.textColor  =  hexStringToUIColor(hex: buttoncolor)
            self.PaymentModelabel.textColor  =  hexStringToUIColor(hex: buttoncolor)
        }
        
        if let value = ProductDict["schedule"] as? String {
            self.scheduleLabel.text =  value
            self.scheduleLabel.textColor  =  hexStringToUIColor(hex: buttoncolor)
            self.Schedule.textColor  =  hexStringToUIColor(hex: buttoncolor)
            self.typeofscheduleLabel = value
            
            
            
        }
        
        
        
        DispatchQueue.main.async {
            if   self.typeofscheduleLabel == "Customized" {
                self.quantityLabel.isHidden = true
                self.WeekDayStackView.isHidden = false
                self.Qunatity.textColor = hexStringToUIColor(hex: buttoncolor)
                if let value = ProductDict["sunday"] as? Int {
                    self.sundaylabel.text =     "\(value)"
                    self.sundaylabel.textColor  =  hexStringToUIColor(hex: buttoncolor)
                    //   self.sun.textColor  =    hexStringToUIColor(hex: buttoncolor)
                    
                    self.sun.setTitleColor(self.sundaylabel.textColor , for: .normal)
                }
                
                
                if let value = ProductDict["monday"] as? Int {
                    self.mondayalbel.text =     "\(value)"
                    self.mondayalbel.textColor  =  hexStringToUIColor(hex: buttoncolor)
                    self.mon.setTitleColor(self.sundaylabel.textColor , for: .normal)
                }
                
                
                
                if let value = ProductDict["tuesday"] as? Int {
                    self.tuesdayLAbeldayLabel.text =     "\(value)"
                    self.tuesdayLAbeldayLabel.textColor  =  hexStringToUIColor(hex: buttoncolor)
                    self.tues.setTitleColor(self.sundaylabel.textColor , for: .normal)
                }
                
                
                if let value = ProductDict["wednesday"] as? Int {
                    self.wednesdayLabel.text =     "\(value)"
                    self.wednesdayLabel.textColor  =  hexStringToUIColor(hex: buttoncolor)
                    self.wed.setTitleColor(self.sundaylabel.textColor , for: .normal)
                }
                
                if let value = ProductDict["thursday"] as? Int {
                    self.thusdayLabel.text =     "\(value)"
                    self.thusdayLabel.textColor  =  hexStringToUIColor(hex: buttoncolor)
                    self.thus.setTitleColor(self.sundaylabel.textColor , for: .normal)
                }
                
                if let value = ProductDict["friday"] as? Int {
                    self.fridayLabel.text =     "\(value)"
                    self.fridayLabel.textColor  =  hexStringToUIColor(hex: buttoncolor)
                    self.fri.setTitleColor(self.sundaylabel.textColor , for: .normal)
                }
                
                if let value = ProductDict["saturday"] as? Int {
                    self.saturdayLabel.text =     "\(value)"
                    self.saturdayLabel.textColor  =  hexStringToUIColor(hex: buttoncolor)
                    self.sat.setTitleColor(self.sundaylabel.textColor , for: .normal)
                }
                
                
                
            }
                //            else if self.typeofscheduleLabel  == "Everyday" {
            else {
                self.WeekDayStackView.isHidden = true
                self.quantityLabel.isHidden = false
                if   let value = ProductDict["quantity"]  {
                    self.quantityLabel.text =   "\(value)"
                    self.quantityLabel.textColor  =  hexStringToUIColor(hex: buttoncolor)
                    self.Qunatity.textColor = hexStringToUIColor(hex: buttoncolor)
                }
                
                
            }
            
            
        }
    }
}

extension UIColor {
    
    convenience init(rgb: UInt) {
        self.init(rgb: rgb, alpha: 1.0)
    }
    
    convenience init(rgb: UInt, alpha: CGFloat) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
}

