            //
            //  SubscriptionViewController.swift
            //  Doodhwala
            //
            //  Created by Rajinder Paul on 20/03/18.
            //  Copyright © 2018 appzpixel. All rights reserved.
            //
            
            import UIKit
            import MBProgressHUD
            import SDWebImage
            
            enum DeliveryFrequency: Int {
                
                case custom = 1
                case alternate = 2
                case everyday = 3
                case both = 4
            }
            
            class SubscriptionViewController: UIViewController , UITextFieldDelegate {
                
                
                @IBOutlet weak var scrollView: UIScrollView!
                @IBOutlet weak var productMessageLabel : UILabel!
                @IBOutlet weak var productNameLabel: UILabel!
                @IBOutlet weak var priceDetailsLabel: UILabel!
                @IBOutlet weak var productImageView: UIImageView!
                
                @IBOutlet weak var yesBellButton: UIButton!
                @IBOutlet weak var noBellButton: UIButton!
                @IBOutlet weak var descriptionView: UIView!
                @IBOutlet weak var descriptionLabel: UILabel!
                @IBOutlet weak var descriptionArrowImageView: UIImageView!
                
                @IBOutlet weak var prepaidCheckBoxButton: UIButton!
                @IBOutlet weak var postpaidCheckBoxButton: UIButton!
                @IBOutlet weak var prepaidPriceLabel: UILabel!
                @IBOutlet weak var postpaidPriceLabel: UILabel!
                
                @IBOutlet weak var postpaidhidelabel: UILabel!
                
                @IBOutlet weak var prepaidshowbutton: UIButton!
                @IBOutlet weak var bothtextbutton: UIButton!
                @IBOutlet weak var everydayCheckBoxButton: UIButton?
                @IBOutlet weak var customizeCheckBoxButton: UIButton?
                @IBOutlet weak var alternateCheckBoxButton: UIButton?
                
                @IBOutlet weak var bothCheckBoxButton: UIButton?
                
                
                
                @IBOutlet weak var subscribeStartDateTextField: UITextField!
                @IBOutlet weak var dateIconWidthConstraint: NSLayoutConstraint!
                
                @IBOutlet weak var alternateDayValueButton: UIButton!
                @IBOutlet weak var alternateDownArrowButton: UIButton!
                
                @IBOutlet weak var startdatebutton: UIButton!
                @IBOutlet weak var plusQuantityButton: UIButton!
                @IBOutlet weak var minusQuantityButton: UIButton!
                @IBOutlet weak var quantityLabel: UILabel!
                
                @IBOutlet weak var weekDaysView: WeekDaysStackView!
                
                @IBOutlet weak var infoLabel: UILabel!
                
                @IBOutlet weak var nicetoHaveButton: UIButton!
                @IBOutlet weak var nicetohaveTextField: UITextField!
                @IBOutlet weak var notificationView: UIView!
                @IBOutlet weak var nicetohaveTextFIeldView: UIView!
                
                @IBOutlet weak var nicetoHaveTextFieldHeightConstraint: NSLayoutConstraint!
                @IBOutlet weak var weekDaysStackViewHeightConstraint: NSLayoutConstraint!
                @IBOutlet weak var seperatorviewforDate: UIView!
                var deliveryFrequency = 0
                var type : String!
                  let datePicker = UIDatePicker()
                
                var deliverdetailsforcustomizeCheckBoxButton : Int!
                fileprivate let formatter: DateFormatter = {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
                    return formatter
                }()
             
                var alternateDayValuesArray = ["Every 2nd Day", "Every 3rd Day", "Every 4th Day"]
                var alternateDayValuesArrayOffset : Int {
                    return 2
                }
                var  scheduleText : String?
                var priceDetailsString = ""
                var selectedProductDict: [String: Any]?
                var selectedProductPriceDict: [String: Any]?
                var subscriptionId = 0
                var productUnit : String!
                var rechargeAmount = 0.0
                var Unit : String!
                var totalPrice = 0.00
                 var selectedtype : String!
                var minimumQuantiy: Int {
             
                    if customizeCheckBoxButton != nil && (customizeCheckBoxButton?.isSelected)! {
                        return 0
                    } else {
                        return 1
                    }
                }
                
                var maximumQuantiy: Int {
                    return 9
                }
                
                var pendingDues = 0.0
                var walletBalance = 0.0
                
                var discount = 0.0
                var priceDetailsDict: [String: Any]?
                
               
                var datePickerMinimumDate = Date()
                
                var subscriptionView = true
                var subscriptionViewforSingleOrder = true
                
                
                override func viewDidLoad() {
                    super.viewDidLoad()
             
                    

                    showDatePicker()
                    
                    // Do any additional setup after loading the view.
                    setupView()
                    DispatchQueue.main.async {
                        self.getPendingDues()
                        if self.subscriptionView {
                            self.loadData()
                            self.loadSubscriptionDetailsData()
                        }
                        else if self.subscriptionViewforSingleOrder {
                            self.loadDataforSingleOrder()
                        }
                        
                    }
                    
                }
                
                func showDatePicker(){
                    //Formate Date
                    datePicker.datePickerMode = .date
                    
                    //ToolBar
                    let toolbar = UIToolbar();
                    toolbar.sizeToFit()
                    
                    
                    let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.bordered, target: self, action: "donedatePicker")
                    let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
                    let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.bordered, target: self, action: "cancelDatePicker")
                    toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
                    
                    subscribeStartDateTextField.inputAccessoryView = toolbar
                    subscribeStartDateTextField.inputView = datePicker
                 
                }
                
                func donedatePicker(){
                    
                    let formatter = DateFormatter()
                       setStartDate(date: datePicker.date)
                    formatter.dateFormat = "yyyy-MM-dd"
                    subscribeStartDateTextField.text = formatter.string(from: datePicker.date)
                    self.view.endEditing(true)
                }
                
                func cancelDatePicker(){
                    self.view.endEditing(true)
                }
           

                
            
                override func didReceiveMemoryWarning() {
                    super.didReceiveMemoryWarning()
                    // Dispose of any resources that can be recreated.
                }
                func textFieldShouldReturn(userText: UITextField!) -> Bool {
                   subscribeStartDateTextField .resignFirstResponder()
                    return true
                }
                
                @IBAction func postPaidAction(_ sender: Any) {
                    if subscriptionId > 0 {
                        
                        if prepaidCheckBoxButton.isSelected  {
                     
                          //  if subscriptionView {
                            if let priceDetailsDict = priceDetailsDict, let price = priceDetailsDict["prepaid_price"] as? Double {

                                
                                    if let value = Double(quantityLabel.text!) {
                                        
                                        totalPrice =  value * price
                                    }
                             //   }

                                
                                if totalPrice > abs(self.walletBalance) {
                                    
                                    if    selectedtype == "Postpaid" {
                                    self.rechargeAmount = totalPrice - abs(self.walletBalance) +  abs(self.pendingDues)
                                        if walletBalance <=  0 {
                                            showLowBalanceMessage()
                                        }
                                        else{
                                         showLowBalanceMessageforchanging()
                                        }
                                    return
                                        
                                  }
                                }
                            }
                        }
                     
                  
                        
                        
                        }
                    }
                
                
                
         

                func loadData() {
                    let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                    hud.label.text = "Please wait..."
                    
                    
                    if let productId = selectedProductDict?["product_id"] as? Int, let userId = UserManager.defaultManager.userDict?["user_id"] as? Int {
                        
                        if let productType = selectedProductDict?["subscription_type"]  as? String
                        {
                            if productType    ==  "Daily"
                            {
                                bothCheckBoxButton?.isHidden = true
                                bothtextbutton.isHidden = true
                            }
                        }
                        APIManager.defaultManager.getProductPrice(parameters: ["user_id": userId, "product_id": productId]) { (responseDict) in
                            
                            MBProgressHUD.hide(for: self.view, animated: true)
                            
                            if let responseDict = responseDict {
                                //check for status 000000 for success
                                if let status = responseDict["status"] as? String {
                                    
                                    if status == "000000" {
                                        //Succcess
                                        self.setupPriceDetails(responseDict: responseDict)
                                        self.loadSubscriptionDetailsData()
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
                }
                
                func loadDataforSingleOrder() {
                    
                    let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                    hud.label.text = "Please wait..."
                    
                    if let productId = selectedProductDict?["product_id"] as? Int, let userId = UserManager.defaultManager.userDict?["user_id"] as? Int {
                        
                        APIManager.defaultManager.getProductPrice(parameters: ["user_id": userId, "product_id": productId]) { (responseDict) in
                            
                            MBProgressHUD.hide(for: self.view, animated: true)
                            
                            if let responseDict = responseDict {
                                //check for status 000000 for success
                                
                                if let status = responseDict["status"] as? String {
                                    
                                    if status == "000000" {
                                        //Succcess
                                        self.setupPriceDetails(responseDict: responseDict)
                                        
                                        self.loadSubscriptionDetailsDataforSingelOrder()
                                        
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
                }
                
                func loadSubscriptionDetailsData() {
                    //get subscription details if product is subscribed
                    //          &&  selectedProductDict?["subscription"] as? String !=  "unsettled
                    if let stringValue = selectedProductDict?["subscription_id"] as? String, let value = Int(stringValue) {
                        subscriptionId = value
                        
                        
                        if subscriptionId > 0    {
                            
                            
                            let parameters = ["subscription_id": subscriptionId]
                            
                            APIManager.defaultManager.requestJSON(apiRouter: .getSubscriptionDetails(parameters)) { (responseDict) in
                                
                                MBProgressHUD.hide(for: self.view, animated: true)
                                
                                if let responseDict = responseDict {
                                    
                                    //check for status 000000 for success
                                    if let status = responseDict["status"] as? String {
                                        if status == "000000" {
                                            
                                            //Succcess
                                            if let value = responseDict["edit_subscription"] as? [String: Any] {
                                                if   let    deliveryfeq  = value["delivery_frequency"] as? String , let value = Int(deliveryfeq) {
                                                    
                                                    if  value == 1 || value == 2 || value == 3 {
                                                        //Already subscribed. Setup the edit view
                                                        
                                                        let menuButton = UIBarButtonItem(image: UIImage(named: "verticalmenu"), style: .plain, target: self, action: #selector(self.subscribeAction))
                                                        
                                                        self.navigationItem.rightBarButtonItem = menuButton
                                                    }
                                                    else  if  value  == 4 {
                                                        let menuButton = UIBarButtonItem(image: UIImage(named: "verticalmenu"), style: .plain, target: self, action: #selector(self.subscribeActionforSingelOrder))
                                                        
                                                        self.navigationItem.rightBarButtonItem = menuButton
                                                    }
                                                }
                                            }
                                            
                                        }
                                    }
                                }
                            }
                            
                        }
                        if subscriptionId > 0 {
                            
                            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                            hud.label.text = "Please wait..."
                            
                            let parameters = ["subscription_id": subscriptionId]
                            
                            APIManager.defaultManager.requestJSON(apiRouter: .getSubscriptionDetails(parameters)) { (responseDict) in
                                
                                MBProgressHUD.hide(for: self.view, animated: true)
                                
                                if let responseDict = responseDict {
                                    
                                    //check for status 000000 for success
                                    if let status = responseDict["status"] as? String {
                                        if status == "000000" {
                                            
                                            //Succcess
                                            if let value = responseDict["edit_subscription"] as? [String: Any] {
                                                self.setupViewForsubscription(responseDict: value)
                                            }
                                            
                                        }
                                    }
                                }
                                
                                self.getPendingDues()
                                
                            }
                        }
                        else {
                            
                            self.getPendingDues()
                        }
                        
                        
                    }
                    
                    
                }
                
                
                
                func loadSubscriptionDetailsDataforSingelOrder() {
                    //get subscription details if product is subscribed
                    
                    if let stringValue = selectedProductDict?["subscription_id"] as? String, let value = Int(stringValue) {
                        subscriptionId = value
                        
                        if subscriptionId > 0 {
                            //Already subscribed. Setup the edit view
                            
                            let menuButton = UIBarButtonItem(image: UIImage(named: "verticalmenu"), style: .plain, target: self, action: #selector(subscribeActionforSingelOrder))
                            
                            self.navigationItem.rightBarButtonItem = menuButton
                        }
                    }
                    
                    if subscriptionId > 0 {
                        
                        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                        hud.label.text = "Please wait..."
                        
                        let parameters = ["subscription_id": subscriptionId]
                        print(subscriptionId)
                        APIManager.defaultManager.requestJSON(apiRouter: .getSubscriptionDetails(parameters)) { (responseDict) in
                            
                            MBProgressHUD.hide(for: self.view, animated: true)
                            
                            if let responseDict = responseDict {
                                //check for status 000000 for success
                                if let status = responseDict["status"] as? String {
                                    if status == "000000" {
                                        //Succcess
                                        if let value = responseDict["edit_subscription"] as? [String: Any] {
                                            self.setupViewForsubscription(responseDict: value)
                                        }
                                        
                                    }
                                }
                            }
                            
                            self.getPendingDues()
                            
                        }
                    } else {
                        
                        self.getPendingDues()
                    }
                }
                
                
                
                private func setupView() {
                    
    //                NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
                    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    //
                    self.setTitleView()
                    
                    self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil) //needed for hiding back text on next controller
                    
                    if let productDict = selectedProductDict {
                        
                        if let imageUrlStr = productDict["product_image_url"] as? String {
                            
                            productImageView.sd_setShowActivityIndicatorView(true)
                            productImageView.sd_setIndicatorStyle(.gray)
                            productImageView.sd_setImage(with: URL(string: APIRouter.baseURLStringForResource + imageUrlStr), placeholderImage: UIImage.defaultImage(), options: .cacheMemoryOnly)
                            
                            DispatchQueue.main.async {
                                self.productImageView.layer.cornerRadius = self.productImageView.frame.size.width / 2
                            }
                        }
                        
                        if let productName = productDict["product_name"] as? String {
                            productNameLabel.text = productName
                        }
                        if let productmessage = productDict["product_description"] as? String {
                            productMessageLabel.text = productmessage
                        }
                        var   priceDetailsString1 = ""
                        if let priceDetails = productDict["product_price_list"] as? [[String: Any]] {
                            
                            if priceDetails.count > 0 {
                                
                                if let price = priceDetails[0]["mrp"] as? Double {
                                    //    priceDetailsString =  "\(price)"
                                    priceDetailsString =  "₹" + String(format: "%.2f", price)
                                }
                                if let quanity = priceDetails[0]["quantity"] as? Int, var unit = priceDetails[0]["unit"] as? String {
                                    if subscriptionView == true {
                                        Unit =  "\(quanity)\(unit)"
                                    }
                                    else if subscriptionViewforSingleOrder == true
                                    {
                                        Unit =  "\(quanity)\(unit)"
                                        
                                    }
                                    priceDetailsString1 = "\(priceDetailsString)/\(quanity) \(unit)"
                                }
                                
                                priceDetailsLabel.text =  priceDetailsString
                            }
                        }
                        
                    }
                    
                    if subscriptionView {
                        
                        let selectedImage = UIImage(named: "radiobuttonselected")?.withRenderingMode(.alwaysTemplate)
                        
                        prepaidCheckBoxButton.setImage(selectedImage, for: .selected)
                        postpaidCheckBoxButton.setImage(selectedImage, for: .selected)
                        everydayCheckBoxButton?.setImage(selectedImage, for: .selected)
                        customizeCheckBoxButton?.setImage(selectedImage, for: .selected)
                        alternateCheckBoxButton?.setImage(selectedImage, for: .selected)
                        bothCheckBoxButton?.setImage(selectedImage, for: .selected)
                        
                        let bellselectedImage = UIImage(named: "bellselicon")?.withRenderingMode(.alwaysTemplate)
                        let donotbellselectedImage = UIImage(named: "donotbellselicon")?.withRenderingMode(.alwaysTemplate)
                        yesBellButton.setImage(bellselectedImage, for: .selected)
                        noBellButton.setImage(donotbellselectedImage, for: .selected)
                        
                        alternateDownArrowButton.isHidden = true
                        alternateDayValueButton.isHidden = true
                        priceDetailsLabel.isHidden = true
                        weekDaysStackViewHeightConstraint.constant = 0
                        
                        weekDaysView.setUpView()
                        
                        alternateDayValueButton.tag = alternateDayValuesArrayOffset //every 2nd day => 2 , Every 3rd day =>3, Every 4th day => 4
                    }
                    else if  subscriptionViewforSingleOrder {
       
                        
                        let selectedImage = UIImage(named: "radiobuttonselected")?.withRenderingMode(.alwaysTemplate)
                        
                        postpaidCheckBoxButton.setImage(selectedImage, for: .selected)
                        prepaidCheckBoxButton.setImage(selectedImage, for: .selected)
                        priceDetailsLabel.isHidden = true
                        
                    }
                    
                    descriptionView.layer.borderWidth = 1
                    descriptionView.layer.borderColor = UIColor.gray.cgColor
                    descriptionView.isUserInteractionEnabled = true
                    descriptionLabel.contentMode = .top
                    
                    descriptionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(descriptionViewTapAction(sender:))))
                    
                    nicetohaveTextField.addDoneButtonOnKeyboard()
                    nicetohaveTextFIeldView.layer.borderWidth = 1
                    nicetohaveTextFIeldView.layer.borderColor = UIColor.darkGray.cgColor
                    
                }
                
                fileprivate func setupViewForsubscription(responseDict: [String: Any]) {
                    
                    if let value = responseDict["quantity"] as? Int {
                        quantityLabel.text = "\(value)"
                    }
                    
                    if let value = responseDict["subscription_type"] as? String {
                        if value == "Prepaid" {
                            selectedtype =  value
                            print(selectedtype)
                            prepaidCheckBoxButton.isSelected = true
                            postpaidCheckBoxButton.isSelected = false
                            
                        }
                        else {
                           selectedtype = value
                            
                            prepaidCheckBoxButton.isSelected = false
                            postpaidCheckBoxButton.isSelected = true
                        }
                    }
                    
                    
                    if let value = responseDict["start_date"] as? String, let dateString = formatter.date(from: value) {
                        setStartDate(date: dateString)
                        
                        subscribeStartDateTextField.isUserInteractionEnabled = false
                        subscribeStartDateTextField.textColor = UIColor.gray
                        seperatorviewforDate.backgroundColor = UIColor.gray
                    }
                    
                    if let value = responseDict["delivery_frequency"] as? String, let valueInt = Int(value) {
                        var sender: UIButton?
                        
                        if valueInt == DeliveryFrequency.everyday.rawValue {
                            sender = everydayCheckBoxButton
                            
                        }
                            
                        else   if valueInt == DeliveryFrequency.both.rawValue {
                            
                            sender = bothCheckBoxButton
                            
                        }
                            
                        else if valueInt == DeliveryFrequency.alternate.rawValue {
                            sender = alternateCheckBoxButton
                            
                            if let value = responseDict["alternate"] as? Int {
                                if (value - alternateDayValuesArrayOffset > 0) && (value - alternateDayValuesArrayOffset < alternateDayValuesArray.count) {
                                    
                                    alternateDayValueButton.setTitle(alternateDayValuesArray[value - alternateDayValuesArrayOffset], for: .normal)
                                    alternateDayValueButton.tag = value
                                    
                                }
                            }
                            
                        }
                        else if valueInt == DeliveryFrequency.custom.rawValue {
                            sender = customizeCheckBoxButton
                            
                            
                            weekDaysView.setUpSubscriptionData(subscriptionDict: responseDict)
                        }
                            
                        else if valueInt == DeliveryFrequency.both.rawValue {
                            
                            sender = customizeCheckBoxButton
                            
                        }
                        
                        
                        if let sender = sender {
                            if let quantity = responseDict["quantity"] as? Int {
                                sender.accessibilityValue = "\(quantity)"
                            }
                            self.deliverySchedueButtonAction(sender)
                        }
                    }
                    
                    var infoAvailable = false
                    if let promoStaus = responseDict["promo-status"] as? String {
                        
                        if promoStaus.lowercased() == "valid" {
                            
                            if let discount = responseDict["offer-amount"] as? Int, let expireDate = responseDict["expire_date"] as? String {
                                
                                if discount > 0 {
                                    self.discount = Double(discount)
                                    infoLabel.text = infoLabel.text! + "Promo code discount Rs \(discount)/- expire on \(expireDate)."
                                    infoLabel.isHidden = false
                                    infoAvailable = true
                                }
                            }
                        }
                    }
                    
                    if !infoAvailable {
                        infoLabel?.text = ""
                    }
                    
                    
                    if let nicetohaveRequest = responseDict["nice_to_have_req"] as? String {
                        
                        if nicetohaveRequest.count > 0 {
                            nicetohaveTextField.text = nicetohaveRequest
                            nicetoHaveTextFieldHeightConstraint.constant = 40
                            nicetoHaveButton.isSelected = true
                        }
                    }
                    
                    if let isRingBell = responseDict["is_ring_bell"] as? Bool {

                        if isRingBell {
                            noBellButton.isSelected = false
                            yesBellButton.isSelected = true
                        } else {
                            noBellButton?.isSelected = true
                            yesBellButton?.isSelected = false
                        }

                    }
                    
                    
                }
                
                fileprivate func setupPriceDetails(responseDict: [String: Any]) {
                    
                    var qunatity : Int!
                    if let price = responseDict["prepaid_price"] as? Double {
                        prepaidPriceLabel.text =   "₹ " + String(format: "%.2f", price)
                    }
                    
                    
                    if let price = responseDict["postpaid_price"] as? Double {
                        postpaidPriceLabel.text =  "₹ " + String(format: "%.2f", price)
                    }
                    
                    if let unit = responseDict["unit"] as? String , let price = responseDict["quantity"] as? Int {
                        prepaidPriceLabel.text = "\(prepaidPriceLabel.text!)/ \(price) \(unit)"
                        postpaidPriceLabel.text = "\(postpaidPriceLabel.text!)/ \(price) \(unit)"
                        
                        productUnit = unit
                    }
                    
                    
                    if let value = responseDict["default_subscription"] as? String {
                        if value == "Postpaid" {
                            prepaidCheckBoxButton.isSelected = false
                            postpaidCheckBoxButton.isSelected = true
                            
                        } else {
                            prepaidCheckBoxButton.isSelected = true
                            postpaidCheckBoxButton.isSelected = false
                        }
                    }
                    
                    if let value = responseDict["is_postpaid_disabled"] as? Int {
                        if value ==  1  {
                            prepaidCheckBoxButton.isEnabled = true
                            prepaidPriceLabel.isEnabled =  true
                            prepaidCheckBoxButton.isSelected = true
                            
                            
                            postpaidCheckBoxButton.isEnabled = false
                            postpaidCheckBoxButton.isSelected = false
                            postpaidPriceLabel.isEnabled =  false
                            postpaidhidelabel.isEnabled = false
                        }
                        
                        
                        
                    }

                    if let value = responseDict["is_start_date_editable"] as? Int {
                         if value ==  1   {
                            subscribeStartDateTextField.isUserInteractionEnabled = true
                            subscribeStartDateTextField.isSelected = true
                           subscribeStartDateTextField.textColor = UIColor.blue
                             seperatorviewforDate.backgroundColor = UIColor.blue
                        }
                        else {
                                 subscribeStartDateTextField.isUserInteractionEnabled = false
                                 subscribeStartDateTextField.isSelected = false
                                 subscribeStartDateTextField.textColor = UIColor.gray
                                seperatorviewforDate.backgroundColor =  UIColor.gray
                            
                        }
                        
                    }
                    
                    
                    if let startDateDays = responseDict["start_date"] as? Int {
                        
                        if let date = Date().getNextDate(byAdding: startDateDays) {
                            datePickerMinimumDate = date
                            setStartDate(date: date)
                        }
                    } else {
                        setStartDate(date: Date())
                    }
                    
                    priceDetailsDict = responseDict
                }
                
                
                // MARK: - Navigation
                
                // In a storyboard-based application, you will often want to do a little preparation before navigation
                override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                    // Get the new view controller using segue.destinationViewController.
                    // Pass the selected object to the new view controller.
                    
                    if let controller = segue.destination as? SubscriptionSummaryViewController {
                        
                        controller.subscriptionView = self.subscriptionView
                        
                        if self.subscriptionView {
                            prepareForSegueForSubscription(controller: controller)
                        } else {
                            prepareForSegueForSingleOrder(controller: controller)
                            
                        }
                    }
                }
                
                public func prepareForSegueForSubscription(controller: SubscriptionSummaryViewController) {
                    
                    if (customizeCheckBoxButton?.isSelected)! {
                        
                        guard validateMilkQuantity() else {
                            self.showAlert(message: "Please select valid milk quantity for atleast one day.")
                            return
                        }
                    }
                    
                    if prepaidCheckBoxButton.isSelected {
                        
                        if let priceDetailsDict = priceDetailsDict, let price = priceDetailsDict["prepaid_price"] as? Double {
                            
                            var totalPrice = 0.0
                            if everydayCheckBoxButton!.isSelected || alternateCheckBoxButton!.isSelected {
                                
                                if let value = Double(quantityLabel.text!) {
                                    
                                    totalPrice =  value * price
                                }
                            } else {
                                
                                let value = Double(self.getFirstDeliveryMilkQuantity())
                                totalPrice = value * price
                                
                            }
                            
                            if totalPrice > abs(self.walletBalance) {
                             
                                self.rechargeAmount = totalPrice - abs(self.walletBalance)
                                showLowBalanceMessage()
                                return
                   
                            }
                        }
                    }
                    
                    var productName: String = ""
                    if let name = selectedProductDict?["product_name"] as? String {
                        productName = name
                    }
                    
                    
                    let subscriptionType = prepaidCheckBoxButton.isSelected ? "Prepaid" : "Postpaid"
                    
                    var quanityText = ""
                    if (everydayCheckBoxButton?.isSelected)! || (alternateCheckBoxButton?.isSelected)!  {
                        
                        if let value = Int(quantityLabel.text!) {
                            quanityText = "\(value)"
                        }
                        if let priceDetails = selectedProductDict?["product_price_list"] as? [[String: Any]] {
                            if priceDetails.count > 0 {
                                if let unit = priceDetails[0]["unit"] as? String {
                                    quanityText = quanityText + " "
                                }
                            }
                        }
                        
                        scheduleText =  ((everydayCheckBoxButton?.isSelected)! ? "Everyday" : "Alternate" )
                    }
                        
                        
                        
                    else if (bothCheckBoxButton?.isSelected)! {
                        
                        if let value = Int(quantityLabel.text!) {
                            quanityText = "\(value)"
                        }
                        if let priceDetails = selectedProductDict?["product_price_list"] as? [[String: Any]] {
                            if priceDetails.count > 0 {
                                if let unit = priceDetails[0]["unit"] as? String {
                                    quanityText = quanityText + " "
                                }
                            }
                        }
                        
                        scheduleText = "Single Order "
                        
                    }
                    
                    
                    
                    var  priceD = ""
                    var price =  0.0
                    if let priceDetailsDict = priceDetailsDict {
                        let priceKey = prepaidCheckBoxButton.isSelected ? "prepaid_price" : "postpaid_price"
                        
                        if let value = priceDetailsDict[priceKey] as? Double {
                            price =  value - self.discount
                            priceD =  "₹ " + String(format: "%.2f", price)
                        }
                    }
                    
                    
                    
                    if (everydayCheckBoxButton?.isSelected)! {
                        deliveryFrequency = DeliveryFrequency.everyday.rawValue
                    }
                    else if (bothCheckBoxButton?.isSelected)! {
                        deliveryFrequency = DeliveryFrequency.both.rawValue
                        
                    }
                        
                    else if (alternateCheckBoxButton?.isSelected)! {
                        deliveryFrequency = DeliveryFrequency.alternate.rawValue
                    } else if (customizeCheckBoxButton?.isSelected)! {
                        deliveryFrequency = DeliveryFrequency.custom.rawValue
                        deliverdetailsforcustomizeCheckBoxButton = deliveryFrequency
                    }
                    
                    let ringBell = yesBellButton.isSelected ? 1 : 0
                   
                    if scheduleText == "Single Order "  {
                        type = "One Time"
                        deliveryFrequency = 3
                    }
                    else{
                        type = "Daily"
                    }
                    
                   
                    controller.productSubDetailsDict = ["productId": selectedProductDict?["product_id"] ?? 0, "productName": productName, "subscriptionType": subscriptionType, "quantity": Int(quantityLabel.text!) ?? 0, "quantityText": quanityText, "price":   priceD, "startDate": self.subscribeStartDateTextField.text!, "deliveryFrequency": deliveryFrequency, "alternateDaySelected": alternateDayValueButton.tag, "ringBell": ringBell, "subscriptionId": Int(subscriptionId), "productUnit": Unit, "nice_to_have_req": self.nicetohaveTextField.text! , "scheduleText" : scheduleText ?? "Customized", "type" : type ]
                    
                    if (customizeCheckBoxButton?.isSelected)! {
                        controller.productSubDetailsDict?.updateValue(self.weekDaysView.daysDict, forKey: "customDaysDict")
                    }
                
                }
                
                private func prepareForSegueForSingleOrder(controller: SubscriptionSummaryViewController) {
                    
                    var productName: String = ""
                    if let name = selectedProductDict?["product_name"] as? String {
                        productName = name
                    }
                    
                    
                    
                    var quanityText = ""
                    if let value = Int(quantityLabel.text!) {
                        quanityText = "\(value)"
                    }
                    
                    let price =  priceDetailsString
                    
                    
                    if prepaidCheckBoxButton.isSelected {
                        
                        if let priceDetailsDict = priceDetailsDict, let price = priceDetailsDict["prepaid_price"] as? Double {
                            
                            var totalPrice = 0.0
                            
                            
                            if let value = Double(quantityLabel.text!) {
                                
                                totalPrice = value * price
                            }
                            else {
                                
                                let value = Double(self.getFirstDeliveryMilkQuantity())
                                totalPrice = value * price
                                
                            }
                            
                            if totalPrice > abs(self.walletBalance) {
                                
                                self.rechargeAmount = totalPrice - abs(self.walletBalance)
                                
                                showLowBalanceMessage()
                                return
                            
                            }
                        }
                    }

                    
                    let subscriptionType = prepaidCheckBoxButton.isSelected ? "Prepaid" : "Postpaid"
                    if let priceDetails = selectedProductDict?["product_price_list"] as? [[String: Any]] {
                        if priceDetails.count > 0 {
                            if let unit = priceDetails[0]["unit"] as? String {
                                quanityText = quanityText + " " + unit
                            }
                        }
                    }

                  
                    controller.productSubDetailsDict = ["productId": selectedProductDict?["product_id"] ?? 0, "productName": productName, "subscriptionType": subscriptionType , "quantity": Int(quantityLabel.text!) ?? 0, "quantityText": quanityText, "price":  priceDetailsLabel.text  , "startDate": self.subscribeStartDateTextField.text!, "deliveryFrequency": 3, "alternateDaySelected": 0, "ringBell": 0, "subscriptionId": subscriptionId, "productUnit": Unit , "nice_to_have_req": self.nicetohaveTextField.text!, "scheduleText" : scheduleText]

                }
                
                private func validateMilkQuantity() -> Bool {
                    //validate the milk quanity
                    
                    let quantityValues =  self.weekDaysView.daysDict.values.filter { $0 > 0 }
                    
                    if quantityValues.count == 0 {
                        return false
                    }
                    
                    return true
                }
                
                
                public func getFirstDeliveryMilkQuantity() -> Int {
                    
                    let weedDaysArray = ["sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday"]
                    
                    var firstDeliveryQuantity = 0
                    
                    if let currentDay = Date().dayOfWeek(), var currentDayindex =  weedDaysArray.index(of: currentDay.lowercased()) {
                        
                        var endIndex: Int!
                        
                        currentDayindex = currentDayindex + 1
                        
                        if currentDayindex == weedDaysArray.count {
                            currentDayindex = 0
                        }
                        
                        if currentDayindex == 0 {
                            endIndex = weedDaysArray.count
                        } else {
                            endIndex = currentDayindex - 1
                        }
                        
                        repeat {
                            
                            if let quantity = self.weekDaysView.daysDict[weedDaysArray[currentDayindex]] {
                                
                                if quantity > 0 {
                                    
                                    firstDeliveryQuantity = quantity
                                    break
                                } else {
                                    
                                    currentDayindex = currentDayindex + 1
                                    if currentDayindex == weedDaysArray.count {
                                        currentDayindex = 0
                                    }
                                }
                            }
                            
                        }
                            while currentDayindex != endIndex
                        
                    }
                    
                    
                    return firstDeliveryQuantity
                }
            }
            
            //MARK:- Action Methods
            extension SubscriptionViewController {
                
                @objc func descriptionViewTapAction(sender: UITapGestureRecognizer) {
                    
                    if descriptionLabel.text?.count == 0 {
                        //expand view
                        if let productDict = selectedProductDict, let description = productDict["prod_description"] as? String {
                            descriptionLabel.text = description
                        }
                        descriptionArrowImageView.isHighlighted = true
                    } else {
                        //collapse view
                        descriptionLabel.text = ""
                        descriptionArrowImageView.isHighlighted = false
                    }
                    
                    UIView.animate(withDuration: 0.2) {
                        self.view.layoutIfNeeded()
                    }
                }
                
                @IBAction func paymentPlanButtonAction(_ sender: UIButton) {
                    
                    if self.prepaidCheckBoxButton.isSelected {
                        
                        if let priceDetailsDict = self.priceDetailsDict, let price = priceDetailsDict["prepaid_price"] as? Double {
                            
                            
                            if let value = Double(self.quantityLabel.text!) {
                                
                                self.totalPrice =  value * price
                            }
                            
                        }
                    }
                    prepaidCheckBoxButton.isSelected = false
                    postpaidCheckBoxButton.isSelected = false
                    sender.isSelected = true
                    
                }
                
                @IBAction func deliverySchedueButtonAction(_ sender: UIButton) {
                    
                    everydayCheckBoxButton?.isSelected = false
                    customizeCheckBoxButton?.isSelected = false
                    alternateCheckBoxButton?.isSelected = false
                    bothCheckBoxButton?.isSelected = false
                    alternateDownArrowButton.isHidden = true
                    alternateDayValueButton.isHidden = true
                   // startdatebutton.isHidden = false
                    sender.isSelected = true
                    
                    if (customizeCheckBoxButton?.isSelected)! {
                        weekDaysStackViewHeightConstraint.constant = 90
                        setQuantityLabelValue()
                    }
                  else {
                        
                        if let quantity = sender.accessibilityValue {
                            quantityLabel.text = quantity
                            sender.accessibilityValue = nil
                        } else {
                            quantityLabel.text = "1"
                        }
                        
                        weekDaysStackViewHeightConstraint.constant = 0
                        
                        if (alternateCheckBoxButton?.isSelected)! {
                            alternateDownArrowButton.isHidden = false
                            alternateDayValueButton.isHidden = false
                            
                        }
                        if (bothCheckBoxButton?.isSelected)! {
                            
                           subscribeStartDateTextField.isUserInteractionEnabled = false
                             subscribeStartDateTextField.isSelected = false
                            subscribeStartDateTextField.textColor = UIColor.gray
                            seperatorviewforDate.backgroundColor = UIColor.gray
                         //    startdatebutton.isHidden = true
                        }
                           
            
                        else {
                            if subscriptionId < 0 {
                           subscribeStartDateTextField.isUserInteractionEnabled = true
                            subscribeStartDateTextField.isSelected = true
                            subscribeStartDateTextField.textColor = UIColor.blue
                            seperatorviewforDate.backgroundColor = UIColor.blue
                            //    startdatebutton.isHidden = true
                         }
                        }
                        
                    }
                    
                    UIView.animate(withDuration: 0.2) {
                        self.view.layoutIfNeeded()
                    }
                }
                
                

                
                @IBAction func dayButtonAction(_ sender: UIButton) {
                    
                    if let dayView = sender.superview as? DayView {
                        weekDaysView.selectedDayView = dayView
                        setQuantityLabelValue()
                    }
                }
                
                @IBAction func showAlternateDayPopover(_ sender: UIButton) {
                    
                    let popOverViewController = PopOverViewController(nibName: "PopOverViewController", bundle: nil)
                    popOverViewController.delegate = self
                    
                    popOverViewController.dataArray = alternateDayValuesArray
                    popOverViewController.permittedArrowDirections = .right
                    popOverViewController.preferredContentSize =  CGSize(width: 160, height: 150)
                    
                    popOverViewController.presentPopover(alternateDownArrowButton as UIView, fromController: self)
                    
                }
                
                
                @IBAction func changeQuanityButtonAction(_ sender: UIButton) {
                    
                    if var quantity = Int(quantityLabel.text!) {
                        
                        if sender == plusQuantityButton {
                            quantity = quantity + 1
                        } else {
                            quantity = quantity - 1
                        }
                        
                        if quantity >= minimumQuantiy && quantity <= maximumQuantiy {
                            quantityLabel.text = "\(quantity)"
                            
                            if customizeCheckBoxButton != nil && (customizeCheckBoxButton?.isSelected)! {
                                weekDaysView.selectedQuantity = quantity
                            }
                        }
                        
                    }
                }
                
                @IBAction func bellButtonAction(_ sender: UIButton) {
                    
                    noBellButton.isSelected = false
                    yesBellButton.isSelected = false
                    
                    sender.isSelected = true
                }
                
                
                func subscribeAction(_ sender: UIBarButtonItem) {
                    
                    let popOverViewController = PopOverViewController(nibName: "PopOverViewController", bundle: nil)
                    popOverViewController.delegate = self
                    popOverViewController.view.tag = 1
                    popOverViewController.customBackgroundColor = UIColor.extraDarkGray
                    popOverViewController.customTextColor = UIColor.white
                    
                    popOverViewController.dataArray = ["UNSUBSCRIBE"]
                    
                    popOverViewController.permittedArrowDirections = .right
                    popOverViewController.preferredContentSize =  CGSize(width: 150, height: 44)
                    
                    popOverViewController.presentPopoverFromBarButton(sender, fromController: self)
                }
                
                func subscribeActionforSingelOrder(_ sender: UIBarButtonItem){
                    let popOverViewController = PopOverViewController(nibName: "PopOverViewController", bundle: nil)
                    popOverViewController.delegate = self
                    popOverViewController.view.tag = 1
                    popOverViewController.customBackgroundColor = UIColor.extraDarkGray
                    popOverViewController.customTextColor = UIColor.white
                    
                    popOverViewController.dataArray = ["CANCEL ORDER"]
                    popOverViewController.permittedArrowDirections = .right
                    popOverViewController.preferredContentSize =  CGSize(width: 150, height: 44)
                    
                    popOverViewController.presentPopoverFromBarButton(sender, fromController: self)
                }
                
                @IBAction func nicetoHaveButtonAction(_ sender: UIButton) {
                    
                    sender.isSelected = !sender.isSelected
                    
                    if sender.isSelected {
                        nicetoHaveTextFieldHeightConstraint.constant = 40
                    } else {
                        nicetoHaveTextFieldHeightConstraint.constant = 0
                    }
                    
                    UIView.animate(withDuration: 0.2) {
                        self.view.layoutIfNeeded()
                    }
                }
                
            }
            
            //MARK:- PopOver Methods
            extension SubscriptionViewController: PopOverViewControllerDelegate {
                
                func selectedValue(_ value: String, index: Int, popOverViewController: PopOverViewController) {
                    
                    if popOverViewController.view.tag == 1 {
                        if value == "UNSUBSCRIBE"   {
                            if let controller = UIStoryboard(name: "Subscription", bundle: nil).instantiateViewController(withIdentifier: "UnsubscribeViewController") as? UnsubscribeViewController {
                                controller.subscriptionId = self.subscriptionId
                                controller.productId = self.selectedProductDict?["product_id"] as? Int
                                self.navigationController?.pushViewController(controller, animated: true)
                            }
                        }
                        else if  value  == "CANCEL ORDER" {
                            
                            if let controller = UIStoryboard(name: "Subscription", bundle: nil).instantiateViewController(withIdentifier: "UnsubscribrforSingelOrderViewController")  as? UnsubscribrforSingelOrderViewController{
                                controller.subscriptionId = self.subscriptionId
                                controller.productId = self.selectedProductDict?["product_id"] as? Int
                                self.navigationController?.pushViewController(controller, animated: true)
                            }
                        }
                    }
                    else {
                        
                        alternateDayValueButton.setTitle(value, for: .normal)
                        alternateDayValueButton.tag = index + alternateDayValuesArrayOffset //every 2nd day => 2 , Every 3rd day =>3, Every 4th day => 4
                        
                    }
                    
                }
            }
            
            
            //MARK:- Helper Methods
            extension SubscriptionViewController {
                
                fileprivate func setQuantityLabelValue() {
                    
                    if let day = weekDaysView.selectedDayView?.accessibilityValue, let quantity =  weekDaysView.daysDict[day] {
                        quantityLabel.text = "\(quantity)"
                    }
                }
                
                fileprivate func setStartDate(date: Date) {
                    
                    
                    subscribeStartDateTextField.text = formatter.string(from: date)
                    
                }
                

                
            }
            
            //MARK:- UIPopoverPresentationControllerDelegate
            extension SubscriptionViewController: UIPopoverPresentationControllerDelegate {
                
                func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
                    return .none
                }
            }
            
            
            //MARK:- Keyboard observers
           extension SubscriptionViewController {
    
    //
                func keyboardWillHide(_ notification: NSNotification) {

                    let userInfo = notification.userInfo ?? [:]
                    let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0

                    scrollView.contentInset.bottom = 0
                    UIView.animate(withDuration: duration, animations: {

                        self.view.layoutIfNeeded()
                    })

                }
              }
            
            
            //MARK:- API Methods
            extension SubscriptionViewController {
                
                fileprivate func getPendingDues() {
                    
                    if let userId = UserManager.defaultManager.userDict?["user_id"] as? Int {
                        
                        //   let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                        //    hud.label.text = "Please wait..."
                        
                        APIManager.defaultManager.requestJSON(apiRouter: .getAccountDetails(["user_id": userId])) { (responseDict) in
                            
                            // MBProgressHUD.hide(for: self.view, animated: true)
                            
                            if let responseDict = responseDict {
                                //check for status 000000 for success
                                
                                if let status = responseDict["status"] as? String {
                                    
                                    if status == "000000" {
                                        //Succcess
                                        if let amount = responseDict["pending_amount"] as? Double {
                                            //     let totalamount =   amount +  Double ((quantityLabel) * (prepaidPriceLabel))
                                            if amount <=   0.0 {
                                                self.walletBalance = amount
                                                // self.pendingDues =  amount
                                            }
                                            else {
                                                
                                                self.pendingDues =  amount
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            extension SubscriptionViewController {
                func showLowBalanceMessage() {
                    
                    
                    let alertController = UIAlertController(title: "😞 Oops! Please recharge your wallet with amount of least one day order for  prepaid subscription" , message: nil , preferredStyle: .alert)
                    
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){ (action) in
                        self.prepaidCheckBoxButton.isSelected = false
                        self.postpaidCheckBoxButton.isSelected = true
                    }
                    
                    alertController.addAction(cancelAction)
                    
                    let rechargeAction = UIAlertAction(title: "Recharge", style: .default) { (action) in
                        self.showRechargeController()
                    }
                    alertController.addAction(rechargeAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                }
                
                func showLowBalanceMessageforchanging() {
                    
                    var  amouttoshow =   "₹" + String(format: "%.2f", rechargeAmount)
                    let alertController = UIAlertController(title: "😞 Sorry! You can't switch to prepaid because you have pending dues " +  " Please pay " + "\(amouttoshow)" + " before switching to prepaid mode. " , message:  nil , preferredStyle: .alert)
                    
                      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){ (action) in
                        self.prepaidCheckBoxButton.isSelected = false
                        self.postpaidCheckBoxButton.isSelected = true
                    }
                    
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                }
                
                
                func showRechargeController() {
                    
                    if let controller = UIStoryboard(name: "Payment", bundle: nil).instantiateViewController(withIdentifier: "pay_web_view") as? pay_web_view {
                        
                        
                        navigationController?.pushViewController(controller, animated: true)
                    }
                    
                }
            }
            
            extension Date {
                func dayOfWeek() -> String? {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "EEEE"
                    return dateFormatter.string(from: self).capitalized
                    // or use capitalized(with: locale) if you want
                }
            }
            
            
            

