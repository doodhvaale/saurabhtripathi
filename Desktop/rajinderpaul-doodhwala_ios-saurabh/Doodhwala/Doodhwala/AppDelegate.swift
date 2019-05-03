//
//  AppDelegate.swift
//  Doodhwala
//
//  Created by admin on 8/18/17.
//  Copyright © 2017 appzpixel. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
//import UserNotifications
//import Firebase
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let locationManager = CLLocationManager()
    var changeQuantityLabel : String =  " "
    
    var changeView : Bool?
    var token :String?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
     
        GMSServices.provideAPIKey("AIzaSyDMRaI7vop722DyF3LA584z5v7HsI3WJDA")
        GMSPlacesClient.provideAPIKey("AIzaSyDMRaI7vop722DyF3LA584z5v7HsI3WJDA")
        
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.delegate = self
     //   registerForPushNotifications()
        
       // FirebaseApp.configure()
        
        
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    
//    func application(
//        _ application: UIApplication,
//        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
//        ) {
//        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
//       token = tokenParts.joined()
//        print("Device Token: \(token)")
//    }
//
//    func application(
//        _ application: UIApplication,
//        didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        print("Failed to register: \(error)")
//    }
//
    
    
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    ////notification
    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
//    {
//        completionHandler([.alert, .badge, .sound])
//    }
//    func registerForPushNotifications() {
//        UNUserNotificationCenter.current() // 1
//
//            .requestAuthorization(options: [.alert, .sound, .badge]) {
//                [weak self] granted, error in
//
//                print("Permission granted: \(granted)")
//                guard granted else { return }
//                self?.getNotificationSettings()
//        }
//    }
//
//    func getNotificationSettings() {
//        UNUserNotificationCenter.current().getNotificationSettings { settings in
//            print("Notification settings: \(settings)")
//            guard settings.authorizationStatus == .authorized else { return }
//            DispatchQueue.main.async {
//                UIApplication.shared.registerForRemoteNotifications()
//            }
//        }
//    }
//
    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: ()) {
//        let userInfo = response.notification.request.content.userInfo
//        let title = response.notification.request.content.title
//        switch response.notification.request.content.categoryIdentifier
//        {
//        case "Second":
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificatioViewController"), object: title, userInfo: userInfo)
//            break
//        
//        default:
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificatioViewController"), object: title, userInfo: userInfo)
//            break
//        }
//        completionHandler
//    }
//    
    
    
    ///////////////////////////
    
    
    
    
}

extension AppDelegate: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "LocationAuthorizationStatus")))
    }
    
    
}

