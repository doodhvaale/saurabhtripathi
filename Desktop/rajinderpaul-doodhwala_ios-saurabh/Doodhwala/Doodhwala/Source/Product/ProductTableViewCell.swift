            //
            //  ProductTableViewCell.swift
            //  Doodhwala
            //
            //  Created by Rajinder Paul on 07/09/17.
            //  Copyright © 2017 appzpixel. All rights reserved.
            //
            
            import UIKit
            import Foundation
            import SDWebImage
            
            
            class ProductTableViewCell: UITableViewCell {
                
                @IBOutlet weak var productImageView: UIImageView!
                @IBOutlet weak var nameLabel: UILabel!
                @IBOutlet weak var quantityLabel: UILabel!
                @IBOutlet weak var priceLabel: UILabel!
                @IBOutlet weak var subscribeButton: UIButton!
                @IBOutlet weak var message: UILabel!
                
                @IBOutlet weak var labeonpic: UILabel!
                
                @IBOutlet weak var viewontopofpic: UIView!
                
                var  count : Int?
        
                override func awakeFromNib() {
                    super.awakeFromNib()
                    
                    self.viewontopofpic.isHidden = true
                    DispatchQueue.main.async {
                        self.productImageView.layer.cornerRadius = self.productImageView.frame.size.width / 2
                        self.subscribeButton.layer.cornerRadius = 4
                  
                    }
                }
                
                override func setSelected(_ selected: Bool, animated: Bool) {
                    super.setSelected(selected, animated: animated)
                    
                    
                }
                
                
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
                
                func configure(productDict: [String: Any]) {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    //  count =   appDelegate.count1
                     subscribeButton.isEnabled =  true
                    if let name = productDict["product_name"] as? String {
                        
                        nameLabel.text = name
                    }
                    if let messagelabel =  productDict["product_description"] as? String  {
                        message.text = messagelabel
                    }
                    if let price = productDict["product_price"] as? Double {
                        
                        
                        priceLabel.text! =   "₹ " + String(format: "%.2f", price)
                    }
   
                    if let priceDetails = productDict["product_price_list"] as? [[String: Any]] {
                        if priceDetails.count > 0 {
                            if let unit = priceDetails[0]["unit"] as? String ,  let quantity = priceDetails[0]["quantity"] as? Int{
                                quantityLabel.text =     " " + String(quantity ) + " "  + unit
                            }
                        }
                        else{
                            quantityLabel.text =   "null"
                        }
                    }
                    if     let textonimage = productDict["prod_image_text"] as? String {
                          if   textonimage == "OUT OF STOCK" {
                            
                            self.viewontopofpic.layer.cornerRadius = self.viewontopofpic.frame.size.width / 2
                            self.viewontopofpic.layer.cornerRadius = 4
                            self.labeonpic.isHidden = false
                            self.viewontopofpic.isHidden = false
                            labeonpic.text = textonimage
                            let dimAlphaRedColor =   UIColor.white.withAlphaComponent(0.7)
                            viewontopofpic.backgroundColor =  dimAlphaRedColor
                            
                        }
                        else {
                             self.labeonpic.isHidden = true
                             self.viewontopofpic.isHidden = true

                        }
                        
                        
                        
                    }
                    
                    
                    
                       if let buttonname = productDict["btn_text"] as? String {
                    
                      subscribeButton.setTitle( productDict["btn_text"] as! String ,  for: .normal)
                      let buttoncolor =    ( productDict["button_color"]) as! String
                      subscribeButton.backgroundColor =  hexStringToUIColor(hex: buttoncolor)

                    
                    if let subscriptionType = productDict["subscription_type"] as? String , let stockStatus = productDict["status"] as? Int {
                        if stockStatus == 2 {
                            self.viewontopofpic.layer.cornerRadius = self.viewontopofpic.frame.size.width / 2
                            self.viewontopofpic.layer.cornerRadius = 4
                             self.viewontopofpic.isHidden = false
                            

                              if let buttonenable =   productDict["is_button_enable"] as? Int {
                                 if  buttonenable == 1  {
                                    subscribeButton.isEnabled  =  true
                                 }
                                 else      {
                                    subscribeButton.isEnabled = false
                                }
                                
                            }
                            
                            
                      }
                    }
                    
            
                            if let imageUrlStr = productDict["product_image_url"] as? String {
                    
                                self.productImageView.sd_setShowActivityIndicatorView(true)
                                self.productImageView.sd_setIndicatorStyle(.gray)
                    
                                productImageView.sd_setImage(with: URL(string: APIRouter.baseURLStringForResource + imageUrlStr), placeholderImage: UIImage.defaultImage(), options: .cacheMemoryOnly)
                                }
             
                    
                    }
                    
                }
            }
