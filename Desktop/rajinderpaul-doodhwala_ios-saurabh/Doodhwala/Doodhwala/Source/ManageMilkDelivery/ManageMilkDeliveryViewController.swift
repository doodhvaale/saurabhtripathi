 import AudioToolbox
class ManageMilkDeliveryViewController: InsufficientViewController {


    
    @IBOutlet var calendar: FSCalendar!
    //Data Properties
    var selectedProductDict: [String: Any]?
    var puaseSubListDict: [[String: Any]]?
    var subscriptionStartDate: Date?
    
    var subscriptionsList: [[String: String]]?
    
    
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setTitleView()
        // MenuViewController.addMenuButton(forController: self)
        calendar.allowsMultipleSelection = true
        calendar.swipeToChooseGesture.isEnabled = true
        calendar.today = nil
        loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func loadData() {
        
        if let stringValue = selectedProductDict?["subscription_id"] as? String, let subscriptionId = Int(stringValue) {
            
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.label.text = "Please wait..."
            //
            
            let parameters = ["subscription_id": subscriptionId]
            APIManager.defaultManager.requestJSON(apiRouter: .getSubscriptionDetails(parameters)) { (responseDict) in
                
                MBProgressHUD.hide(for: self.view, animated: true)
                
                if let responseDict = responseDict {
                    //check for status 000000 for success
                    if let status = responseDict["status"] as? String {
                        if status == "000000" {
                            //Succcess
                            
                            if let responseDict = responseDict["edit_subscription"] as? [String: Any], let startDate = responseDict["start_date"] as? String {
                                
                                self.subscriptionStartDate = self.formatter.date(from: startDate)
                                self.calendar.reloadData()
                            }
                        }
                    }
                }
                
                self.getSubscripionsListData()
                
            }
        } else {
            self.getSubscripionsListData()
        }
    }
    
    fileprivate func getSubscripionsListData() {
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = "Please wait..."
        
        let userId = UserManager.defaultManager.userDict?["user_id"] as? Int
        let productId = selectedProductDict?["product_id"] as? Int
        
        var startDate = ""
        var endDate = ""
        
        if let date = calendar.currentPage.getPreviousMonth(bySubtracting: -1) {
            startDate = formatter.string(from: date)
        }
        
        if let date = calendar.currentPage.getNextMonth(byAdding: 2) {
            endDate = formatter.string(from: date)
        }
        
        let parameters = ["user_id": userId, "product_id": productId, "start_date": startDate, "end_date": endDate] as [String : Any]
        
        APIManager.defaultManager.requestJSON(apiRouter: .getSubscriptionsList(parameters)) { (responseDict) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let status = responseDict?["status"] as? String {
                if status == "000000" {
                    //Succcess
                    self.puaseSubListDict = responseDict?["subscription_list"] as? [[String: Any]]
                    self.calendar.reloadData()
                    if let pauseDatesList = responseDict?["pause_list"] as? [[String: Any]] {
                        
                        for pausedate in pauseDatesList {
                            
                            if let dateString = pausedate["end_date"] as? String, let date =  self.formatter.date(from: dateString){
                                
                                self.calendar.select(date, scrollToDate: false)
                            }
                            
                        }
                    }
                    
                    
                }
            }
            
        }
    }
    
    
}

// MARK:- FSCalendarDataSource
extension ManageMilkDeliveryViewController: FSCalendarDataSource , FSCalendarDelegate {
    
    
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        
        if let date = calendar.currentPage.getPreviousMonth(bySubtracting: -1) {
            return date
        }
        
        return calendar.currentPage
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        
        if let date = calendar.currentPage.getNextMonth(byAdding: 2) {
            return date
        }
        
        return Date()
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        var value = 0

        
        if let subDates = self.puaseSubListDict {
            
            for dict in subDates {
                if let startDateStr = dict["start_date"] as?  String , let startDate  = self.formatter.date(from: startDateStr)
                    
                {
                    
                    
                    if   (startDate.compare(date) == .orderedSame ) {
                        
                        
                        value = 1
                        return 1
                        break
                    }
                    
                }
            }
        }
        
        
        
        
        print(value)
        return value
    }
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        
        if (Date().compare(date) == .orderedDescending) || (Date().compare(date) == .orderedSame) {
            return false
        }
        
        return pauseResumeMilkSupply(date: date)
    }
    
    
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        
        if (Date().compare(date) == .orderedDescending) || (Date().compare(date) == .orderedSame) {
            return false
        }
        return pauseResumeMilkSupply(date: date)
    }
    
    func calendar(_ calendar: FSCalendar, longPressOn date: Date, at monthPosition: FSCalendarMonthPosition) {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        getSubsctionDetailsOndate(date: date)
    }
    
    private func  pauseResumeMilkSupply(date: Date) -> Bool {
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = "Please wait..."
        
        let userId = UserManager.defaultManager.userDict?["user_id"] as? Int
        
        let parameters = ["user_id": userId, "login_id": userId, "start_date": formatter.string(from: date), "end_date": formatter.string(from: date)] as [String : Any]
        
        APIManager.defaultManager.requestJSON(apiRouter: .pauseMilkSupply(parameters)) { (responseDict) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if let responseDict = responseDict {
                //check for status 000000 for success
                if let status = responseDict["status"] as? String {
                    
                    if status == "000000" {
                        self.calendar.select(date)
                    } else if status == "000005" {
                        self.calendar.deselect(date)
                    }
                    
                    if let message = responseDict["msg"] as? String {
                        self.showAlert(message: message)
                    }
                }
            }
        }
        
        return false
    }
    
    private func  getSubsctionDetailsOndate(date: Date) {

        let userId = UserManager.defaultManager.userDict?["user_id"] as? Int
        
        let parameters = ["user_id": userId,  "start_date": formatter.string(from: date)] as [String : Any]
        
        APIManager.defaultManager.requestJSON(apiRouter: .getSubscriptionDetailsForEditOnDate(parameters)) { (responseDict) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if let responseDict = responseDict {
                //check for status 000000 for success
                if let status = responseDict["status"] as? String {
                    
                    if status == "000000" {
                        
                        if let subscriptionsList =  responseDict["subscription_list"] as? [[String: Any]] {
                            
                            
                            var lastSubscription:[String: Any]?
                            if subscriptionsList.count > 0 {
                                var showMsgOnNoSubscriptionFound = true
                                self.showChangeQuantityViewFor(productDict: subscriptionsList  ,date: date)
                            }
                        }
                    } else  if let message = responseDict["msg"] as? String {
                        self.showAlert(message: message)
                    }
                }
            }
        }
        
    }
    
}


//Edit Subscription methods
extension ManageMilkDeliveryViewController {
    
    func showChangeQuantityViewFor(productDict: [[String: Any]]?, date: Date) {
        
        if let controller = getEditSubscribeController() {
            
            controller.editForDate = date
            controller.productDict = productDict
            
            
            
            //controller.disableView = true
            
            
            if (Date().compare(date) == .orderedDescending) || (Date().compare(date) == .orderedSame) {
                controller.disableView = true
            }
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    
    
    
    private func getEditSubscribeController() -> editSubscriptiontabelViewController? {
        
        if let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "edit") as? editSubscriptiontabelViewController {
            
            // controller.delegate = self//need to change to protocl
            controller.modalPresentationStyle = .custom
            controller.transitioningDelegate = self
            controller.modalTransitionStyle = .crossDissolve
            
            return controller
        }
        
        return nil
    }
    
}


//MARK:- UIViewControllerTransitioningDelegate
extension ManageMilkDeliveryViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        let customPresentationController = CustomSizePresentationController(presentedViewController: presented, presenting: presenting)
        
        if let controller = presented as? editSubscriptiontabelViewController {
            
            var height: CGFloat = 345
            
            
            customPresentationController.presentedControllerSize = CGRect(x: 20, y: self.view.center.y - (height/2 + 44), width: self.view.frame.size.width - 40, height: height)
        }
        
        return customPresentationController
    }
}


