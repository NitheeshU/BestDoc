//
//  BDSuccessViewController.swift
//  BestDocUser
//
//  Created by nitheesh.u on 19/06/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//

import UIKit

class BDSuccessViewController: UIViewController {
 var dateCorrect = String()
    var bookingID : Any?
    override func viewDidLoad() {
        super.viewDidLoad()
         let dateString = dateDetails
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE,dd MMM yyyy"
        let dateDate =  formatter.date(from:dateString)
        let formatter1 = DateFormatter()
        formatter1.dateFormat =  "yyyy-MM-dd"
        dateCorrect = dateDetails
        // Do any additional setup after loading the view.
    }
    @IBAction func navbackAction(_ sender: UIButton) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.window?.rootViewController?.dismiss(animated: true, completion: nil)
            (appDelegate.window?.rootViewController as? UINavigationController)?.popToRootViewController(animated: true)
        }

    }
    
    @IBAction func calusButton(_ sender: Any) {
        callNumber(phoneNumber:"9020602222")
    }
    @IBAction func receiveAction(_ sender: Any) {
        patientDetails()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func callNumber(phoneNumber:String) {
        
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    func patientDetails()
    {
        let systemVersion = UIDevice.current.systemVersion
        print(systemVersion)
        let devicemodel = UIDevice.current.model
        print(devicemodel)
        var userReg:Any?
        if let response = logindictionary["response"]as? NSDictionary{
            if let data = response["login"]as? NSDictionary
            {
                userReg = (data["userreg_id"])
                //patientRegId = (data["patreg_id"])
                print(patientRegId)
                //ownerId = (data["userreg_id"])//
                //  mobilenumber = (data["mobile_number"])
            }}
        var patientDic = NSDictionary()
        let para = ["feedbackId":0,"otherInfo":"","createdDate":dateCorrect,"userType":5,"os_type":2,"modelNumber":systemVersion,"location":"","feedbackType":7,"bookingId":bookingID!,"friendsAndFamilyFlag":false,"manufacturer":devicemodel,"message":"","userRegId":userReg!,"appuser_type":5] as [String : Any]
        print(para)
        //let para = ["stateId":1,"appuser_type":5]
        let progressHUD = ProgressHUD(text: "")
        self.view.addSubview(progressHUD)
        BDService.feedBack(params: para as [String : AnyObject]){(result, message, status ) in
            progressHUD.hide()
            print(message!)
            print(result!)
            if status {
                let serviceDetails = result as? BDService
                patientDic = (serviceDetails?.feedBack)!
                print(patientDic)
                if patientDic["status"]as! Int == 1
                {
                    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                    appDelegate.window?.rootViewController?.dismiss(animated: true, completion: nil)
                    (appDelegate.window?.rootViewController as? UINavigationController)?.popToRootViewController(animated: true)
                    }

//                    if (patientDic["response"] as? NSDictionary) != nil {
//                        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: false, completion: {
//                            self.navigationController?.popToRootViewController(animated: true)
//                        })
//                    }
                }
                else if patientDic["status"]as! Int == 0 {
                    self.alert(alertmessage: patientDic["error_msg"]as! String)
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
