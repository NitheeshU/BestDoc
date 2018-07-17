//
//  BDMainViewController.swift
//  BestDocUser
//
//  Created by nitheesh.u on 15/01/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//

import UIKit
import Alamofire
class BDMainViewController: UIViewController {

    @IBOutlet weak var loaclityLabel: UILabel!
    @IBOutlet weak var specialitiesView: UIView!
    @IBOutlet weak var selectLocationView: UIView!
    
    @IBOutlet weak var findDoctorButton: UIButton!
    @IBOutlet weak var specialityLabel: UILabel!
   
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileButton: UIButton!
    // var dataLocality = String()
   // var dataSpeciality = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        if let patientData = UserDefaults.standard.object(forKey:"patientID") as? Int{
        patientRegId = patientData
        }
        if let userData = UserDefaults.standard.object(forKey:"userRegID") as? Int{
        userRegID = userData
        }
        profileImage.layer.borderWidth = 1
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.lightGray.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
    //  login(user:"vimalkarthik@apstrix.com", password:"password")
       //  districtcal()
        //dataLocality = "Select Location"
       //dataSpeciality = "All Specialities"
        navigationController?.navigationBar.isHidden = true
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.someAction (_:)))
        selectLocationView.addGestureRecognizer(gesture)
        let gesture2 = UITapGestureRecognizer(target: self, action:  #selector (self.someAction2 (_:)))
        specialitiesView.addGestureRecognizer(gesture2)
        if let reister = UserDefaults.standard.object(forKey:"regStatus") as? Bool{
        registrationStatus = reister //UserDefaults.standard.object(forKey:"regStatus") as! Bool
        }
        if let login = UserDefaults.standard.object(forKey:"loginStatus") as? Bool{
            if login == true&&registrationStatus == false{
                logindictionary = UserDefaults.standard.object(forKey:"loginData") as! NSDictionary
                if let response = logindictionary["response"]as? NSDictionary{
                    print(response)
                    if let data = response["login"]as? NSDictionary
                    {
                        print(data)
                        userRegID = data["userreg_id"]
                        if let image = data["file_url"]as? String{
                            let url = URL(string: image)
                            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                            self.profileImage.image = UIImage(data: data!)
                        }else{
                            profileImage.image = UIImage(named: "ic_profile")
                        }
                    }
                }
            }
            else{
                profileImage.image = UIImage(named: "ic_profile")
            }
        }
        else{
            profileImage.image = UIImage(named: "ic_profile")
        }
        // Do any additional setup after loading the view.
    }
//    func login(user: String, password: String){
//        let loginURL = "http://demo-pos.akstech.com.sg/api/auth/login/"
//        //Alamofire.request(loginURL, method: .post, parameters: ["" : ""], encoding: URLEncoding.default, headers: ["" : ""] ).authenticate(user: user, password: password)
//
//        let credentialData = "\(user):\(password)".data(using: String.Encoding.utf8)!
//        let base64Credentials = credentialData.base64EncodedData()
//        let headers = ["Authorization": "Basic \(base64Credentials)"]
//
//        Alamofire.request(loginURL, method: .post, parameters: nil, encoding: URLEncoding.default, headers: headers)
//            .responseJSON { response  in
//                if (response.result.error == nil){
//                    print(response.result.value!)
//                }else{
//                    print(response.result.error!)
//                }
//        }
//    }
    override func viewWillAppear(_ animated: Bool) {
        //findDoctorButton.isEnabled = false
        if dataLocality != nil{
        loaclityLabel.text = dataLocality
            if dataSpeciality != nil{
                specialityLabel.text = dataSpeciality
                findDoctorButton.isEnabled = true
            }
        //specialityLabel.text = dataSpeciality
        }
        else if dataLocality == nil{
        loaclityLabel.text = "Select Location"
        //specialityLabel.text = "Select Specialities"
        }
        if dataLocality == nil{
             specialityLabel.text = "All Specialities"
        }
        if loaclityLabel.text == "Select Location"{
            specialityLabel.isUserInteractionEnabled = false
        }else{
            specialityLabel.isUserInteractionEnabled = true
        }
        if let login = UserDefaults.standard.object(forKey:"loginStatus") as? Bool{
            if login == true{
                 profile()
            }
        }else{
           self.profileImage.image = UIImage(named: "ic_male")
        }
      
    }
    
    @IBAction func contactUsAction(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier:"BDContactUsViewController")as! BDContactUsViewController
        
        navigationController?.show(vc, sender: self)
    }
    func profile(){
        if let data = UserDefaults.standard.object(forKey:"loginData") as? NSDictionary{
            logindictionary = data
        if let response = logindictionary["response"]as? NSDictionary{
            if let data = response["login"]as? NSDictionary
            {
                //userIDDetail = (data["userreg_id"])
                patientRegId = (data["patreg_id"])
                //ownerId = (data["userreg_id"])//
                //  mobilenumber = (data["mobile_number"])
            }
        }
        }
        else{
            patientRegId = UserDefaults.standard.object(forKey:"patientID") as! Int
            userRegID = UserDefaults.standard.object(forKey:"userRegID") as! Int
            //  userReg = userRegID
            //patientRegId
        }
        
        var profileDetails = NSDictionary()
        let para = ["os_type":1,
                    "pat_reg_id":patientRegId,
                    "user_country_id":1,
                    "appuser_type":5] as [String : AnyObject]
        let progressHUD = ProgressHUD(text: "")
        self.view.addSubview(progressHUD)
        BDService.patientView(params: para as [String : AnyObject]){(result, message, status ) in
            progressHUD.hide()
            print(message!)
            print(result!)
            if status {
                let serviceDetails = result as? BDService
                profileDetails = (serviceDetails?.patientDetailsForEdit)!
                print(profileDetails)
                if profileDetails["status"]as! Int == 1
                {
                    if let response = (profileDetails["response"]as? NSDictionary) {
                        if let data = response["patient"]as? NSDictionary
                        {
                            //self.nameLabe.text = data["first_name"]as? String
                           // self.mobileNoLabel.text =  data["mobile_number"]as? String
                            if let dataimage = data["images"]as? NSDictionary{
                                if let image = dataimage["fileUrl"]as? String{
                                    let url = URL(string: image)
                                    let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                                    self.profileImage.image = UIImage(data: data!)
                                }else{
                                    self.profileImage.image = UIImage(named: "ic_male")
                                }
                            }
                        }
                        
                        // patientRegId = responseOne["patientId"]as! Int
                        //userRegID = responseOne["userregid"]as! Int
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func someAction(_ sender:UITapGestureRecognizer){
        let vc = storyboard?.instantiateViewController(withIdentifier:"selectDistrictViewController" )as! selectDistrictViewController
         //vc.menuNames = districtArray
        navigationController?.show(vc, sender: self)
    }
    @objc func someAction2(_ sender:UITapGestureRecognizer){
        if loaclityLabel.text == "Select Location"
        {
            
            alert(alertmessage: "Select Location")
        }else{
        let vc = storyboard?.instantiateViewController(withIdentifier:"BDSpecialityViewController" )as! BDSpecialityViewController
       
        navigationController?.show(vc, sender: self)
        }
    }
    @IBAction func findDoctorsAction(_ sender: UIButton) {
         if loaclityLabel.text == "Select Location"
         {
            alert(alertmessage: "Select location")
         }else{
            if   specialityLabel.text == "All Specialities"{
                specialityId = 0
       
        }
            let vc = storyboard?.instantiateViewController(withIdentifier:"BDHomaBaseViewController" )as! BDHomaBaseViewController
            navigationController?.show(vc, sender: self)
        }
    }
    
    @IBAction func profileAction(_ sender: UIButton) {
        
        if let login = UserDefaults.standard.object(forKey:"loginStatus") as? Bool{
            
        if login == true&&registrationStatus == false{
             logindictionary = UserDefaults.standard.object(forKey:"loginData") as! NSDictionary
            if let response = logindictionary["response"]as? NSDictionary{
                print(response)
                if let data = response["login"]as? NSDictionary
                {
                      print(data)
                    userRegID = data["userreg_id"]
                }
            }
        let vc = storyboard?.instantiateViewController(withIdentifier:"BDProfileViewController" )as! BDProfileViewController
            navigationController?.show(vc, sender: self)
        }
            else if login == true&&registrationStatus == true{
            let vc = storyboard?.instantiateViewController(withIdentifier:"BDProfileViewController" )as! BDProfileViewController
            navigationController?.show(vc, sender: self)
        }
        else{
            let vc = storyboard?.instantiateViewController(withIdentifier:"BDLoginViewController" )as! BDLoginViewController
             logValue = 1
               navigationController?.show(vc, sender: self)
           
        }
        }else{
         let vc = storyboard?.instantiateViewController(withIdentifier:"BDLoginViewController" )as! BDLoginViewController
             logValue = 1
      navigationController?.show(vc, sender: self)
            
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
