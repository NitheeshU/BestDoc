//
//  BDRatingViewController.swift
//  BestDocUser
//
//  Created by nitheesh.u on 22/01/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//

import UIKit

class BDRatingViewController: UIViewController {

    @IBOutlet weak var alertview: UIView!
    @IBOutlet weak var ratelabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    var ratingPoint :String?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        alertview.layer.cornerRadius = 5
    self.view.backgroundColor =  UIColor.black.withAlphaComponent(0.7)
       ratingView.didTouchCosmos = didTouchCosmos
        ratingView.didFinishTouchingCosmos = didFinishTouchingCosmos
        ratingPoint = rateValueD
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.submitAction (_:)))
        self.view.addGestureRecognizer(gesture)
    }
    @objc func someAction(_ sender:UITapGestureRecognizer){
         self.dismiss(animated: true, completion: nil)
    }
   
    @IBAction func submitAction(_ sender: UIButton) {
        ratingValue = ratingPoint!
        rating(ratin:ratingValue)
          NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    func rating(ratin:String)
    {
        if let response = logindictionary["response"]as? NSDictionary{
            if let data = response["login"]as? NSDictionary
            {
                userRegID = (data["userreg_id"])
                //ownerId = (data["userreg_id"])//print(data["patreg_id"]!)
                // mobilenumber = (data["mobile_number"])
            }
        }else{
            patientRegId = UserDefaults.standard.object(forKey:"patientID") as! Int
            userRegID = UserDefaults.standard.object(forKey:"userRegID") as! Int
           // userReg = userRegID
            //patientRegId
        }
       // recommendation:false
        //rating:5
        //friendsAndFamilyId:21529
       // os_type:1
        //ratingRecommendationDate:2018-07-11
       // friendsAndFamilyFlag:false
       // patRegId:21529
       // ratingRecommendationFlag:1
       // user_country_id:1
       // userRegId:3458
        //appuser_type:5
        let dateTimeD = "\(appoinmentDetailsDict["booking_date"]as! String)"
        var resetCalDic = NSDictionary()
        let para = ["os_type":2,"appuser_type":5,"user_country_id":countryId,"ratingRecommendationDate":dateTimeD,"userRegId":(appoinmentDetailsDict["doc_user_reg_id"]as?Int)!,"patRegId":(appoinmentDetailsDict["pat_reg_id"]as?Int)!,"friendsAndFamilyFlag":"false","recommendation":"false","ratingRecommendationFlag":1,"rating":ratin,"friendsAndFamilyId":(appoinmentDetailsDict["pat_reg_id"]as?Int)!] as [String : AnyObject]
        print(para)
        let progressHUD = ProgressHUD(text: "")
        self.view.addSubview(progressHUD)
        BDService.addRating(params: para as [String : AnyObject]){(result, message, status ) in
            progressHUD.hide()
            print(message as Any)
            print(result!)
            if status {
                let serviceDetails = result as? BDService
                resetCalDic = (serviceDetails?.addRating)!
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
    private func didTouchCosmos(_ rating: Double) {
        switch rating {
        case 0:ratelabel.text = ""
        case 1:
            ratelabel.text = "Poor"
        case 2:
            ratelabel.text = "Average"
        case 3:
            ratelabel.text = " Above Average"
        case 4:
            ratelabel.text = "Good"
        case 5:
                ratelabel.text = "Excellent"
        default:
            ratelabel.text = " "
        }
        ratingPoint = "\(rating.cleanValue)"
        //ratelabel.text = "\(rating)"
        ratingView.textColor = UIColor(red: 133/255, green: 116/255, blue: 154/255, alpha: 1)
    }
    private func didFinishTouchingCosmos(_ rating: Double) {
        if ratingPoint != nil{
        ratingPoint = "\(rating.cleanValue)"
        }
        
       
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
extension Double
{
    var cleanValue: String
    {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
