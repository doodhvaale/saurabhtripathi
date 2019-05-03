//
//  InsufficientViewController.swift
//  Doodhvale
//
//  Created by Rajinder on 9/6/18.
//  Copyright © 2018 appzpixel. All rights reserved.
//

import UIKit

class InsufficientViewController: UIViewController {

    @IBOutlet weak var rechargeButton: UIButton!
    @IBOutlet weak var insuffMessageLabel: UILabel!

    @IBOutlet weak var insufficientViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var messageonpin: UILabel!
    @IBOutlet weak var PinButton: UIButton!
    @IBOutlet weak var PinChangeView: UIView!
    
    @IBOutlet weak var pinheight: NSLayoutConstraint!
    var insufficientFundsTimer: Timer!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        rechargeButton.layer.cornerRadius = 4
        PinButton.layer.cornerRadius = 4
        insufficientViewHeightConstraint.constant = 0
        pinheight.constant = 0
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        getPrepaidPaymentReminder()
        
    }
    override func viewWillAppear(_ animated: Bool) {
       getPrepaidPaymentReminder()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func blinkView() {
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            if self.rechargeButton.alpha == 0 {
                self.rechargeButton.alpha = 1
            } else {
                self.rechargeButton.alpha = 0
            }

        }, completion: nil)
    }
    
    func showInSufficientView(show: Bool) {
        
        if show {
            insufficientViewHeightConstraint.constant = 50
            if insufficientFundsTimer == nil {
                insufficientFundsTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(blinkView), userInfo: nil, repeats: true)
            }
        } else {
            insufficientViewHeightConstraint.constant = 0
            
            if insufficientFundsTimer != nil {
                insufficientFundsTimer.invalidate()
                insufficientFundsTimer = nil
            }
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            if self.collectionView != nil {
                self.collectionView.reloadData()
            }
        }

    }
    
    func showInPINView(show: Bool) {
        
        if show {
            pinheight.constant = 50
            if insufficientFundsTimer == nil {
                insufficientFundsTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(blinkView), userInfo: nil, repeats: true)
            }
        }
        else {
            pinheight.constant = 0
            
            if insufficientFundsTimer != nil {
                insufficientFundsTimer.invalidate()
                insufficientFundsTimer = nil
            }
        }
        
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
            if self.collectionView != nil {
                self.collectionView.reloadData()
            }
        }
        
    }


    @IBAction func rechargeAction() {
    
        if let controller = UIStoryboard(name: "Payment", bundle: nil).instantiateViewController(withIdentifier: "pay_web_view") as? pay_web_view {
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @IBAction func pinchangeAction(_ sender: Any) {
           if let controller = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "LocationViewController") as? LocationViewController {
            controller.updateProfile = true
            controller.canGoBack = true
            
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


//MARK:- API Methods
extension InsufficientViewController {
    
         func getPrepaidPaymentReminder()
         {
        
        if let userId = UserManager.defaultManager.userDict?["user_id"] as? Int {
            
            APIManager.defaultManager.requestJSON(apiRouter: .prepaidPaymentReminder(["user_id": userId])) { (responseDict) in
                
                if let responseDict = responseDict {
                    //check for status 000000 for success
                    
                    if let status = responseDict["status"] as? String {
                        
                        if status == "000000" {
                            
                            if let message = responseDict["balance_amt"] as? String {
                                self.showInSufficientView(show: true)
                                self.insuffMessageLabel.text = message
                                 if let setbuttononRecharge =  responseDict["insufficient"] as? Int {
                                    if  setbuttononRecharge == 2
                                    {
                                    self.rechargeButton.setTitle ("PAYMENT", for: .normal)
                                    }
                                else{
                                     self.rechargeButton.setTitle ("RECHARGE", for: .normal)
                                     }
                                    
                                 }
                                 else {
                                  
                                self.showInSufficientView(show: false)
                            }
                        }
                            
                            
                        if let message = responseDict["address_update"] as? Int {
                            if message == 0 {
                                self.showInPINView(show: false)
                            }
                                
                            else {
                                self.showInPINView(show: true)
                                  self.PinButton.setTitle("UPDATE", for: .normal)
                                if let message = responseDict["address_update_msg"] as? String {
                                  //   self.messageonpin.lineBreakMode = .byWordWrapping
                                     self.messageonpin.lineBreakMode = NSLineBreakMode.byWordWrapping
                                      self.messageonpin.numberOfLines = 0
                                    self.messageonpin.text = message
                                }
                                
                            }
                            
                            }
                            
                        }
                            
                            
                            
                    }
                }
            }
        }
    }
}
