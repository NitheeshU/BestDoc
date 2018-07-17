//
//  BDNewPasswordViewController.swift
//  BestDocUser
//
//  Created by nitheesh.u on 04/07/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//

import UIKit

class BDNewPasswordViewController: UIViewController {
    @IBOutlet weak var phoneNumbertext: UITextField!
    
    @IBOutlet weak var verifyCodeText: UITextField!
    @IBOutlet weak var emailIDText: UITextField!
    
    @IBOutlet weak var newpasswordText: UITextField!
    var phoneNumber = String()
    var emailID = String()
    //var password = String()
    override func viewDidLoad() {
        super.viewDidLoad()
       phoneNumbertext.text = phoneNumber
        emailIDText.text = emailID
        
        // Do any additional setup after loading the view.
    }
    func resetCal()
    {
        if let encodedPassword = newpasswordText.text?.sha512()
        {
            var myUrlString:String = encodedPassword
            myUrlString = myUrlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlUserAllowed)!
            print("base64Encoded  ",myUrlString)
            let urlSet =  CharacterSet(charactersIn: ";/?:@&=+$, ").inverted
            let finalPassword = myUrlString.addingPercentEncoding(withAllowedCharacters: urlSet)!
        var resetCalDic = NSDictionary()
            let para = ["os_type":2,"appuser_type":5,"user_country_id":countryId,"emailid":emailIDText.text!,"mobileno":phoneNumbertext.text!,"newpassword":encodedPassword,"otp":verifyCodeText.text!] as [String : AnyObject]
        print(para)
        let progressHUD = ProgressHUD(text: "")
        self.view.addSubview(progressHUD)
        BDService.resetPasswordChange(params: para as [String : AnyObject]){(result, message, status ) in
            progressHUD.hide()
            print(message as Any)
            print(result!)
            if status {
                let serviceDetails = result as? BDService
                resetCalDic = (serviceDetails?.resetPasswordChange)!
                print(resetCalDic)
                if resetCalDic["status"]as! Int == 1
                {
                    if (resetCalDic["response"] as? NSDictionary) != nil {
                       self.navigationController?.popToRootViewController(animated: true)
                        
                    }else
                    {
                        self.alert(alertmessage:  (resetCalDic["error_msg"]as? String)!)
                    }
                }else{
                    self.alert(alertmessage:  (resetCalDic["error_msg"]as? String)!)
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
    @IBAction func editAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func submitAction(_ sender: UIButton) {
        resetCal()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backAction(_ sender: UIButton) {
       navigationController?.popViewController(animated: true)
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
