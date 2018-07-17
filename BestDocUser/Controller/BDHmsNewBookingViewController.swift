//
//  BDHmsNewBookingViewController.swift
//  BestDocUser
//
//  Created by nitheesh.u on 01/06/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//

import UIKit

class BDHmsNewBookingViewController: UIViewController {

    @IBOutlet weak var opnumberTextField: UITextField!
   
    @IBOutlet weak var bookAaNewPatient: UIView!
    @IBOutlet weak var forgotOpAction: UIView!
    var forgtoDic = [NSDictionary]()
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // or for swift 2 +
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.someAction (_:)))
        self.forgotOpAction.addGestureRecognizer(gesture)
        let gesturetwo = UITapGestureRecognizer(target: self, action:  #selector (self.someAction2 (_:)))
        self.bookAaNewPatient.addGestureRecognizer(gesturetwo)
        // Do any additional setup after loading the view.
    }
    @objc func someAction(_ sender:UITapGestureRecognizer){
       addFriendTag = false
        forgotOPNumber()
        
        // do other task
    }
    @objc func someAction2(_ sender:UITapGestureRecognizer){
        addFriendTag = true
        tagdata = false
        patientData()
        
        // do other task
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    func patientData()
    {
//        var userIDDetail:Any?
//        var genderID = Int()
//        var resultDic = NSDictionary()
//        if let response = logindictionary["response"]as? NSDictionary{
//            if let data = response["login"]as? NSDictionary
//            {
//                userIDDetail = (data["userreg_id"])
//                //ownerId = (data["userreg_id"])//print(data["patreg_id"]!)
//                //  mobilenumber = (data["mobile_number"])
//            }
//        }
//        if paramData["gender"]as! String == "Male"
//        {
//            genderID = 1
//        }else if paramData["sex"]as! String == "Female"
//        {
//            genderID = 2
//        }
        //date_of_birth:2018-05-21
        // mobile:9446547272
        // os_type:1
        // p_address:
        //email:
        // firstname:Karthu
        //op_no:DH2018/099571
        // pat_reg_id:0
        // user_country_id:1
        // loc_id:180
        // p_blood_group:
        //inserted_userid:12317
        //  sex:2
        //appuser_type:5
        // paramData["id"]
         var patientDetails = NSDictionary()
        let para = ["os_type":2,"pat_reg_id":patientRegId,"user_country_id":1,"appuser_type":5] as [String : AnyObject]
        print(para)
        let progressHUD = ProgressHUD(text: "")
        self.view.addSubview(progressHUD)
        BDService.listPatientDetails(params: para as [String : AnyObject]){(response, message, status ) in
            progressHUD.hide()
            print(response!)
            if status {
                let serviceDetails = response as? BDService
                patientDetails = (serviceDetails?.listPatientDetails)!
                print(patientDetails)
                if patientDetails["status"]as! Int == 1
                {
                    if let response =  patientDetails["response"]as?NSDictionary{
                        let patientData = response["patient_details"] as! NSDictionary
                        let vc = self.storyboard?.instantiateViewController(withIdentifier:"BDAddFriendsViewController" )as! BDAddFriendsViewController
                        vc.patientDetails = patientData
                         self.present(vc, animated: true, completion: nil)
                        
                    }
                }
                
                //vc.forgotData = self.forgtoDic
              //  vc.modalPresentationStyle = .overCurrentContext
             //   self.present(vc, animated: true, completion: nil)
               // BDAddFriendsViewController
             
            }
            
        }
    }
    func forgotOPNumber()
        
    {
        var patientData = [NSDictionary]()
        var mobilenumber:Any?
        // var code = Int()
        if let response = logindictionary["response"]as? NSDictionary{
            if let data = response["login"]as? NSDictionary
            {
                
                //ownerId = (data["userreg_id"])//print(data["patreg_id"]!)
                mobilenumber = (data["mobile_number"])
            }
        }
        //let opnumber = op.uppercased()
        print(userRegID!)
        print(patientRegId!)
        print(mobilenumber!)
        var patientDetails = NSDictionary()
        //os_type:1
        //mobile_no:9446547272
        // op_number:
        // user_country_id:1
        //loc_id:180
        // appuser_type:5
        let para = ["os_type":2,"appuser_type":5,"user_country_id":1,"loc_id":locationId!,"mobile_no":mobilenumber," op_number:":""]as [String : AnyObject]
        print(para)
        let progressHUD = ProgressHUD(text: "")
        self.view.addSubview(progressHUD)
        BDService.forgotOpNumber(params: para as [String : AnyObject]){(result, message, status ) in
            progressHUD.hide()
            print(message!)
            print(result!)
            if status {
                let serviceDetails = result as? BDService
                patientDetails = (serviceDetails?.forgotOpnumberDetails)!
                print(patientDetails)
                if patientDetails["status"]as! Int == 1
                {
                    print(patientDetails)
                    if let response =  patientDetails["response"]as?NSDictionary{
                        patientData = response["patient_details"] as! [NSDictionary]
                        if patientData.count != 0{
                            self.forgtoDic = patientData
                             let vc = self.storyboard?.instantiateViewController(withIdentifier:"BDForgotOpNumberViewController" )as! BDForgotOpNumberViewController
                            vc.forgotData = self.forgtoDic
                            vc.modalPresentationStyle = .overCurrentContext
                            self.present(vc, animated: true, completion: nil)
                        }else{
                            self.alert(alertmessage: "No op number found")
                        }
                        //self.forgotTable.reloadData()
                        
                    }
                    
                }
            }
            
        }
    }
    @IBAction func searchOPNumberAction(_ sender: UIButton) {
        guard(whitespaceValidation(opnumberTextField.text!) == true)
            else
        {
            return alert(alertmessage: "Please Enter the OPNumber ")
        }
        SearchOPNumber(op:opnumberTextField.text!)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func alert(alertmessage:String)
    {
        let alert = UIAlertController(title: alertmessage, message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
    }
    func SearchOPNumber(op:String)
    {
        var mob = String()
        var code = Int()
        if let response = logindictionary["response"]as? NSDictionary{
            if let data = response["login"]as? NSDictionary
            {
               
                 ownerId = (data["userreg_id"])
                mob = (data["mobile_number"]) as! String
                //print(data["patreg_id"]!)
                
            }
        }
        let opnumber = op.uppercased()
        print(userRegID!)
        print(patientRegId!)
        print(opnumber)
        var patientDetails = NSDictionary()
        var patientData = [NSDictionary]()
       // params :
        //os_type:1
        //loc_user_id:3310
       // owner_userreg_id:12317
       // pat_reg_id:23335
       // op_number:DH2017/056132
        //user_country_id:1
       // appuser_type:5
        let para = ["os_type":2,"pat_reg_id":patientRegId!,"appuser_type":5,"user_country_id":1,"loc_user_id":locUserId!,"owner_userreg_id":ownerId!,"op_number":opnumber]as [String : AnyObject]
        print(para)
        let progressHUD = ProgressHUD(text: "")
        self.view.addSubview(progressHUD)
        BDService.searchOPNumber(params: para as [String : AnyObject]){(result, message, status ) in
            progressHUD.hide()
            print(message!)
            print(result!)
            if status {
                let serviceDetails = result as? BDService
                patientDetails = (serviceDetails?.hmsSearchDetails)!
                print(patientDetails)
                if patientDetails["status"]as! Int == 1
                {
                print(patientDetails)
                    if let response =  patientDetails["response"]as?NSDictionary{
                        code = response["code"] as! Int
                        patientData = response["patient_details"]as![NSDictionary]
                        
                    }
                    if code == 748{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier:"BDpatientDetailsAlertViewController" )as! BDpatientDetailsAlertViewController
                        vc.msg = "The OP number you have entered already exists with  a patient in your friends and family.You can take booking with this details"
                    vc.patientDic = patientData[0]
                        let opupper = self.opnumberTextField.text?.uppercased()
                        patientRegId =   patientData[0]["pat_reg_id"]
                        OpNumber = opupper!
                    vc.modalPresentationStyle = .overCurrentContext
                    self.present(vc, animated: true, completion: nil)
                    }
                     if code == 746{
                        self.alert(alertmessage:"Entered OP number doesn't exist" )
                    }
                    if code == 200{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier:"BDpatientDetailsAlertViewController" )as! BDpatientDetailsAlertViewController
                        vc.msg = "The OP number you entered matches with our system. You can continue booking with this details. "
                        vc.patientDic = patientData[0]
                        let opupper = self.opnumberTextField.text?.uppercased()
                        patientRegId =   patientData[0]["pat_reg_id"]
                        OpNumber = opupper!
                    }
                    if code == 747{
                        if  patientData[0]["mobile_no"]as! String == mob{
                            self.addFriend(paramData:patientData[0])
                            
                        }else{
                           self.alert(alertmessage:"Entered OP number doesn't exist")
                        }
                    }
                    }
                }
                
            }
        }
    
    func addFriend(paramData:NSDictionary)
    {
        var userIDDetail:Any?
        var genderID = Int()
        var resultDic = NSDictionary()
        if let response = logindictionary["response"]as? NSDictionary{
            if let data = response["login"]as? NSDictionary
            {
                userIDDetail = (data["userreg_id"])
                //ownerId = (data["userreg_id"])//print(data["patreg_id"]!)
                //  mobilenumber = (data["mobile_number"])
            }
        }
        if paramData["gender"]as! String == "Male"
        {
            genderID = 1
        }else if paramData["sex"]as! String == "Female"
        {
            genderID = 2
        }
        //date_of_birth:2018-05-21
        // mobile:9446547272
        // os_type:1
        // p_address:
        //email:
        // firstname:Karthu
        //op_no:DH2018/099571
        // pat_reg_id:0
        // user_country_id:1
        // loc_id:180
        // p_blood_group:
        //inserted_userid:12317
        //  sex:2
        //appuser_type:5
        // paramData["id"]
        let opupper = opnumberTextField.text?.uppercased()
        let para = ["date_of_birth":paramData["dob"],"mobile":paramData["mobile_no"],"p_address":"","email":"","firstname":paramData["patient_name"],"op_no":opupper,"inserted_userid": userIDDetail,"sex":genderID,"pat_reg_id":0,"user_country_id":1,"loc_id":locationId,"appuser_type":5,"os_type":2,"p_blood_group":""] as [String : AnyObject]
        print(para)
        let progressHUD = ProgressHUD(text: "")
        self.view.addSubview(progressHUD)
        BDService.addFriends(params: para as [String : AnyObject]){(response, message, status ) in
            progressHUD.hide()
            print(response!)
            if status {
                let serviceDetails = response as? BDService
                resultDic = (serviceDetails?.addFriendsDict)!
                print(resultDic)
                if resultDic["status"]as! Int == 1
                {
                    
                        if let response = resultDic["response"]as? NSDictionary{
                            patientRegId =   response["patientId"]
                            OpNumber = opupper!
                            if PaymentActive == 1{
                                let vc = self.storyboard?.instantiateViewController(withIdentifier:"ConfirmBookingViewController" )as! ConfirmBookingViewController
                                //tagdata = true
                                self.present(vc, animated: true, completion: nil)
                            }else if PaymentActive == 0{
                                
                                let vc = self.storyboard?.instantiateViewController(withIdentifier:"BDConfirmBookingpaymentinactiveViewController" )as! BDConfirmBookingpaymentinactiveViewController
                                
                                //tagdata = true
                                vc.modalPresentationStyle = .overCurrentContext
                                self.present(vc, animated: true, completion: nil)
                            }
                        }
                        
                    
                }
            }
            
        }
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
