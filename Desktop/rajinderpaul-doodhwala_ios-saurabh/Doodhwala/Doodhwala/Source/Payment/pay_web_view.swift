//
//  pay_web_view.swift
//  Doodhvale
//
//  Created by localadmin on 2/21/19.
//  Copyright © 2019 appzpixel. All rights reserved.
//

import UIKit
import WebKit
class pay_web_view: UIViewController {
    var indexforzeo : Int? = nil
    var urlpath : String = ""
    var  moreoptionarrayattop: [String]  = [ " " ]  // 3 button item at top i.e collect request , bottle collection
    let popOverViewController = PopOverViewController(nibName: "PopOverViewController", bundle: nil)
    
    
    var  url1: String = ""

    
    fileprivate func collectBottles() {
        
        if let userId = UserManager.defaultManager.userDict?["user_id"] as? Int {
            
            APIManager.defaultManager.requestJSON(apiRouter: .collectBottles(["customer_id": userId])) { (responseDict) in
                
                MBProgressHUD.hide(for: self.view, animated: true)
                
                if let responseDict = responseDict {
                    //check for status 000000 for success
                    
                    if let status = responseDict["status"] as? String {
                        
                        if status == "000000" {
                            //Succcess
                            
                            if var bottleDetails = responseDict["bottle_details"] as? [String: Any] {
                                
                                if let pendingBottles = bottleDetails["pending_bottle"] as? Int {
                                    
                                    if pendingBottles > 0 {
                                        
                                        self.popOverViewController.preferredContentSize =  CGSize(width: 250, height: 150)
                                        
                                        self.moreoptionarrayattop = ["Account Statement" , "Request for Cash Collection"," Collect empty bottle"]
                                        
                                    }
                                    else{
                                        self.moreoptionarrayattop = ["Account Statement" , "Request for Cash Collection"]
                                        self.popOverViewController.preferredContentSize =  CGSize(width: 250, height: 100)
                                        
                                    }
                                }
                                
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    
    
    @IBOutlet weak var webview: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectBottles()
        payment()


        setupView()
        self.navigationItem.hidesBackButton = true
     

        webview.navigationDelegate = self
        
        let myURL = URL(string: "https://")
        let myRequest = URLRequest(url: myURL!)
        webview.load(myRequest)
        webview.allowsBackForwardNavigationGestures = false
        self.loadSubscriptionDetailsData()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Strat to load")
        
        if let url = webView.url?.absoluteString{
            print("url = \(url)")
        }
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish to load")
        
        if let url = webView.url?.absoluteString{
            url1 = url
            print("url = \(url)")
        }
    }
    
  func back(_ sender: UIBarButtonItem){
        if(webview.canGoBack) {
            
            
         
            
                     if url1 == "https://v.doodhvale.in/#/a/pp?1ffr"
                    {
                        self.navigationController!.popViewController(animated:true)
                    }
                        
                 else if url1 ==       "https://t.doodhvale.in/#/a/pp?1ffr" {
                   self.navigationController!.popViewController(animated:true)
                   }
                    else{
                        DispatchQueue.main.async(execute: {
                            let message = "Do you want to cancel this transaction?  "
                            
                            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                            
                            let yesAction = UIAlertAction(title: "YES", style: .default) { (action) in
                              self.webview.goBack()
                            }
                        
                            let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)
                            
                            alertController.addAction(cancelAction)
                            alertController.addAction(yesAction)
                            
                            self.present(alertController, animated: true, completion: nil)
                            
                        })
                        
                  
                    }
                }

    else {
            self.navigationController!.popViewController(animated:true)
        }
    }

    private func setupView() {
        
    self.setTitleView()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    func loadSubscriptionDetailsData() {
        //get subscription details if product is subscribed
        //Already subscribed. Setup the edit view
        
        let menuButton = UIBarButtonItem(image: UIImage(named: "verticalmenu"), style: .plain, target: self, action: #selector(subscribeAction))
        
        self.navigationItem.rightBarButtonItem = menuButton
        
        let menuButton1 = UIBarButtonItem(image: UIImage(named: "Back"), style: .plain, target: self, action: #selector(back))
        
        self.navigationItem.leftBarButtonItem = menuButton1
        
    }
    
    
    
    fileprivate func showMessage(requestType: String) {
        DispatchQueue.main.async(execute: {
            let message = "Do you want to request for " + requestType + "?"
            
            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            
            let yesAction = UIAlertAction(title: "YES", style: .default) { (action) in
                
                self.sendEmailRequest(requestType: requestType)
            }
            
            let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)
            
            alertController.addAction(cancelAction)
            alertController.addAction(yesAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        })
    }
    fileprivate func sendEmailRequest(requestType: String) {
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = "Please wait..."
        
        let userId = UserManager.defaultManager.userDict?["user_id"] as? Int
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.string(from: Date())
        
        let parameters = ["user_id": userId, "collection_type": requestType, "date": date] as [String : Any]
        
        APIManager.defaultManager.requestJSON(apiRouter: .emailRequest(parameters)) { (responseDict) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if let responseDict = responseDict {
                //check for status 000000 for succes, 000001 for failure
                if let status = responseDict["status"] as? String {
                    
                    if status == "000000" {
                        //An OTP has been sent. Show the OTP View
                        if let message = responseDict["msg"] as? String {
                            self.showAlert(message: message)
                        }
                        
                    } else  {
                        //Failure handle errors
                        if let message = responseDict["msg"] as? String {
                            self.showAlert(message: message)
                        }
                    }
                }
                
            } else {
                print("Something went wrong. Please try again")
            }
        }
    }
    
    
}

extension pay_web_view {
    
    fileprivate func payment() {
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = "Please wait..."
        
        if let userId = UserManager.defaultManager.userDict?["user_id"] as? Int {
            
            APIManager.defaultManager.requestJSON(apiRouter: .getVuePaymentUrl("\(userId)")) { (responseDict) in
                
                MBProgressHUD.hide(for: self.view, animated: true)
                
                if let responseDict = responseDict {
                    //check for status 000000 for succes, 000001 for failure
                    if let status = responseDict["status"] as? String {
                        
                        if status == "000000" {
                            if let list = responseDict["payment_url"] as? String {
                                self.urlpath = list
                                let url = URL(string: self.urlpath)!
                                let urlRequest = URLRequest(url: url)
                                
                                self.webview.load(urlRequest)
                            }
                        } else if status == "000001" {
                            var message = "Something went wrong. Please try again."
                            if let value = responseDict["msg"] as? String {
                                message = value
                            }
                            self.showAlert(message: message)
                        }
                        
                    }
                    
                }
            }
        }
    }
}
extension pay_web_view: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
        
        let request = navigationAction.request
        
        if request.url?.host == "itunes.apple.com" {
            UIApplication.shared.open(request.url!, options: [:], completionHandler: nil)
            decisionHandler(.allow)
        }
            
        else {
            decisionHandler(.allow)
            return
        }
        decisionHandler(.cancel)
        
    }
}
extension pay_web_view {
    
    func subscribeAction(_ sender: UIBarButtonItem) {
        
        //  let popOverViewController = PopOverViewController(nibName: "PopOverViewController", bundle: nil)
        
        popOverViewController.delegate = self
        popOverViewController.customBackgroundColor = UIColor.extraDarkGray
        popOverViewController.customTextColor = UIColor.white
        popOverViewController.dataArray = moreoptionarrayattop
        popOverViewController.permittedArrowDirections = .right
        //        popOverViewController.preferredContentSize =  CGSize(width: 200, height: 150)
        
        
        popOverViewController.presentPopoverFromBarButton(sender, fromController: self)
        
    }
}
extension pay_web_view: PopOverViewControllerDelegate {
    
    func selectedValue(_ value: String, index: Int, popOverViewController: PopOverViewController) {
        
        
        
        if index == 0 {
            
            if let controller = UIStoryboard(name: "Payment", bundle: nil).instantiateViewController(withIdentifier: "AccountHistoryViewController") as? AccountHistoryViewController {
                
                controller.canGoback = true
                
                self.navigationController?.pushViewController(controller, animated: true)
            }
            
        }
        
        if index == 1 {
            showMessage(requestType:  "Payment Collection")
            
        }
        
        if index == 2 {
            showMessage(requestType:  " bottle Collection")
        }
        
        
    }
}



