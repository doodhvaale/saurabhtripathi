//
//  MySubscriptionViewController.swift
//  Doodhvale
//
//  Created by localadmin on 4/2/19.
//  Copyright © 2019 appzpixel. All rights reserved.
//

import UIKit

class MySubscriptionViewController: UIViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var tabelView: UITableView!
    
    var productList: [[String: Any]]? {
        didSet{
            
            tabelView.reloadData()
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
        self.tabelView.separatorStyle = .none
        self.setTitleView()
        MenuViewController.configureMenu(button: menuButton, controller: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        load()
        tabelView.reloadData()
        
    }
    
    
    
    func load(){
        
        let userId = UserManager.defaultManager.userDict?["user_id"] as? Int
        APIManager.defaultManager.mysubscription(parameters: ["user_id": userId ]) { (responseDict) in

            if let responseDict = responseDict {
                //check for status 000000 for success
                
                if let status = responseDict["status"] as? String {
                    
                    if status == "000000" {
                        
                        self.productList = responseDict["my-subscription-list"] as! [[String : Any]]
                        print(self.productList)
                        
                    } else {
                        //Failure handle errors
                        
                        if let message = responseDict["msg"] as? String {
                            
                            let alert = UIAlertController(title: "ERROR!", message: message, preferredStyle: .alert)
                            
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                    
                    
                    
                    
                    
                    
                }
                
            }
            self.tabelView.reloadData()
        }
        
    }

    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension MySubscriptionViewController : UITableViewDataSource, UITableViewDelegate  {
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        
        if let productList =  productList {
            
            count = productList.count
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MysubscriptionTableViewCell", for: indexPath) as! MysubscriptionTableViewCell
        
        if let product = productList {
            
            cell.setupCell(ProductDict: product[indexPath.row] , indexPath: indexPath)
            
        }
        return cell
    }

}

