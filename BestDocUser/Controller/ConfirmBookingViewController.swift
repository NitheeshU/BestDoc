//
//  ConfirmBookingViewController.swift
//  BestDocUser
//
//  Created by nitheesh.u on 17/01/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//
import Foundation
import UIKit
//import PayU_coreSDK_Swift
class ConfirmBookingViewController: UIViewController,TrendingProductsCustomDelegate {
    var hashData = NSDictionary()
  //  let paymentParams = PayUModelPaymentParams()
   // let webService = PayUWebService()
    var boolForSalt = true
    //var paymentconfig =
  var amountDataString = String()
    //var utils : Utils = Utils()
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("PayUResponse"), object: nil)
    
        
        // to remove keyboard on touching anywhere on screen
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ConfirmBookingViewController.dismissKeyboard))
        
        //comment the line below if you want the tap to interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    func dataChanged(str: String) {
        amountDataString = str
        // Do whatever you need with the data
    }
    @objc override func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    override func viewWillAppear(_ animated: Bool) {
//        let trendingProductsPageForAnimation = storyboard!.instantiateViewController(withIdentifier: "BDConfirmationTableViewController") as! BDConfirmationTableViewController //You can understand this right. Same as yours.
//        trendingProductsPageForAnimation.customDelegateForDataReturn = self
//        print(amountDataString)
       //  paymentHash()
       
//        let genHashes = PUSAGenerateHashes()
//
//        genHashes.generateHashesFromServer(withPaymentParams: paymentParams) { (hashes, error) in
//
//
//            if (hashes.isEqual("") == false)
//            {
//                //self.activityIndicator.stopAnimating()
//                //self.activityIndicator.isHidden = true
//
//                self.paymentParams.hashes.paymentRelatedDetailsHash = hashes.paymentRelatedDetailsHash
//                self.paymentParams.hashes.deleteUserCardHash = hashes.deleteUserCardHash
//                self.paymentParams.hashes.offerHash  = hashes.offerHash
//                self.paymentParams.hashes.VASForMobileSDKHash = hashes.VASForMobileSDKHash
//                self.paymentParams.hashes.saveUserCardHash = hashes.saveUserCardHash
//
//                self.paymentParams.hashes.paymentHash = hashes.paymentHash
//
//            }
//            else
//            {
//                print(error)
//            }
//        }
    }
    func sendDataBackToHomePageViewController(categoryToRefresh: String?) { //Custom delegate function which was defined inside child class to get the data and do the other stuffs.
        if categoryToRefresh != nil {
            print("Got the data is \(categoryToRefresh)")
            amountDataString = categoryToRefresh!
        }
    }
    @objc func methodOfReceivedNotification(notification: Notification){
        //Take Action on Notification
        
//        print(notification)
//        
//        let alert = UIAlertController(title: "Response", message: "\(notification.object!)" , preferredStyle: UIAlertControllerStyle.alert)
//        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
//        
//        var merchantHash = String()
//        let strConvertedRespone = "\(notification.object!)"
//        
//        // var jsonResult  = try JSONSerialization.jsonObject(with: notification.object!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
//        
//        
//        let JSON : NSDictionary = try! JSONSerialization.jsonObject(with: strConvertedRespone.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
//        
//        if ((JSON.object(forKey: "status") as! String == "success"))
//        {
//            var cardToken = String()
//            print("The transaction is successful")
//            if (JSON.object(forKey: "cardToken")  != nil)
//            {
//                cardToken =  JSON.object(forKey: "cardToken") as! String
//                
//                if (JSON.object(forKey: "card_merchant_param") != nil)
//                {
//                    merchantHash = JSON.object(forKey: "card_merchant_param") as! String
//                    
//                }
//            }
//            
//            
//            let obj = PUSAGenerateHashes()
//            
//            obj.saveOneTapDataAtMerchantServer(Key: paymentParams.key!, withCardToken: cardToken, forUserCredentials: paymentParams.userCredentials!, withMerchantHash: merchantHash, withCompletionBlock: { (message, error) in
//                
//                
//                print(message)
//                
//            })
//        }
//        self.present(alert, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
   
    @IBAction func payByCash(_ sender: UIButton) {
        let alert = UIAlertController(title: "Confirm Booking", message: "You will be required to pay the consultation fee and other charges at the clinic/hospital.\n"+"\n In order to complete the booking process, make sure that you have read the terms and conditions.", preferredStyle: UIAlertControllerStyle.alert)
        let termAction = UIAlertAction(title: "Terms and conditions", style: .default, handler: { _ -> Void in
            guard let url = URL(string: "https://bestdocapp.com/termsandconditions.php") else {
                return //be safe
            }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
            
            
        })
        alert.addAction(termAction)
        let OKAction = UIAlertAction(title: "Book", style: .default, handler: { _ -> Void in
            if hmsIntegration == 1 && PaymentActive == 1&&hashpaymentContract == 1{
                self.hmspatientBooking()
            }else if hmsIntegration == 0{
                self.patientBooking()
            }
            //let storyBoard = UIStoryboard(name: "Main", bundle: nil)
           // self.patientDetails()
        
        })
        alert.addAction(OKAction)
        // add the actions (buttons)
        //alert.addAction(UIAlertAction(title: "Book", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    func hmspatientBooking()
    {
        var userReg:Any?
        if let response = logindictionary["response"]as? NSDictionary{
            if let data = response["login"]as? NSDictionary
            {
                userReg = (data["userreg_id"])
                print(patientRegId!)
                // patientRegId = (data["patreg_id"])
                //ownerId = (data["userreg_id"])//
                //  mobilenumber = (data["mobile_number"])
            }} else{
          //  patientRegId = UserDefaults.standard.object(forKey:"patientID") as! Int
            //userRegID = UserDefaults.standard.object(forKey:"userRegID") as! Int
            //  userReg = userRegID
            //patientRegId
        }
        
        var patientDic = NSDictionary()
        let para = ["book_detail_id":0,"locuser_id":locUserId!,"multi_booking":0,"section_slot":slotData,"os_type":2,"user_country_id":1,"userreg_id":docregid!,"bookuser_type_id":5,"booktime":date24,"booking_date":dateDetails,"bookstatus_typ_id":2,"txnId":0,"bookowner_userid":userReg!,"session_numbr":1,"appuser_type":5,"patreg_id":patientRegId!,"alternate_mobile":""] as [String : Any]
        print(para)
        //let para = ["stateId":1,"appuser_type":5]
        let progressHUD = ProgressHUD(text: "")
        self.view.addSubview(progressHUD)
        BDService.hmsbooking(params: para as [String : AnyObject]){(result, message, status ) in
            progressHUD.hide()
            print(message!)
            print(result!)
            if status {
                let serviceDetails = result as? BDService
                patientDic = (serviceDetails?.hmsBooking)!
                print(patientDic)
                if patientDic["status"]as! Int == 1
                {
                    if let res =  (patientDic["response"] as? NSDictionary)  {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BDSuccessViewController")as! BDSuccessViewController
                        vc.bookingID =  res["booking_id"]
                        self.present(vc, animated: true, completion: nil)
                    }
                }
                else if patientDic["status"]as! Int == 0 {
                    let dialogMessage = UIAlertController(title: (patientDic["error_msg"]as! String), message: "", preferredStyle: .alert)
                    
                    // Create OK button with action handler
                    let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                        let vc = self.storyboard?.instantiateViewController(withIdentifier:"ChoseFriendViewController")as! ChoseFriendViewController
                        choseFriends = true
                        self.present(vc, animated: true, completion: nil)
                        
                    })
                    
                    // Create Cancel button with action handlder
                    let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                        print("Cancel button click...")
                    }
                    
                    //Add OK and Cancel button to dialog message
                    dialogMessage.addAction(ok)
                    dialogMessage.addAction(cancel)
                    
                    // Present dialog message to user
                    self.present(dialogMessage, animated: true, completion: nil)
                    self.alert(alertmessage: patientDic["error_msg"]as! String)
                }
                
            }
        }
    }
//    func paymentHash()
//    {
//        let amountString = totalAmountData
//        print(amountString)
//        var userNameData:String?
//        var userIDDetail:Any?
//        var genderID = Int()
//        var mailID = String()
//        var resultDic = NSDictionary()
//        if let response = logindictionary["response"]as? NSDictionary{
//            if let data = response["login"]as? NSDictionary
//            {
//                userIDDetail = (data["userreg_id"])
//                userNameData = (data["first_name"] as! String)
//                mailID = data["email"] as! String
//                //ownerId = (data["userreg_id"])//print(data["patreg_id"]!)
//                //  mobilenumber = (data["mobile_number"])
//            }
//        }
//
//
//
//        let para = ["amount":"1","email":mailID,"firstName":userNameData!,"furl":"http://35.231.13.2:8080/dashboard_test/paymentsuccess","productInfo":"Booking","surl":"http://35.231.13.2:8080/dashboard_test/paymentsuccess","udf1":locUserId,"udf2":userRegID,"udf3":"","udf4":"","udf5":"","enableOneClickPayment":0,"storeCard":0] as [String : AnyObject]
//        print(para)
//        let progressHUD = ProgressHUD(text: "")
//        self.view.addSubview(progressHUD)
//        BDService.getHashCode(params: para as [String : AnyObject]){(response, message, status ) in
//            progressHUD.hide()
//            print(response!)
//            if status {
//                let serviceDetails = response as? BDService
//                resultDic = (serviceDetails!.hashcodedata)
//                print(resultDic)
//                if resultDic["status"]as! Int == 1
//                {
//                    if let responsedata = resultDic["response"]as? NSDictionary{
//                        self.hashData = responsedata
//                        print(responsedata)
//                        print((self.hashData["payment_key"]as! String))
//                        self.paymentParams.key = (self.hashData["payment_key"]as! String)
//                        self.paymentParams.txnId = (self.hashData["txn_id"]as! String)
//                        self.paymentParams.amount = "1"
//                        self.paymentParams.productInfo = "Booking"
//                        self.paymentParams.firstName = userNameData!
//                        self.paymentParams.email = mailID
//                        self.paymentParams.environment = ENVIRONMENT_TEST
//                        self.paymentParams.surl = "http://35.231.13.2:8080/dashboard_test/paymentsuccess"
//                        self.paymentParams.furl = "http://35.231.13.2:8080/dashboard_test/paymentsuccess"
//                       // paymentParams
//                        self.paymentParams.userCredentials = (self.hashData["user_key"]as! String)
//                        //self.paymentParams.c
//                    //    paymentParams.
//                        self.paymentParams.udf1 = "\(locUserId!)"
//                        self.paymentParams.udf2 = "\(userRegID!)"
//                        self.paymentParams.udf3 = ""
//                            //(self.hashData["additional_charge"]as! String)
//                        self.paymentParams.udf4 = ""
//                        self.paymentParams.udf5 = ""
//
//                        self.paymentParams.hashes.paymentRelatedDetailsHash = (self.hashData["payment_related_details_for_mobile_sdk_hash"]as! String)
//                        self.paymentParams.hashes.deleteUserCardHash =  (self.hashData["delete_user_card_hash"]as! String)
//                        //self.paymentParams.hashes.offerHash  = hashes.offerHash
//                        self.paymentParams.hashes.VASForMobileSDKHash =
//                            (self.hashData["vas_for_mobile_sdk_hash"]as! String)
//                        self.paymentParams.hashes.saveUserCardHash =
//                            (self.hashData["save_user_card_hash"]as! String)
//
//                        self.paymentParams.hashes.paymentHash = (self.hashData["payment_hash"]as! String)
//
//                        //self.paymentParams.udf2 = "7513"
//
//                       // self.paymentParams.phoneNumber = "9876543210"
//                        //offer key if some offer is enabled
//                       // self.paymentParams.offerKey = "Sample@7279"
//                        //self.
//                    }
//                }
//            }
//        }
//
//    }
    func patientBooking()
    {
        var userReg:Any?
        if let response = logindictionary["response"]as? NSDictionary{
            if let data = response["login"]as? NSDictionary
            {
                userReg = (data["userreg_id"])
                //patientRegId = (data["patreg_id"])
                //ownerId = (data["userreg_id"])//
                //  mobilenumber = (data["mobile_number"])
            }}
        var patientDic = NSDictionary()
        let para = ["book_detail_id":0,"locuser_id":locUserId!,"multi_booking":0,"section_slot":slotData,"os_type":2,"user_country_id":1,"userreg_id":docregid!,"bookuser_type_id":5,"booktime":date24,"booking_date":dateDetails,"bookstatus_typ_id":2,"txnId":0,"bookowner_userid":userReg!,"session_numbr":1,"appuser_type":5,"patreg_id":patientRegId!] as [String : Any]
        print(para)
        //let para = ["stateId":1,"appuser_type":5]
        let progressHUD = ProgressHUD(text: "")
        self.view.addSubview(progressHUD)
        BDService.booking(params: para as [String : AnyObject]){(result, message, status ) in
            progressHUD.hide()
            print(message!)
            print(result!)
            if status {
                let serviceDetails = result as? BDService
                patientDic = (serviceDetails?.patientBooking)!
                print(patientDic)
                if patientDic["status"]as! Int == 1
                {
                    if let res =  (patientDic["response"] as? NSDictionary)  {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BDSuccessViewController")as! BDSuccessViewController
                        vc.bookingID =  res["booking_id"]
                        self.present(vc, animated: true, completion: nil)
                    }
                }
                else if patientDic["status"]as! Int == 0 {
                    let dialogMessage = UIAlertController(title: (patientDic["error_msg"]as! String), message: "", preferredStyle: .alert)
                    
                    // Create OK button with action handler
                    let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                        let vc = self.storyboard?.instantiateViewController(withIdentifier:"ChoseFriendViewController")as! ChoseFriendViewController
                        choseFriends = true
                        self.present(vc, animated: true, completion: nil)
                        
                    })
                    
                    // Create Cancel button with action handlder
                    let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                        print("Cancel button click...")
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                    //Add OK and Cancel button to dialog message
                    dialogMessage.addAction(ok)
                    dialogMessage.addAction(cancel)
                    
                    // Present dialog message to user
                    self.present(dialogMessage, animated: true, completion: nil)
                   // self.alert(alertmessage: patientDic["error_msg"]as! String)
                }
                
            }
        }
    }
    func alert(alertmessage:String)
    {
        let alert = UIAlertController(title: alertmessage, message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
    }
    @IBAction func payOnline(_ sender: UIButton) {
       
        let alert = UIAlertController(title: "Confirm Booking", message: "In order to complete the booking process, make sure that you have read the terms and conditions. ", preferredStyle: UIAlertControllerStyle.alert)
        let OKAction = UIAlertAction(title: "Book", style: .default, handler: { _ -> Void in
          //  self.payu()
        })
        alert.addAction(OKAction)
        // add the actions (buttons)
        //alert.addAction(UIAlertAction(title: "Book", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
//func payu()
//{
//    var mailID = String()
//    if let response = logindictionary["response"]as? NSDictionary{
//        if let data = response["login"]as? NSDictionary
//        {
//
//            mailID = data["email"] as! String
//            //ownerId = (data["userreg_id"])//print(data["patreg_id"]!)
//            //  mobilenumber = (data["mobile_number"])
//        }
//    }
//    var updateUITempBool = false
//   // let progressHUD = ProgressHUD(text: "")
//   // self.view.addSubview(progressHUD)
//
//    //self.activityIndicator.isHidden = false
//   // self.activityIndicator.startAnimating()
//
//    // check for one tap
//
//
//   /// if (oneTapSwitch.isOn)
//    //{
//    //    self.paymentParams.isOneTap = true
//   // }
//  //  else
//  //  {
//   //     self.paymentParams.isOneTap = false
//   // }
//    // if some changes at text field input data
//    // setting params from text field to generate hashes accordingly or you can send above params directly
////    self.paymentParams.key = (self.hashData["payment_key"]as! String)
////    self.paymentParams.txnId = (self.hashData["txn_id"]as! String)
////    self.paymentParams.amount = "1"
////    self.paymentParams.productInfo = "Booking"
////    self.paymentParams.firstName = "Roy thomas"
////    self.paymentParams.email = mailID
////    self.paymentParams.environment = ENVIRONMENT_PRODUCTION
////    self.paymentParams.surl = "https://api.bestdocapp.com/dashboard/paymentsuccess"
////    self.paymentParams.furl = "https://api.bestdocapp.com/dashboard/paymentsuccess"
////    self.paymentParams.userCredentials = (self.hashData["user_key"]as! String)
////    self.paymentParams.udf1 = "223"
////    self.paymentParams.udf2 = "7513"
////    self.paymentParams.udf3 = ""
////    self.paymentParams.udf4 = ""
////    self.paymentParams.udf5 = ""
//    //self.paymentParams.udf1 = "223"
//   // self.paymentParams.udf2 = "7513"
//
//    // call function to generate hashes
//
//
//    // Please do not use this class as generating hash internally in SDK is risky & not recommanded, the app can be hacked as well, the below method should be used for testing purposes only
//      //  let genHashes = PUSAGenerateHashes()
//
//       //genHashes.generateHashesFromServer(withPaymentParams: paymentParams) { (hashes, error) in
//
//           // if (error == "")
//           // {
//             //  progressHUD.hide() //self.activityIndicator.stopAnimating()
//               // self.activityIndicator.isHidden = true
//
//
//
//                // check for activity indicator
//                //self.activityIndicator.isHidden = false
//
//               // self.activityIndicator.startAnimating()
//                let progressHUD = ProgressHUD(text: "")
//                self.view.addSubview(progressHUD)
//                //let webService = PayUWebService()
//
//                webService.callVAS(paymentParamsforVas: self.paymentParams)
//
//                // call PayU's fetchPaymentOptions method to get payment options available for your account
//
//                self.webService.fetchPayUPaymentOptions(paymentParamsToFetchPaymentOptions: self.paymentParams) { (array, errorHere) in
//
//                    DispatchQueue.main.async {
//                        // Update UI
//
//                        if (errorHere == "")
//                        {
//                            if (updateUITempBool == false)
//                            {
//                                updateUITempBool = true
//                                 progressHUD.hide()
//                               // self.activityIndicator.isHidden = true
//                               // self.activityIndicator.stopAnimating()
//                                let strBrd = UIStoryboard (name: "Main", bundle: nil)
//
//                                let paymentOptionsVC = strBrd.instantiateViewController(withIdentifier: "PUSAPaymentOptionsVC") as! PUSAPaymentOptionsVC
//
//                                paymentOptionsVC.paymentOptinonsArray = array.availablePaymentOptions
//                                paymentOptionsVC.netBankingSwiftArray = array.availableNetBanking
//                                paymentOptionsVC.cashCardArray = array.availableCashCard
//                                paymentOptionsVC.emiArray = array.availableEMI
//                                paymentOptionsVC.savedCardArray = array.availableSavedCards
//
//                                paymentOptionsVC.paymentParam = self.paymentParams
//                                let navController = UINavigationController(rootViewController: paymentOptionsVC) // Creating a navigation controller with VC1 at the root of the navigation stack.
//                                self.present(navController, animated:true, completion: nil)
//                              // .pushViewController(paymentOptionsVC, animated: true)
//
//                            }
//                        }
//
//                        else
//                        {
//
//                            let alert = UIAlertController(title: "oops !", message: errorHere as String, preferredStyle: UIAlertControllerStyle.alert)
//                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
//                            self.present(alert, animated: true, completion: nil)
//                        }
//                    }
//                }
//            }
//            else
//            {
//                DispatchQueue.main.async {
//
//
//                    let alert = UIAlertController(title: "oops !", message: error, preferredStyle: UIAlertControllerStyle.alert)
//                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
//                    self.present(alert, animated: true, completion: nil)
//
//                }
//            }
      //  }
   // }
    
    
    @IBAction func BackButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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
func generateTxnID() -> String {
    let currentDate = DateFormatter()
    currentDate.dateFormat = "yyyyMMddHHmmss"
    let date = NSDate()
    let dateString = currentDate.string(from : date as Date)
    return dateString
}
