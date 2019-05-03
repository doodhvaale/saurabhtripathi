//
//  MenuViewController.swift
//  Doodhwala
//
//  Created by Rajinder Paul on 22/09/17.
//  Copyright © 2017 appzpixel. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var logoImageview: UIImageView!

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var menuTableView: UITableView!

//    var menuItems = ["Home", "Update Profile", "Account History", "Track Delivery Boy", "Feedback", "Refer & Earn", "Contact Us", "FAQs", "Logout"]
//    var menuIcons = ["home", "pencil", "history", "location", "feedback", "rewards", "contact", "question", "logout"]

    var menuItems = ["Home", "Update Profile", "My Subscriptions","Notification","Account History","Feedback", "Refer & Earn", "Contact Us", "FAQs", "Logout"]
    var menuIcons = ["home", "pencil", "mysubscribe","Notification","history","feedback","rewards", "contact", "question", "logout"]
   
    
    static var selectedMenuIndex: Int?
    
    override var prefersStatusBarHidden: Bool { return true } 

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
     
        MenuViewController.setSelectedMenuIndex(index: 0)
        menuTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .none)
        
        userNameLabel.text = ""
        addressLabel.text = ""
        
        logoImageview.image = UIImage(named: "doodvale")?.withRenderingMode(.alwaysTemplate)
        logoImageview.tintColor = UIColor.black

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let userprofileDict = UserManager.defaultManager.userProfileDict {
            
            if let userProfile = userprofileDict["user_details"] as? [String: Any], let name = userProfile["first_name"] as? String  {
                userNameLabel.text = name
            }

            addressLabel.text = UserManager.defaultManager.getAddress()
            
//            if let userAddress = userprofileDict["address"] as? [String: Any], let name = userAddress["address1"] as? String  {
//                addressLabel.text = name
//            }
        }
    }

    
    fileprivate func getDeliveryBoyContact() {

        if let userId = UserManager.defaultManager.userDict?["user_id"] as? Int {

            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.label.text = "Please wait..."
            
      
            
            APIManager.defaultManager.contactus(parameters: ["user_id": userId,  "action_name" : "contact_us"]) { (responseDict) in

                MBProgressHUD.hide(for: self.view, animated: true)

                if let responseDict = responseDict {
                    //check for status 000000 for success

                    if let status = responseDict["status"] as? String {
                        if status == "000000" {
                            //Succcess
                            if let number = responseDict["contact"] as? String {
                            let message =  responseDict["contact_msg"] as? String
                            self.callDeliveryBoy(number: number , message : message! )
                            } else if let number = responseDict["contact"] as? Int {
                                 let message =  responseDict["contact_msg"] as? String
                                self.callDeliveryBoy(number: "\(number)" , message : message!)
                            }


                        } else {
                            //Failure handle errors

                            if let message = responseDict["msg"] as? String {
                                self.showAlert(message: message)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    fileprivate func callDeliveryBoy(number: String , message : String)  {
        
        if let url = URL(string: "TEL://\(number)") {
            
            let application:UIApplication = UIApplication.shared
            
            if (application.canOpenURL(url)) {
                let alert = UIAlertController(title: "", message:  message, preferredStyle: .alert)
                let callAction = UIAlertAction(title: "Call", style: .default, handler: { (action) in
                    application.openURL(url)
                })
                let noAction = UIAlertAction(title: "No", style: .cancel, handler: { (action) in
                    print("Canceled Call")
                })
                alert.addAction(callAction)
                alert.addAction(noAction)
                self.present(alert, animated: true, completion: nil)
            }
            
            
            
            
            // UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    class func addMenuButton(forController: UIViewController) {
        
        let menuButton = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: nil, action: nil)
        forController.navigationItem.leftBarButtonItem = menuButton
        MenuViewController.configureMenu(button: menuButton, controller: forController)
    }
    
    class func configureMenu(button: UIBarButtonItem, controller: UIViewController) {
        
        if let revealViewController = controller.revealViewController() {
            
            button.target = revealViewController
            button.action = #selector(SWRevealViewController.revealToggle(_:))
            controller.view.addGestureRecognizer(revealViewController.panGestureRecognizer())
        }
    }
    
    class func setSelectedMenuIndex(index: Int?) {
        
        selectedMenuIndex = index
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


//MARK: TableView delegate and datasource
extension MenuViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as! MenuTableViewCell
        if indexPath.row  == 2 {
             cell.wiedth.constant = 20
            
             cell.height.constant = 20
        }
        
        cell.nameLabel?.text = menuItems[indexPath.row]
        
        cell.menuIcon.image = UIImage(named: menuIcons[indexPath.row])?.withRenderingMode(.alwaysTemplate)

        return cell
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//
//        if indexPath.row == MenuViewController.selectedMenuIndex {
//            cell.isSelected = true
//        } else {
//            cell.isSelected = false
//        }
//    }
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let menu = menuItems[indexPath.row]
        
        var controllerIdentifer = "HomeNavigationController"
        var storyBoard = "Main"
        
        switch menu {
            
        case "Home":

            controllerIdentifer = "HomeNavigationController"
       
        case "My Subscriptions" :
   
        controllerIdentifer = "MySubscriptionnavigationViewController"
          storyBoard =    "Subscription"
            
        case "Update Profile":
            
            controllerIdentifer = "ProfileNavigationController"
             storyBoard = "Profile"
            
        case "Account History":
            controllerIdentifer = "AccountHistoryNavigationController"
            storyBoard = "Payment"
            
        case "Track Delivery":
            print(menu)
        
        case "Logout":
            
            controllerIdentifer = "LogOutNavigationController"
            
        case "Contact Us":
          controllerIdentifer = "HomeNavigationController"
           getDeliveryBoyContact()

            
       case  "Notification" :
         controllerIdentifer = "NotificationID"
            
        case "FAQs":
            controllerIdentifer = "FaqNavigationController"
            storyBoard = "Faq"

        case "Feedback":
            controllerIdentifer = "FeedbackNavigationController"
            storyBoard = "Feedback"

        case "Refer & Earn":
            controllerIdentifer = "ReferralNavigationController"
            storyBoard = "Referral"

            
        default:
            
            controllerIdentifer = ""
            print(menu)
            
        }
        
        if controllerIdentifer == "logout" {
            return
        }
        
        let revealViewControler = self.revealViewController()
        
        if controllerIdentifer == "" || MenuViewController.selectedMenuIndex == indexPath.row {

            
            revealViewControler?.removeBlur()
            revealViewControler?.setFrontViewPosition(.left, animated: true)
            
            MenuViewController.selectedMenuIndex = indexPath.row


        } else {
        
            let controller = UIStoryboard(name: storyBoard, bundle: nil).instantiateViewController(withIdentifier: controllerIdentifer)

            if controllerIdentifer == "ProfileNavigationController" {
                
                if let profileNavigationController = controller as? UINavigationController {
                    
                    if let profileController = profileNavigationController.topViewController as? ProfileViewController {
                        profileController.updateProfile = true
                    }
                }
            }

            revealViewControler?.pushFrontViewController(controller, animated: true)

        
            if let prevSelectedIndex = MenuViewController.selectedMenuIndex {
                
                if prevSelectedIndex != indexPath.row {
                    if let cell = tableView.cellForRow(at: IndexPath(row: prevSelectedIndex, section: 0)) {
                        
                        cell.isSelected = false
                    }
                }
            }
        
        MenuViewController.selectedMenuIndex = indexPath.row
        }
        
    }
}
