//
//  BDLoginTableViewController.swift
//  BestDocUser
//
//  Created by nitheesh.u on 04/05/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//

import UIKit
import MapKit
import Foundation
class BDLoginTableViewController: UITableViewController {
    @IBOutlet weak var passwordtextField: UITextField!
    
    @IBOutlet weak var usernameTextField: UITextField!
     let locManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
//    func sha512Base64(string: String) -> String {
//        //        let digest = NSMutableData(length: Int(CC_SHA512_DIGEST_LENGTH))!
//        //        if let data = string.data(using: String.Encoding.utf8) {
//        //            CC_SHA512((data as NSData).bytes, CC_LONG(data.count),UnsafeMutablePointer<UInt8>(digest.mutableBytes))
//        //        }
//        //        return digest.base64EncodedString(options: NSData.Base64EncodingOptions([]))
//        var data = string.data(using: String.Encoding.utf8)
//        //        let digest = NSMutableData(length: Int(CC_SHA512_DIGEST_LENGTH))!
//        //        if let data = string.data(using: String.Encoding.utf8) {
//        //             CC_SHA512(data.bytes, CC_LONG(data.length), &digest)
//        //           // CC_SHA512((data as NSData).bytes, CC_LONG(data.count), UnsafeMutablePointer<UInt8>(digest.mutableBytes))
//        //        }
//        var hashData = Data(count: Int(CC_SHA512_DIGEST_LENGTH))
//        
//        _ = hashData.withUnsafeMutableBytes {digestBytes in
//            data?.withUnsafeBytes {messageBytes in
//                CC_SHA512(messageBytes, CC_LONG((data?.count)!), digestBytes)
//            }
//        }
//        return hashData.base64EncodedString()
//        
//    }
    @IBAction func loginAction(_ sender: UIButton) {
        guard(whitespaceValidation(usernameTextField.text!) == true)
            else
        {
            return alert(alertmessage: "Please Enter the username ")
        }
        
        guard(whitespaceValidation(passwordtextField.text!) == true)
            else
        {
            return alert(alertmessage: "Please Enter the password")
        }
       // String(describing: strToDecode.cString(using: String.Encoding.utf8)
       if let encodedPassword = passwordtextField.text?.sha512()
       {
        var myUrlString:String = encodedPassword
        myUrlString = myUrlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlUserAllowed)!
        print("base64Encoded  ",myUrlString)
        let urlSet =  CharacterSet(charactersIn: ";/?:@&=+$, ").inverted
        let finalPassword = myUrlString.addingPercentEncoding(withAllowedCharacters: urlSet)!
        login(userName: usernameTextField.text!, password:finalPassword)
        }
//        print(encodedPassword)
//        login(userName: usernameTextField.text!, password:encodedPassword)
        
    }
    func alert(alertmessage:String)
    {
        let alert = UIAlertController(title: alertmessage, message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    @IBAction func registerAction(_ sender: UIButton) {
        countryCodeDetails()
        
    }
    @IBAction func forgotPasswordAction(_ sender: UIButton) {
         countryCodeDetailsforgot()
        
    }
    @IBOutlet weak var ForgotPasswordAction: UIButton!
    func countryCodeDetailsforgot()
    {
        var codeDetails = NSDictionary()
        let para = ["app_os_type":2,"appuser_type":appUserType] as [String : Any]
        let progressHUD = ProgressHUD(text: "")
        self.view.addSubview(progressHUD)
        BDService.getCountryList(params: para as [String : AnyObject]){(result, message, status ) in
            progressHUD.hide()
            print(message)
            print(result!)
            if status {
                let serviceDetails = result as? BDService
                codeDetails = (serviceDetails?.countryCodeDetails)!
                print(codeDetails)
                if codeDetails["status"]as! Int == 1
                {
                    if let codes = codeDetails["response"] as? NSDictionary {
                        if let codeList = codes["list"] as? [NSDictionary]{
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BDResetPasswordViewController")as!BDResetPasswordViewController
                            vc.codeData = codeList
                            self.navigationController?.show(vc, sender: self)
                            
                            // self.districtArray =  (district["districts"]as? [NSDictionary])!
                            // print(self.districtArray)
                            // self.menuNames = self.districtArray
                            // self.selectDistrictTableView.reloadData()
                        }
                    }
                    
                }
            }
        }
    }
    func countryCodeDetails()
    {
        var codeDetails = NSDictionary()
        let para = ["app_os_type":2,"appuser_type":appUserType] as [String : Any]
        let progressHUD = ProgressHUD(text: "")
        self.view.addSubview(progressHUD)
        BDService.getCountryList(params: para as [String : AnyObject]){(result, message, status ) in
            progressHUD.hide()
            print(message)
            print(result!)
            if status {
                let serviceDetails = result as? BDService
                codeDetails = (serviceDetails?.countryCodeDetails)!
                print(codeDetails)
                if codeDetails["status"]as! Int == 1
                {
                    if let codes = codeDetails["response"] as? NSDictionary {
                        if let codeList = codes["list"] as? [NSDictionary]{
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BDFirstRegisterViewController")as!BDFirstRegisterViewController
                                vc.codeData = codeList
                                self.navigationController?.show(vc, sender: self)
                            
                       // self.districtArray =  (district["districts"]as? [NSDictionary])!
                       // print(self.districtArray)
                       // self.menuNames = self.districtArray
                       // self.selectDistrictTableView.reloadData()
                    }
                }
                
            }
        }
    }
}
    // MARK: - Table view data source
    
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return 0
    //    }
    //
    //    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        // #warning Incomplete implementation, return the number of rows
    //        return 0
    //    }
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }    
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
