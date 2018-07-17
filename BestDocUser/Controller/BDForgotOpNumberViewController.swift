//
//  BDForgotOpNumberViewController.swift
//  BestDocUser
//
//  Created by nitheesh.u on 04/06/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//

import UIKit

class BDForgotOpNumberViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate {
    var forgotData:[NSDictionary] = []
private var tap: UITapGestureRecognizer!
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var forgotTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    tableHeightConstraint.constant = CGFloat(30+(forgotData.count*80))
        self.tap = UITapGestureRecognizer(target: self, action: #selector(BDForgotOpNumberViewController.someAction(_:)))
        self.tap.delegate = self
        self.view.addGestureRecognizer(self.tap)
       //forgotOPNumber()
        // Do any additional setup after loading the view.
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: self.forgotTable) == true {
            return false
        }
        return true
    }
     @objc func someAction(_ sender:UITapGestureRecognizer){
       self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return forgotData.count
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 50
//    }
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
        
        let para = ["date_of_birth":paramData["dob"],"mobile":paramData["mobile_no"],"p_address":paramData["address"],"email":"","firstname":paramData["patient_name"],"op_no":paramData["op_number"],"inserted_userid": userIDDetail,"sex":genderID,"pat_reg_id":0,"user_country_id":1,"loc_id":locationId,"appuser_type":5,"os_type":2,"p_blood_group":""] as [String : AnyObject]
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
                if resultDic["status"]as! Int == 0
                {
                    OpNumber = paramData["op_number"] as! String
                    if resultDic["error_code"]as! Int == 716{
                        if let response = resultDic["response"]as? NSDictionary{
                          patientRegId =   response["patientId"]
                            
                        }
                        self.alert(alerttitle: "Already in friends and family", alertmessage: "The OP number you are trying to add is already in your friends and family list.you can take booking with that details")
                    }
                }
                if resultDic["status"]as! Int == 1
                {
                    patientRegId = paramData["id"]
                    OpNumber = paramData["op_number"] as! String
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
    func alert(alerttitle:String,alertmessage:String)
    {
        let alert = UIAlertController(title: alerttitle, message: alertmessage, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "Book", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("OK Pressed")
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
        let cancelAction = UIAlertAction(title: "Not now", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
            self.dismiss(animated: true, completion: nil)
        }
        
        // Add the actions
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        // Present the controller
        self.present(alert, animated: true, completion: nil)
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "BDforgotTableViewCell")as!BDforgotTableViewCell
        cell.opNumberLabel.text = (forgotData[indexPath.row]["op_number"]as! String)
        cell.nameLabel.text  = (forgotData[indexPath.row]["patient_name"]as! String)
        cell.addLabl.layer.cornerRadius = 5
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selecedData = forgotData[indexPath.row]as? NSDictionary{
        addFriend(paramData:selecedData)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
       // bookbutton.layer.cornerRadius = 5
       // patientAlert.layer.cornerRadius = 5
        self.view.backgroundColor =  UIColor.black.withAlphaComponent(0.7)
       // let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.someAction (_:)))
      //  self.view.addGestureRecognizer(gesture)
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
