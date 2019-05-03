//
//  ProductListViewController.swift
//  Doodhwala
//
//  Created by admin on 9/6/17.
//  Copyright © 2017 appzpixel. All rights reserved.
//

import UIKit
import MBProgressHUD

class ProductListViewController: InsufficientViewController {
    var count12 = 0
    @IBOutlet weak var productListView: UIView!
    @IBOutlet var productListTableView: UITableView!
    //@IBOutlet weak var menuButton: UIBarButtonItem!
    
    var selectedCategory: [String: Any]!
    var    productId : Int!
    let DEFAULTCATEGORYID = 2
    var productList: [[String: Any]]? {
        
        didSet {
            
            if productListTableView != nil {
                productListTableView.reloadData()
            }
        }
    }

    func load(){
        
        let userId = UserManager.defaultManager.userDict?["user_id"] as? Int
        APIManager.defaultManager.notifyme(parameters: ["user_id": userId, "product_id": productId , "action_name" : "notify_for_product"]) { (responseDict) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            if let responseDict = responseDict {
                //check for status 000000 for success
                
                if let status = responseDict["status"] as? String {
                    
                    if status == "000000" {
                        
                        if let message = responseDict["msg"] as? String {
                            
                            //   let alert = UIAlertController(title: "You will be Notified ", message: message, preferredStyle: .alert)
                            let alertController = UIAlertController(title: "", message: " You will get notified when product is in the  stock", preferredStyle: .alert)
                            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                            
                            alertController.addAction(cancelAction)
                            
                            let rechargeAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                                
                                
                                if let userId = UserManager.defaultManager.userDict?["user_id"] as? Int {
                                    
                                    APIManager.defaultManager.getProducts(parameters: ["user_id": userId, "cat_id": self.DEFAULTCATEGORYID]) { (responseDict) in
                                        if let responseDict = responseDict {
                                            //check for status 000000 for success
                                            
                                            if let status = responseDict["status"] as? String {
                                                
                                                if status == "000000" {
                                                    //Succcess
                                                    
                                                    if let response = responseDict["product_list"] as? [[String: Any]] {
                                                        
                                                        self.productList = response
                                                    }
                                                    UserManager.defaultManager.getUserDetails()
                                                    
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
                                    }
                                }
                                
                                self.productListTableView.reloadData()
                            }
                            alertController.addAction(rechargeAction)
                            
                            self.present(alertController, animated: true, completion: nil)
                        }
                        
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
            
        }
        self.productListTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(getter: productList), name: Notification.Name(rawValue: "subscriptionUpdated"), object: nil)
        print(productList)
        
        setUpView()
        self.productListTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.productListTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpView() {
        self.setTitleView()
        productListTableView.estimatedRowHeight = 130
        productListTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    
    
}


//MARK: TableView delegate and datasource
extension ProductListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count = 0
        
        if let productList = productList {
            
            count = productList.count
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath) as! ProductTableViewCell
        
        if let product = productList?[indexPath.row] {
            cell.configure(productDict: product)
            
            var status =  product["status"] as! Int
            if status == 2
            {
                
                if let buttonenable =   product["is_button_enable"] as? Int {
                    productId = product["product_id"] as? Int
                    if  buttonenable == 1 {
                        
                        
                        cell.subscribeButton.isEnabled = true
                    }
                    else   if buttonenable == 0   {
                        cell.subscribeButton.isEnabled = false
                    }
                }
                
            }
        }
        return cell
    }
    
}

//MARK:- SUBSCRIBE FEATURE and change quantity
extension ProductListViewController: SubscriptionProtocol {
    
    private func getSubscribeController() -> editSubscriptiontabelViewController? {
        
        if let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "edit") as? editSubscriptiontabelViewController{
            
            //  controller.delegate = self//need to change to protocl
            controller.modalPresentationStyle = .custom
            controller.transitioningDelegate = self
            controller.modalTransitionStyle = .crossDissolve
            
            
            return controller
        }
        
        return nil
    }
    
    
    @IBAction func subscribeAction(_ sender: UIButton) {
        
        if let indexPath = productListTableView.getTableIndexPathFromCellSubView(subView: sender) {
            
            if let selectedProductDict = productList?[indexPath.row],  let subscription = selectedProductDict["subscription"] as? String {
                var status =  selectedProductDict["status"] as! Int
                if status == 2
                {
                    if let buttonenable =   selectedProductDict["is_button_enable"] as? Int {
                        productId = selectedProductDict["product_id"] as? Int
                        if  buttonenable == 1 {
                            
                            self.load()
                            self.productListTableView.reloadData()
                        }
                        
                    }
                    
                }
                else {
                    var subscriptionType =  selectedProductDict["subscription_type"] as? String
                    var controllerIdentifier = ""
                    if (subscriptionType == "Daily") {
                        controllerIdentifier = "SubscriptionViewController"
                    }
                    else  if (subscriptionType == "Both")  {
                        controllerIdentifier = "SubscriptionViewController"
                    }
                        
                        
                    else {
                        controllerIdentifier = "SingleOrderSubscriptionViewController"
                        
                    }
                    showSubscriptionController(selectedProductDict: selectedProductDict, controllerIdentifier: controllerIdentifier)
                }
            }
        }
        
    }
    
    private func showSubscriptionController(selectedProductDict: [String: Any], controllerIdentifier: String) {
        
        if let controller = UIStoryboard(name: "Subscription", bundle: nil).instantiateViewController(withIdentifier: controllerIdentifier) as? SubscriptionViewController {
            
            controller.selectedProductDict = selectedProductDict
            
            if controllerIdentifier == "SingleOrderSubscriptionViewController" {
                controller.subscriptionView = false
                
            }
            else if controllerIdentifier == " SubscriptionViewController" {
                controller.bothCheckBoxButton!.isHidden = true
                controller.bothtextbutton.isHidden = true
            }
            
            
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    private func showPaymentViewController() {
        
        if let controller = UIStoryboard(name: "Payment", bundle: nil).instantiateViewController(withIdentifier: "pay_web_view") as? pay_web_view {
            
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func reloadData() {
        //   loadData()
    }
    
    func showChangeQuantityViewFor(productDict: [[String: Any]]?) {
        
        if let controller = getSubscribeController() {
            
            controller.productDict = productDict
            
            self.present(controller, animated: true, completion: nil)
        }
    }
}

//MARK:- UIViewControllerTransitioningDelegate
extension ProductListViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        let customPresentationController = CustomSizePresentationController(presentedViewController: presented, presenting: presenting)
        
        if let controller = presented as? editSubscriptionTableViewCell {
            
            var height: CGFloat = 350
            
            customPresentationController.presentedControllerSize = CGRect(x: 20, y: self.view.center.y - (height/2 + 64), width: self.view.frame.size.width - 40, height: height)
        }
        
        return customPresentationController
    }
}




