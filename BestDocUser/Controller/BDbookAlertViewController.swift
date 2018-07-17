//
//  BDbookAlertViewController.swift
//  BestDocUser
//
//  Created by nitheesh.u on 16/01/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//

import UIKit

class BDbookAlertViewController: UIViewController {

    @IBOutlet weak var FeeLabel: UILabel!
    @IBOutlet weak var tokenNoLabel: UILabel!
    @IBOutlet weak var patientNameLabel: UILabel!
    var tokenNumber = String()
    var response = NSDictionary()
   // var feeData = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        tokenNoLabel.text = tokenNumber
       // slotData = tokenNumber
       // if choseFriends != true{
//        if let response = logindictionary["response"]as? NSDictionary{
//            if let data = response["login"]as? NSDictionary
//            {
//                //print(data["patreg_id"]!)
//                patientName = (data["first_name"]as! String)
//                patientRegId = (data["patreg_id"])
//
//            }
//        }
//        else{
//            patientRegId = UserDefaults.standard.object(forKey:"patientID") as! Int
//            userRegID = UserDefaults.standard.object(forKey:"userRegID") as! Int
//           // userReg = userRegID
//            //patientRegId
//        }
//        let feedata = feeDataValue as String
//
         let feedata = feeDataValue as String
        if feedata != nil{
                   FeeLabel.text = feedata
                  }
        patientNameLabel.text = "For \(patientName)"
        // Do any additional setup after loading the view.
         let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.dismissAction (_:)))
        view.addGestureRecognizer(gesture)
    }
    override func viewWillAppear(_ animated: Bool) {
         patientNameLabel.text = "For \(patientName)"
        if choseFriendTag == false{
            if let response = logindictionary["response"]as? NSDictionary{
                if let data = response["login"]as? NSDictionary
                {
                    //print(data["patreg_id"]!)
                    patientName = (data["first_name"]as! String)
                    patientRegId = (data["patreg_id"])
                    
                }
            }
            else{
                patientRegId = UserDefaults.standard.object(forKey:"patientID") as! Int
                userRegID = UserDefaults.standard.object(forKey:"userRegID") as! Int
                //userReg = userRegID
                //patientRegId
            }
        }
       

        gtopno()
    }
    @objc func dismissAction(_ sender:UITapGestureRecognizer){
    self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gtopno()
    {
        // var response = NSArray()
        var op:NSDictionary?
        let para = ["loc_id":locationId,"appuser_type":appUserType,"pat_reg_id":patientRegId,"user_country_id":1] as [String : AnyObject]
        print(para)
        let progressHUD = ProgressHUD(text: "")
        self.view.addSubview(progressHUD)
        BDService.getOtp(params: para as [String : AnyObject]){(result, message, status ) in
            progressHUD.hide()
            print(result!)
            if status {
                let serviceDetails = result as? BDService
                op = (serviceDetails?.OpnumberDetails)!
                print(op!)
                if op!["status"]as!Int == 1
                {
                    self.response = (op!["response"])as! NSDictionary
                    if let opNumberDetails = self.response["op_no"]as? String{
                    OpNumber = opNumberDetails
                    }else{
                       OpNumber = ""
                    }
                    
                }
            }else{
                
            }
        }
    }
    
    @IBAction func chooseAnotherPatientAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier:"ChoseFriendViewController")as! ChoseFriendViewController
          choseFriends = true
         self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func bookAction(_ sender: UIButton) {
        checkSlotTag = false
        if self.response.count != 0{
             if PaymentActive == 1&&hashpaymentContract == 1&&feeFlotValue>0{
            let vc = storyboard?.instantiateViewController(withIdentifier:"ConfirmBookingViewController" )as! ConfirmBookingViewController
                 //tagdata = true
                   self.present(vc, animated: true, completion: nil)
             }else{
                patientDetails()
            }
        }else if self.response.count == 0{
            if hmsIntegration == 1{
                let vc = self.storyboard?.instantiateViewController(withIdentifier:"BDHmsNewBookingViewController" )as! BDHmsNewBookingViewController
                //tagdata = true
                self.present(vc, animated: true, completion: nil)

            }else if hmsIntegration == 0{
                if PaymentActive == 1&&hashpaymentContract == 1&&feeFlotValue>0{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier:"ConfirmBookingViewController" )as! ConfirmBookingViewController
                    //tagdata = true
                    self.present(vc, animated: true, completion: nil)
                }
                else if PaymentActive == 0{
                          patientDetails()
                }
            }
            
        }
        
        
            
        

//
    }
    func patientDetails()
    {
        var userReg:Any?
        if let data = UserDefaults.standard.object(forKey:"loginData") as? NSDictionary{
            logindictionary = data
        if let response = logindictionary["response"]as? NSDictionary{
            if let data = response["login"]as? NSDictionary
            {
                userReg = (data["userreg_id"])
                //patientRegId = (data["patreg_id"])
                //ownerId = (data["userreg_id"])//
                //  mobilenumber = (data["mobile_number"])
            }}
            }else{
               // patientRegId = UserDefaults.standard.object(forKey:"patientID") as! Int
                userRegID = UserDefaults.standard.object(forKey:"userRegID") as! Int
            }
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
