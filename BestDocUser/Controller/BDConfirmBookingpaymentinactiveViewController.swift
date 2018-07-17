//
//  BDConfirmBookingpaymentinactiveViewController.swift
//  BestDocUser
//
//  Created by nitheesh.u on 05/06/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//

import UIKit

class BDConfirmBookingpaymentinactiveViewController: UIViewController {

    @IBOutlet weak var checkbutton: UIButton!
    @IBOutlet weak var bookingdataLabel: UILabel!
    var name = String()
    var date = String()
    var time = String()
    var dateCorrect = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        checkbutton.setBackgroundImage(#imageLiteral(resourceName: "blank-check-box"), for: .normal)
    
        name = doctorName!
        date = dateDetails
        time = timeDetails
        bookingdataLabel.text = "you are about to book an appoinment with \(name) on \(date) at \(time)"
//        let dateString = date
//        let formatter = DateFormatter()
//        formatter.dateFormat = "EEEE,dd MMM yyyy"
//        let dateDate =  formatter.date(from:dateString)
//        let formatter1 = DateFormatter()
//        formatter1.dateFormat =  "yyyy-MM-dd"
        dateCorrect = dateDetails
       // patientDetails()
         self.view.backgroundColor =  UIColor.black.withAlphaComponent(0.7)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    @IBAction func checkBox(_ sender: UIButton) {
        if checkbutton.isSelected {
             checkbutton.setBackgroundImage(#imageLiteral(resourceName: "check-mark"), for:.normal)
        } else {
          checkbutton.setBackgroundImage(#imageLiteral(resourceName: "UncheckedBox"), for: .normal)
        }
        checkbutton.isSelected = !checkbutton.isSelected
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func bookAction(_ sender: UIButton) {
       // if hmsIntegration == 1 && PaymentActive == 1{
       // hmspatientBooking()
       // }else{
            patientDetails()
      //  }
       
    }
    @IBOutlet weak var cancelAction: UIButton!
    func patientDetails()
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
            }}
        var patientDic = NSDictionary()
        let para = ["book_detail_id":0,"locuser_id":locUserId!,"multi_booking":0,"section_slot":slotData,"os_type":2,"user_country_id":1,"userreg_id":docregid!,"bookuser_type_id":5,"booktime":date24,"booking_date":dateCorrect,"bookstatus_typ_id":2,"txnId":0,"bookowner_userid":userReg!,"session_numbr":1,"appuser_type":5,"patreg_id":patientRegId!] as [String : Any]
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
            }}
       
        var patientDic = NSDictionary()
        let para = ["book_detail_id":0,"locuser_id":locUserId!,"multi_booking":0,"section_slot":slotData,"os_type":2,"user_country_id":1,"userreg_id":docregid!,"bookuser_type_id":5,"booktime":date24,"booking_date":dateCorrect,"bookstatus_typ_id":2,"txnId":0,"bookowner_userid":userReg!,"session_numbr":1,"appuser_type":5,"patreg_id":patientRegId!,"alternate_mobile":""] as [String : Any]
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
