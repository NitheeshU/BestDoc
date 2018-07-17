//
//  BDOtpViewController.swift
//  BestDocUser
//
//  Created by nitheesh.u on 18/05/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//

import UIKit

class BDOtpViewController: UIViewController {

    @IBOutlet weak var otpTextField: UITextField!
    var phoneNumber = String()
   
    override func viewDidLoad() {
        super.viewDidLoad()
self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func NextAction(_ sender: UIButton) {
        guard(whitespaceValidation(otpTextField.text!) == true)
            else
        {
            return alert(alertmessage: "Otp should not be blank")
        }
        otpVerify(otpdata: otpTextField.text!, phone: phoneNumber)
        
    }
    @IBAction func backAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    func otpVerify(otpdata:String,phone:String)
    {
            var otpDetails = NSDictionary()
            let para = ["app_os_type":2,"appuser_type":appUserType, "otp":otpdata,"phone":phone] as [String : Any]
            let progressHUD = ProgressHUD(text: "")
            self.view.addSubview(progressHUD)
            BDService.verifyOtp(params: para as [String : AnyObject]){(result, message, status ) in
                progressHUD.hide()
                print(message)
                print(result!)
                if status {
                    let serviceDetails = result as? BDService
                    otpDetails = (serviceDetails?.otpDic)!
                    print(otpDetails)
                    if otpDetails["status"]as! Int == 1
                    {
                        if let codes = otpDetails["response"] as? NSDictionary {                            if let userDetails = codes["user_details"] as? [NSDictionary]{
                             let vc = self.storyboard?.instantiateViewController(withIdentifier: "BDShowUserDetailsViewController")as!BDShowUserDetailsViewController
                               vc.userDetails = userDetails
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
    func alert(alertmessage:String)
    {
        let alert = UIAlertController(title: alertmessage, message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
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
