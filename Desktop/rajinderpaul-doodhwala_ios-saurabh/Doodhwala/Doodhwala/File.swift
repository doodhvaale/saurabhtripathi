////
////  File.swift
////  Doodhvale
////
////  Created by localadmin on 4/16/19.
////  Copyright © 2019 appzpixel. All rights reserved.
////
////
////  editSubscriptiontabelViewController.swift
////  Doodhvale
////
////  Created by localadmin on 3/7/19.
////  Copyright © 2019 appzpixel. All rights reserved.
////
//
//import UIKit
//protocol SubscriptionProtocol {
//    
//    func reloadData()
//    func showChangeQuantityViewFor(productDict : [[String: Any]]?)
//    
//}
//
//class editSubscriptiontabelViewController: UIViewController {
//    
//    
//    @IBOutlet weak var ChangeQuantityView: UIView!
//    var disableView = false
//    @IBOutlet weak var submitChangeQuantityAction: UIButton!
//    
//    @IBOutlet weak var tabelview: UITableView!
//    @IBOutlet weak var dateLabel: UILabel!
//    
//    //  var dataModels = [DataModel]()
//    var sum :Int = 0
////    var oldsum :Int = 0
//    var count :Int = 0
//    public  static var product: [DataModel] = []
//    var idValue = [Int]()
//    
//    fileprivate let formatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd-MM-yyyy"
//        return formatter
//    }()
//    var datePicker: UIDatePicker!
//    
//    var productDict: [[String: Any]]?
//    var   selectedProductDict: [String: Any]?
//    //var delegate: SubscriptionProtocol ?
//    var editForDate: Date?
//    
//    
//    
//    var info : [String: Any]?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        
//        
//        
//        abc()
//        setupView()
//        ChangeQuantityView.layer.cornerRadius = 5
//        tabelview.reloadData()
//    }
//    
//    
//    
//    func abc()
//    {
//        if editSubscriptiontabelViewController.product != nil && editSubscriptiontabelViewController.product.count > 0{
//            editSubscriptiontabelViewController.product = []
//        }
//        for dict in productDict! {
//            // Condition required to check for type safety :)
//            
//            let name = dict["product_name"] as? String
//            let subscriptionId12 = dict["subscription_id"] as? Int
//            let quantity = dict["quantity"] as? Int
//            let status = dict["delivery_status"] as? String
//            print(quantity)
//            let object = DataModel(change: quantity, product: name,  delivery :status, subscriptionvalue : subscriptionId12)
//            editSubscriptiontabelViewController.product.append(object)
//            print(editSubscriptiontabelViewController.product)
//        }
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        tabelview.reloadData()
//    }
//    
//    
//    
//    private func setupView() {
//        
//        self.view.layer.cornerRadius = 16
//        
//        
//        submitChangeQuantityAction.layer.cornerRadius = 8
//        
//        if let date = self.editForDate {
//            dateLabel.text = self.formatter.string(from: date)
//        }
//        if disableView == true {
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            appDelegate.changeView = true
//            
//            //ChangeQuantityView.backgroundColor = UIColor.lightGray
//            
//        }
//        if disableView == false {
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            appDelegate.changeView = false
//            
//            //ChangeQuantityView.backgroundColor = UIColor.white
//            
//        }
//        
//        
//        
//    }
//    
//}
//
//
//extension editSubscriptiontabelViewController : UITableViewDataSource, UITableViewDelegate
//{
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        var count = 0
//        if let subItems = productDict as? [[String: Any]] {
//            
//            count = subItems.count
//        }
//        print (count)
//        return count
//        
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "editSubscriptionTableViewCell", for: indexPath) as!
//        editSubscriptionTableViewCell
//        
//        let model: DataModel
//        
//        model = editSubscriptiontabelViewController.product[indexPath.row]
//        
//        
//        cell.productNameLabel.text = model.product!
//        let value = nullToNil(value: model.change as AnyObject)
//        if  value != nil {
//            cell.changeQuantityLabel.text =  "\(model.change!)"
//        }
//            
//        else{
//            cell.changeQuantityLabel.text =  "0"
//        }
//        
//        if disableView {
//            cell.contentView.backgroundColor = UIColor.extraLightGray
//            self.ChangeQuantityView.backgroundColor =  UIColor.extraLightGray
//            tabelview.backgroundColor =  UIColor.extraLightGray
//            cell.minusButton.alpha = 0
//            cell.plusButton.alpha = 0
//            self.view.backgroundColor = UIColor.extraLightGray
//        }
//        else{
//            self.view.backgroundColor = UIColor.white
//        }
//        
//        
//        cell.deliveryStatusLabel.text = model.delivery!
//        cell.plusButton.tag = indexPath.row
//        cell.minusButton.tag = indexPath.row
//        cell.backgroundColor = UIColor.lightGray
//        return cell
//        
//        
//    }
//    
//    
//    func nullToNil(value : AnyObject?) -> AnyObject? {
//        if value is NSNull {
//            return nil
//        } else {
//            return value
//        }
//    }
//    
//    
//}
//
//extension editSubscriptiontabelViewController {
//    
//    @IBAction func submitChangeQuantityAction(_ sender: UIButton) {
//        if disableView == true  {
//            
//            self.dismiss(animated: true, completion: nil)
//            return
//        }
//        
//        var   paramCollection = [Any]()
//        var changeidvalue = [Int]()
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy/MM/dd"
//        let startDate = formatter.string(from: self.editForDate!)
//        let userId = UserManager.defaultManager.userDict?["user_id"] as? Int
//        //    for subscription in productDict! {
//        
//        
//        if let productDict = productDict, let subscriptionId = idValue as? [Int] {
//            idValue = []
//            for i in productDict
//            {
//                
//                if let originalid  = i["subscription_id"] as? Int {
//                    var subid = originalid
//                    var ismatched = false
//                    var changevaled = 0
//                    for j in editSubscriptiontabelViewController.product{
//                        if subid == j.subscriptionvalue{
//                            changevaled = j.change!
//                            if let originalQuantity = i["quantity"] as? Int {
//                                if originalQuantity == j.change{
//                                    ismatched = true
//                                }
//                                
//                                
//                            }
//                            
//                        }
//                            
//                        else{
//                            if let oriQuantity = i["quantity"] as? Int {
//                                
//                                oldsum =  oldsum + oriQuantity
//                                
//                                break
//                            }
//                        }
//                    }
//                    if  !ismatched   {
//                        idValue.append(subid)
//                        changeidvalue.append(changevaled)
//                    }
//                    
//                }
//            }
//            
//            
//            
//            let subscriptionchangedarray = changeidvalue  as? [Int]
//            let subscriptionId = idValue as? [Int]
//            var index = 0
//            paramCollection = [Any]()
//            for personData in subscriptionId! {
//                var dataCollection = [String:Any]()
//                dataCollection["id"] = personData
//                dataCollection["quantity"] = subscriptionchangedarray![index]
//                sum =  (sum + subscriptionchangedarray![index] as? Int)!
//                paramCollection.append(dataCollection)
//                index += 1
//            }
//            
//            if paramCollection.count == 0 {
//                
//                self.dismiss(animated: true, completion: nil)
//                return
//            }
//            
//            if   paramCollection.count > 0 {
//                if sum > 0 {
//                    
//                    var subscriptionsString = ""
//                    if let jsonData = try? JSONSerialization.data(withJSONObject: paramCollection, options: []) {
//                        
//                        if let value = String(data: jsonData, encoding: .utf8) {
//                            subscriptionsString = value
//                            
//                        }
//                    }
//                    
//                    
//                    let parameters = ["user_id": userId, "start_date": startDate, "subscriptions": subscriptionsString] as [String : Any]
//                    
//                    
//                    APIManager.defaultManager.requestJSON(apiRouter: .updateSubscription(parameters)) { (responseDict) in
//                        
//                        // MBProgressHUD.hide(for: self.view, animated: true)
//                        
//                        if let responseDict = responseDict {
//                            //check for status 000000 for success
//                            
//                            if let status = responseDict["status"] as? String {
//                                
//                                if status == "000000" {
//                                    //Succcess
//                                    
//                                    print("SUCCESS")
//                                    let alert = UIAlertController(title: "SUCCESS", message: "Subscription has been updated successfully.", preferredStyle: .alert)
//                                    
//                                    let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
//                                        self.dismiss(animated: true, completion: {
//                                            
//                                            self.dismiss(animated: true, completion: nil)
//                                        })
//                                    })
//                                    alert.addAction(okAction)
//                                    
//                                    self.present(alert, animated: true, completion: nil)
//                                    
//                                }
//                                else {
//                                    //Failure handle errors
//                                    
//                                    self.dismiss(animated: true, completion: nil)
//                                    return
//                                    
//                                    
//                                }
//                            }
//                        }
//                        self.tabelview.reloadData()
//                    }
//                }
//                    
//                    
//                else {
//                    
//                    let alertController = UIAlertController(title: "Alteast one product qunatity must be greater than zero" , message: nil , preferredStyle: .alert)
//                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){ (action) in
//                        self.tabelview.reloadData()
//                    }
//                    
//                    alertController.addAction(cancelAction)
//                    self.present(alertController, animated: true, completion: nil)
//                    
//                    
//                }
//            }
//                
//                
//            else {
//                
//                if    oldsum + sum  > 0 {
//                    
//                    var subscriptionsString = ""
//                    if let jsonData = try? JSONSerialization.data(withJSONObject: paramCollection, options: []) {
//                        
//                        if let value = String(data: jsonData, encoding: .utf8) {
//                            subscriptionsString = value
//                            
//                        }
//                    }
//                    
//                    
//                    let parameters = ["user_id": userId, "start_date": startDate, "subscriptions": subscriptionsString] as [String : Any]
//                    
//                    
//                    APIManager.defaultManager.requestJSON(apiRouter: .updateSubscription(parameters)) { (responseDict) in
//                        
//                        // MBProgressHUD.hide(for: self.view, animated: true)
//                        
//                        if let responseDict = responseDict {
//                            //check for status 000000 for success
//                            
//                            if let status = responseDict["status"] as? String {
//                                
//                                if status == "000000" {
//                                    //Succcess
//                                    
//                                    print("SUCCESS")
//                                    let alert = UIAlertController(title: "SUCCESS", message: "Subscription has been updated successfully.", preferredStyle: .alert)
//                                    
//                                    let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
//                                        self.dismiss(animated: true, completion: {
//                                            
//                                            self.dismiss(animated: true, completion: nil)
//                                        })
//                                    })
//                                    alert.addAction(okAction)
//                                    
//                                    self.present(alert, animated: true, completion: nil)
//                                    
//                                }
//                                else {
//                                    //Failure handle errors
//                                    
//                                    self.dismiss(animated: true, completion: nil)
//                                    return
//                                    
//                                    
//                                }
//                            }
//                        }
//                        self.tabelview.reloadData()
//                        
//                    }
//                    
//                }
//                    
//                else {
//                    
//                    let alertController = UIAlertController(title: "Alteast one product qunatity must be greater than zero" , message: nil , preferredStyle: .alert)
//                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){ (action) in
//                        self.tabelview.reloadData()
//                    }
//                    
//                    alertController.addAction(cancelAction)
//                    self.present(alertController, animated: true, completion: nil)
//                }
//            }
//        }
//        
//    }
//    
//    
//    
//}
//
//
