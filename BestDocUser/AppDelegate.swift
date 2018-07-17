//
//  AppDelegate.swift
//  BestDocUser
//
//  Created by nitheesh.u on 10/01/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import Firebase
import FirebaseInstanceID
import RNNotificationView
//import FirebaseMessaging
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate,MessagingDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
//        Messaging.messaging()
//            .setAPNSToken(deviceToken, type: MessagingAPNSTokenType.unknown)
//        UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
//
//            if granted {
//               DispatchQueue.main.async(execute: {
//                UIApplication.shared.registerForRemoteNotifications()
//            })
//        }
//
//        }
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
            // For iOS 10 data message (sent via FCM
            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        if let remoteNotification = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] {
            self.application(application, didReceiveRemoteNotification: remoteNotification as! [AnyHashable : Any])
            print(remoteNotification)
        }
        
          IQKeyboardManager.shared.enable = true
        
        // Override point for customization after application launch.
        return true
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("hai")
        print(userInfo)
        let userInfo:NSDictionary = userInfo as NSDictionary
        print(userInfo)
        let dict:NSDictionary = userInfo["aps"] as! NSDictionary
        let data:NSDictionary = userInfo
        let statusData = userInfo["status"]as! String
        var doctorNAme = String()
        let bookingDate = String()
        let timeSlote = String()
        let loctionName = String()
        let address = String()
         var msg = String()
        var tittle = String()
        var msgOne = String()
        var msg2 = msgOne + doctorNAme + " for" + bookingDate + "," + timeSlote + " at "
            + loctionName
            + ", "
            + address
            + msg
       
        RNNotificationView.show(withImage: UIImage(named: "logo"),
                                title: tittle,
                                message: msg2,
                                duration: 2,
                                onTap: {
                                    switch statusData {
                                        
                                    case "2": //Numbers 90-99  Use 90...100 to 90-100
                                        msgOne = "Your appointment with "
                                       tittle =   "Appointment Initiated"
                                        if let dataOne =   data["doctor_name"]{
                                            doctorNAme = dataOne as! String
                                        }
                                        if let dataOne =   data["booking_date"]{
                                            doctorNAme = dataOne as! String
                                        }
                                        if let dataOne =   data["timeslot"]{
                                            doctorNAme = dataOne as! String
                                        }
                                        if let dataOne =   data["location_name"]{
                                            doctorNAme = dataOne as! String
                                        }
                                        if let dataOne =   data["address"]{
                                            doctorNAme = dataOne as! String
                                        }
                                        msg = " has been INITIATED"
                                    
                                    case "5":
                                        msgOne = "Your appointment with "//Numbers 90-99  Use 90...100 to 90-100
                                        tittle =   "Appointment Cancelled"
                                        if let dataOne =   data["doctor_name"]{
                                            doctorNAme = dataOne as! String
                                        }
                                        if let dataOne =   data["booking_date"]{
                                            doctorNAme = dataOne as! String
                                        }
                                        if let dataOne =   data["timeslot"]{
                                            doctorNAme = dataOne as! String
                                        }
                                        if let dataOne =   data["location_name"]{
                                            doctorNAme = dataOne as! String
                                        }
                                        if let dataOne =   data["address"]{
                                            doctorNAme = dataOne as! String
                                        }
                                        msg =  " has been CANCELLED"
                                    case "1":
                                        msgOne = "Your appointment with "//Numbers 90-99  Use 90...100 to 90-100
                                        tittle =   "Appointment Confirmed"
                                        if let dataOne =   data["doctor_name"]{
                                            doctorNAme = dataOne as! String
                                        }
                                        if let dataOne =   data["booking_date"]{
                                            doctorNAme = dataOne as! String
                                        }
                                        if let dataOne =   data["timeslot"]{
                                            doctorNAme = dataOne as! String
                                        }
                                        if let dataOne =   data["location_name"]{
                                            doctorNAme = dataOne as! String
                                        }
                                        if let dataOne =   data["address"]{
                                            doctorNAme = dataOne as! String
                                        }
                                        msg =  " has been CONFIRMED"
                                    case "10": //Numbers 90-99  Use 90...100 to 90-100
                                        //msgOne = "You have an appointment on tomorrow ("
                                        tittle =  "Appointment Remainder"
                                        var msgOneD = " at "
                                            + "\(data["location_name"]as! String)"
                                            + ", "
                                            + "\(data["address"]as! String)"
                                            + "."
                                        var msg2 =
                                            "\(data["timeslot"])"
                                                + " with "
                                                + "\(data["doctor_name"]as! String)"
                                                + msgOneD
                                            msgOne = "You have an appointment on tomorrow ("
                                            + "\(data["booking_date"])"
                                            + "), "+msg2
                                        
                                       // msg =  " has been CONFIRMED"
                                    case "11": //Numbers 90-99  Use 90...100 to 90-100
                                        tittle = "Appointment Remainder"
                                        var msgValue = " with "
                                            + "\(data["doctor_name"]as! String)"
                                            + " at "
                                            + "\(data["location_name"]as! String)"
                                            + ", "
                                            + "\(data["address"]as! String)"
                                            + "."
                                        msg2 = "You have an appointment Today ("
                                            +  "\(data["booking_date"])"
                                            + "), " + "\(data["timeslot"]as! String)"
                                            + msgValue
                                    case "12": //Numbers 90-99  Use 90...100 to 90-100
                                        tittle = "Appointment Delayed";
                                        msg2 = data["message"]as! String  + ""
                                        case "13": //Numbers 90-99  Use 90...100 to 90-100
                                            tittle = data["title"]as! String  + ""
                                            msg2 = data["message"]as! String  + ""
                                    default:
                                        print("F. You failed")//Any number less than 0 or greater than 99
                                        
                                    }
                                    
                                    print("Did tap notification")
        })
       // if application.applicationState == .active {
            if let aps = userInfo["data"] as? NSDictionary {
                if let alertMessage = aps["message"] as? String {
                    let alert = UIAlertController(title:aps["title"] as? String, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
                    let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alert.addAction(action)
                    self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                }
            }
     //   }
        completionHandler(.newData)
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("hello")
        print(notification)
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
         print("hellod")
        print(response)
    }
    
    // The method will be called on the delegate when the user responded to the notification by opening the application, dismissing the notification or choosing a UNNotificationAction.
    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: (){
//
//    }
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage)
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
        print("userInfo -- \(userInfo)")
        
    }
    func application(received remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print(deviceTokenString)
       
        if let refreshedToken = InstanceID.instanceID().token() {
             deviceTokenStringData = refreshedToken
            print("InstanceID token: \(refreshedToken)")
        }
    }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        if let refreshedToken = InstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
        }
    }
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print(fcmToken)
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

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
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "BestDocUser")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

