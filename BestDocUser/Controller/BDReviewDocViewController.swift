//
//  BDReviewDocViewController.swift
//  BestDocUser
//
//  Created by nitheesh.u on 11/07/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//

import UIKit

class BDReviewDocViewController: UIViewController {

    @IBOutlet weak var specialityLabel: UILabel!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var profileImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let specialityD = appoinmentDetailsDict["speciality"]as? String{
            
            specialityLabel.text = specialityD
        }
        profileName.text = appoinmentDetailsDict["doctor_name"]as? String
        if let imageFile = (appoinmentDetailsDict["fileUrl"]as? String) {    // returns optional
            profileImage.sd_setImage(with: URL(string: imageFile), placeholderImage: UIImage(named: "ic_male"))
        }
        else {
            profileImage.image =  UIImage(named: "ic_male")
            // user did not have key "name"
            // here would be the place to return "default"
            // or do any other error correction if the key did not exist
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func backAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitAction(_ sender: UIButton) {
         feedBack(msg:reviewTextView.text)
    }
//    func feedBack()
//    {
//
//    }
    func feedBack(msg:String)
    {
        if let response = logindictionary["response"]as? NSDictionary{
            if let data = response["login"]as? NSDictionary
            {
                userRegID = (data["userreg_id"])
                //ownerId = (data["userreg_id"])//print(data["patreg_id"]!)
                // mobilenumber = (data["mobile_number"])
            }
        }
        else{
            patientRegId = UserDefaults.standard.object(forKey:"patientID") as! Int
            userRegID = UserDefaults.standard.object(forKey:"userRegID") as! Int
           // userReg = userRegID
            //patientRegId
        }
      //  feedback:great doctor
       // appuser_type:5
       // loc_user_id:220
       // user_country_id:1
        //doctor_feed_back_id:0
       // booking_detail_id:39619
        //doctor_id:152
        //date_time:2018-07-10 11:01:11
       // pat_reg_id:21529
       // os_type:1
        //  if let encodedPassword = newpasswordText.text?.sha512()
        // {
        // var myUrlString:String = encodedPassword
        // myUrlString = myUrlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlUserAllowed)!
        // print("base64Encoded  ",myUrlString)
      //  let urlSet =  CharacterSet(charactersIn: ";/?:@&=+$, ").inverted
        // let finalPassword = //myUrlString.addingPercentEncoding(withAllowedCharacters: urlSet)!
        let dateTimeD = "\(appoinmentDetailsDict["booking_date"]as! String)" + " " + "\(appoinmentDetailsDict["time_slot"]as!String)"
        var resetCalDic = NSDictionary()
        let para = ["os_type":2,"appuser_type":5,"user_country_id":countryId,"date_time":dateTimeD,"booking_detail_id":(appoinmentDetailsDict["book_id"]as?Int)!,"loc_user_id":(appoinmentDetailsDict["loc_user_id"]as?Int)!,"doctor_id":(appoinmentDetailsDict["doctor_id"]as?Int)!,"pat_reg_id":(appoinmentDetailsDict["pat_reg_id"]as?Int)!,"doctor_feed_back_id":0,"feedback": msg] as [String : AnyObject]
        print(para)
        let progressHUD = ProgressHUD(text: "")
        self.view.addSubview(progressHUD)
        BDService.docFeedBack(params: para as [String : AnyObject]){(result, message, status ) in
            progressHUD.hide()
            print(message as Any)
            print(result!)
            if status {
                let serviceDetails = result as? BDService
                resetCalDic = (serviceDetails?.docfeedABck)!
                print(resetCalDic)
                if resetCalDic["status"]as! Int == 1
                {
                    
                    self.alert(alertmessage:"success")
                    
                    
                }else{
                    self.alert(alertmessage:  (resetCalDic["error_msg"]as? String)!)
                }
                
            }
        }
        // }
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
