//
//  BDVerificationViewController.swift
//  BestDocUser
//
//  Created by nitheesh.u on 19/05/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//

import UIKit
import MapKit
import Foundation
class BDVerificationViewController: UIViewController {
    
 let locManager = CLLocationManager()
    @IBOutlet weak var otpText: UITextField!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var mailORmobLabel: UILabel!
    @IBOutlet weak var mailOrMobButton: UIButton!
    @IBOutlet weak var verifyTitle: UILabel!
    var MobileNo = String()
    var ScreenTag = Bool()
    var mobileverif = Int()
    var emailverif = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.dismiss(animated: true, completion: nil)
        mailOrMobButton.setTitle(MobileNo, for:.normal)
        if forginTag == false{
        if ScreenTag == true{
             mobileScreen()
        }else{
            emailScreen()
        }
        }
        else if forginTag == true{
            ForeginemailScreen()
        }
        // Do any additional setup after loading the view.
    }
    func resendOtp(phoneNumber:String,Email:String)
    {
        var otpDetails = NSDictionary()
        let para = ["phone":phoneNumber,"user":"","userreg_id":userRegID!,"user_country_id":countryId,"emailid":Email] as [String : Any]
        let progressHUD = ProgressHUD(text: "")
        self.view.addSubview(progressHUD)
        BDService.resendOtpverification(params: para as [String : AnyObject]){(result, message, status ) in
            progressHUD.hide()
            print(message!)
            print(result!)
            if status {
                let serviceDetails = result as? BDService
                otpDetails = (serviceDetails?.resendOtpVerifyDic)!
                print(otpDetails)
                if otpDetails["status"]as! Int == 1
                {
                    
                    
                }
            }
        }
    }
    func mobileVerify(phoneNumber:String,otpString:String)
    {
        var otpDetails = NSDictionary()
        let para = ["phone":phoneNumber,"userreg_id":userRegID!,"user_country_id":countryId,"otp":otpString] as [String : Any]
        let progressHUD = ProgressHUD(text: "")
        self.view.addSubview(progressHUD)
        BDService.mobileVerify(params: para as [String : AnyObject]){(result, message, status ) in
            progressHUD.hide()
            print(message!)
            print(result!)
            if status {
                let serviceDetails = result as? BDService
                otpDetails = (serviceDetails?.mobileVerificationDic)!
                print(otpDetails)
                if otpDetails["status"]as! Int == 1
                {
                    if forginTag == false{
                        if  self.emailverif == 0{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier:"BDVerificationViewController" )as! BDVerificationViewController
                            vc.ScreenTag = false
                            vc.MobileNo = emailDataOne
                        self.navigationController?.show(vc, sender: self)
                        }
                    }
                    
                }
            }
        }
    }
    func emailverify(Otp:String,Email:String)
    {
        var otpDetails = NSDictionary()
        let para = ["otp":Otp,"userreg_id":userRegID!,"emailid":Email] as [String : Any]
        print(para)
        let progressHUD = ProgressHUD(text: "")
        self.view.addSubview(progressHUD)
        BDService.emailVerify(params: para as [String : AnyObject]){(result, message, status ) in
            progressHUD.hide()
            print(message!)
            print(result!)
            if status {
                let serviceDetails = result as? BDService
                otpDetails = (serviceDetails?.emailVerificationDic)!
                print(otpDetails)
                if otpDetails["status"]as! Int == 1
                {
                    if registrationStatus == false{
                    for controller in self.navigationController!.viewControllers as Array {
                        if controller.isKind(of: BDEditProfileViewController.self) {
                            _ =  self.navigationController!.popToViewController(controller, animated: true)
                            break
                        }
                    }
                    }else if registrationStatus == true {
                        UserDefaults.standard.set(true, forKey: "loginStatus")
                        loginStatus =  UserDefaults.standard.object(forKey:"loginStatus") as! Bool
                        self.navigationController?.popToRootViewController(animated: true)
//                        for controller in self.navigationController!.viewControllers as Array {
//                            if controller.isKind(of: BDLoginViewController.self) {
//                                _ =  self.navigationController!.popToViewController(controller, animated: true)
//                                break
//                            }
//                        }
                    }
                    
                    
                }
            }
        }
    }
    func login(userName:String,password:String)
    {
        var logindata = NSDictionary()
        
        var currentLocation: CLLocation!
        var lat = Double()
        var log = Double()
        locManager.delegate = locationDelegate
        locManager.requestWhenInUseAuthorization()
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            currentLocation = locManager.location
            lat = currentLocation.coordinate.latitude
            log = currentLocation.coordinate.longitude
            print(lat)
            print(log)
        }
        let hh2 = (Calendar.current.component(.hour, from: Date()))
        let mm2 = (Calendar.current.component(.minute, from: Date()))
        let ss2 = (Calendar.current.component(.second, from: Date()))
        
        print(hh2,":", mm2,":", ss2)
        let currenttime = "\(hh2)"+":"+"\(mm2)"+":"+"\(ss2)"
        print(currenttime)
        let formatter = DateFormatter()
        //2016-12-08 03:37:22 +0000
        formatter.dateFormat = "yyyy-MM-dd"
        let now = Date()
        let dateString = formatter.string(from:now)
        NSLog("%@", dateString)
        print(dateString)
        let systemVersion = UIDevice.current.systemVersion
        print(systemVersion)
        let devicemodel = UIDevice.current.model
        print(devicemodel)
        let para = ["deveice_token":deviceTokenStringData,"device_os":systemVersion,"longitude":log,"pass":password,"login_time":currenttime,"latitude":lat,"device_model":devicemodel,"versionno":"1","user":userName,"appuser_type":appUserType,"login_date":dateString,"os_type":2] as [String : AnyObject]
        print(para)
        let progressHUD = ProgressHUD(text: "")
        self.view.addSubview(progressHUD)
        BDService.login(params: para as [String : AnyObject]){(response, message, status ) in
            progressHUD.hide()
            print(response!)
            if status {
                let loginDetails = response as? BDService
                if loginDetails?.loginDic["status"]as! Int == 0{
                    if let value = loginDetails?.loginDic["error_msg"]as? String{
                        self.alert(alertmessage:value)
                    }
                }else{
                    logindata = (loginDetails?.loginDic)!
                    UserDefaults.standard.set(true, forKey: "loginStatus")
                    loginStatus =  UserDefaults.standard.object(forKey:"loginStatus") as! Bool
                    UserDefaults.standard.set(logindata, forKey: "loginData")
                    print(logindata)
                    logindictionary = UserDefaults.standard.object(forKey:"loginData") as! NSDictionary
                    if let response = logindictionary["response"]as? NSDictionary{
                        if let data = response["login"]as? NSDictionary
                        {
                            userRegID = data["userreg_id"]
                        }
                    }
                    print(userRegID)
                    print(logindictionary)
                    switch logValue
                    {
                    case 1:self.navigationController?.popToRootViewController(animated: true)
                    //let vc = self.storyboard?.instantiateViewController(withIdentifier:"BDProfileViewController" )as! BDProfileViewController
                    // self.navigationController?.show(vc, sender: self)
                        break
                    case 2:self.dismiss(animated: true, completion: nil)
                    //                    let vc = self.storyboard?.instantiateViewController(withIdentifier:"BDBookingSloteViewController" )as! BDBookingSloteViewController
                    /// self.navigationController?.show(vc, sender: self)
                        break
                    default:
                        print("invalid")
                    }
                }
                
            }else{
                print("error")
            }
        }
    }
func mobileScreen()
{
    skipButton.isEnabled = false
    skipButton.isHidden = true
    mailORmobLabel.text = "Change Mobile Number"
    verifyTitle.text = "Verify Mobile Number"
    
    }
    func ForeginemailScreen()
    {
        skipButton.isEnabled = false
        skipButton.isHidden = true
        mailORmobLabel.text = "Change Email"
        verifyTitle.text = "Verify Email"
        
    }
    func emailScreen()
    {
        skipButton.isEnabled = true
        skipButton.isHidden = false
        mailORmobLabel.text = "Change Email"
        verifyTitle.text = "Verify Email"
        
    }
    @IBAction func SkipButtonAction(_ sender: UIButton) {
        
        if registrationStatus == false{
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: BDEditProfileViewController.self) {
                    _ =  self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
        }else if registrationStatus == true {
            UserDefaults.standard.set(true, forKey: "loginStatus")
            loginStatus =  UserDefaults.standard.object(forKey:"loginStatus") as! Bool
            self.navigationController?.popToRootViewController(animated: true)
//            for controller in self.navigationController!.viewControllers as Array {
//                if controller.isKind(of:BDLoginViewController.self) {
//                    _ =  self.navigationController!.popToViewController(controller, animated: true)
//                    break
//                }
//            }
        }
    
    }
    @IBAction func backAction(_ sender: UIButton) {
//        for controller in self.navigationController!.viewControllers as Array {
//            if controller.isKind(of: BDMainViewController.self) {
//                _ =  self.navigationController!.popToViewController(controller, animated: true)
//                break
//            }
//        }
        
       navigationController?.popViewController(animated: true)
    }
    @IBAction func changeButtonAction(_ sender: UIButton) {
        if ScreenTag == false {
    alertController(title:"Change Email ID",placeHolder:"Email ID")
        }
        else if ScreenTag == true{
            alertController(title:"Change Mobile Number",placeHolder:"Mobile Number")
        }
        
    }
    func validate(value: String) -> Bool {
        let PHONE_REGEX = "^[6-9][0-9]{9}$";
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
    @IBAction func verifyAction(_ sender: UIButton) {
        guard(whitespaceValidation(otpText.text!) == true)
            else
        {
            return alert(alertmessage: "otp shouldnot be blank")
        }
        if forginTag == false{
        if ScreenTag == true{
            mobileVerify(phoneNumber:self.mailOrMobButton.title(for: .normal)!,otpString:otpText.text!)
        }
        else if ScreenTag == false{
           emailverify(Otp:otpText.text!,Email:self.mailOrMobButton.title(for: .normal)!)
        }
        }
        else if forginTag == true{
          emailverify(Otp:otpText.text!,Email:self.mailOrMobButton.title(for: .normal)!)
        }
    }
    
    func alert(alertmessage:String)
    {
        let alert = UIAlertController(title: alertmessage, message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
    }
    @IBAction func resendOtpAction(_ sender: UIButton) {
         if self.ScreenTag == true{
            resendOtp(phoneNumber: self.mailOrMobButton.title(for: .normal)!,Email:emailDataOne)
        }
         else if self.ScreenTag == false{
 self.resendOtp(phoneNumber:phoneNumb,Email:self.mailOrMobButton.title(for: .normal)!)
        }
    }
    func alertController(title:String,placeHolder:String)
    {
        //1. Create the alert controller.
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = placeHolder
           // textField.text = "Some default text"
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(textField?.text)")
            if self.ScreenTag == true{
                self.resendOtp(phoneNumber:(textField?.text)!,Email:emailDataOne)
                self.mailOrMobButton.setTitle((textField?.text)!, for:.normal)
            }
            else if self.ScreenTag == false{
                self.resendOtp(phoneNumber:phoneNumb,Email:(textField?.text)!)
                self.mailOrMobButton.setTitle((textField?.text)!, for:.normal)
            }
        }))
        alert.addAction(UIAlertAction(title: "Skip", style: .cancel, handler: { (action: UIAlertAction!) in
            // I have code here
        }))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
