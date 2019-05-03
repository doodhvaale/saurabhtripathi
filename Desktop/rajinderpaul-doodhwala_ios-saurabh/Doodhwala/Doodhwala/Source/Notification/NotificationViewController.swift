//
//  NotificationViewController.swift
//  Doodhvale
//
//  Created by localadmin on 4/15/19.
//  Copyright © 2019 appzpixel. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController {


       
    
     var notificationList: [[String: Any]]? = []
        
    var isLoadMoreData : Bool = false

 
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var tabelview: UITableView!
     var counting  = 0
    var pageIndex : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabelview.separatorStyle = .none
        MenuViewController.configureMenu(button: menuButton, controller: self)
        self.setTitleView()
//        NotificationCenter.default.addObserver(self, selector: #selector(getter: notificationList), name: Notification.Name(rawValue: "pageIndex"), object: nil)
        getNotification()
   }  
}


extension NotificationViewController    : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        
        if let productList = notificationList {
            
            count = productList.count
            counting = count
        }
        
        return count
    
    }
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as! NotificationTableViewCell
        if let product = notificationList?[indexPath.row] {
            cell.configure(productDict: product)
        }
        
    
        return cell
   
   
  }
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let offsetY = scrollView.contentOffset.y
//        let contentHeight = scrollView.contentSize.height
//
//        if offsetY > contentHeight - scrollView.frame.size.height {
//
//
//            getNotification()
//
//        }
//    }
    
    
     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = notificationList!.count - 1
        print(lastElement)
          if indexPath.row == lastElement  &&  !isLoadMoreData  {
         isLoadMoreData = true
       
          getNotification()
            

     }
    }
}
extension NotificationViewController  {
    fileprivate func getNotification() {
        
        if let userId = UserManager.defaultManager.userDict?["user_id"] as? Int {
            
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.label.text = "Please wait..."

              APIManager.defaultManager.notification(parameters: ["user_id": userId,  "action_name" : "notification" , "page_no" : "\(self.pageIndex)"]) { (responseDict) in
                print(self.pageIndex)
                MBProgressHUD.hide(for: self.view, animated: true)
                
                if let responseDict = responseDict {
                    //check for status 000000 for success
                    
                    if let status = responseDict["status"] as? String {
                        if status == "000000" {
                           // self.isLoadMoreData = false
                          self.pageIndex = self.pageIndex + 1
                            print(self.pageIndex)
                            if let response = responseDict["notification-list"] as? [[String: Any]] {
                             
                               
                                for i in response {
                               
                                    
                                      self.notificationList?.append(i)
                                
                                  
                                }
                            
                    
                            }
                          
                        } else {
                            //Failure handle errors
                            MBProgressHUD.hide(for: self.view, animated: true)
                            if let message = responseDict["msg"] as? String {
                                self.showAlert(message: message)
                            }
                        }
                    }
                }
              self.tabelview.reloadData()
            }
            
        }
    }
    
    
    
    
}
