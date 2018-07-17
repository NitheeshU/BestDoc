//
//  BDSecondRegisterViewController.swift
//  BestDocUser
//
//  Created by nitheesh.u on 05/05/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//

import UIKit
import MapKit
import Foundation
class BDSecondRegisterViewController: UIViewController,UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var usernameTextfield: UITextField!
    
    @IBOutlet weak var nametextField: UITextField!
    
    @IBOutlet weak var daetOfBirthTextField: UITextField!
    
    @IBOutlet weak var genderTextfield: UITextField!
    var patientName = String()
     let datePicker = UIDatePicker()
     var myPickerView : UIPickerView!
    var genderID = Int()
    var mobileVerification = Int()
    var emailVerification = Int()
    var firstRegflag = Int()
    var gender:[NSDictionary] = [
        [
            "gender": "Male",
            "Id": 1
            
            ],
        [
            "gender": "Female",
            "Id": 0
            
            ]
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
         showDatePicker()
        nametextField.text = patientName
        self.hideKeyboardWhenTappedAround()
        if firstRegflag == 0{
             patientDetails()
            mobileVerification = 0
            emailVerification = 0
        }else{
            patientDetails()
        }
        
         pickUp(genderTextfield)
        // Do any additional setup after loading the view.
    }
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        daetOfBirthTextField.inputAccessoryView = toolbar
        daetOfBirthTextField.inputView = datePicker
        
    }
    
    @objc func donedatePicker(){
        let formatter2 = DateFormatter()
        formatter2.dateFormat =  "yyyy-MM-dd"
        let finaleDate = formatter2.string(from: datePicker.date)
        daetOfBirthTextField.text = finaleDate
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func pickUp(_ textField : UITextField){
        
        // UIPickerView
        self.myPickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.myPickerView.delegate = self
        self.myPickerView.dataSource = self
        self.myPickerView.backgroundColor = UIColor.white
        textField.inputView = self.myPickerView
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return gender.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return gender[row]["gender"]as! String
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTextfield.text = gender[row]["gender"]as! String
        genderID = gender[row]["Id"]as! Int
        
    }
    //MARK:- TextFiled Delegate
    
   
    @objc func doneClick() {
        genderTextfield.resignFirstResponder()
    }
    @objc func cancelClick() {
        genderTextfield.resignFirstResponder()
    }
    
    @IBAction func registerAction(_ sender: UIButton) {
        guard(whitespaceValidation(usernameTextfield.text!) == true)
            else
        {
            return alert(alertmessage: "userName should not be blank")
        }
        guard(whitespaceValidation(passwordTextfield.text!) == true)
            else
        {
            return alert(alertmessage: "password should not be blank")
        }
        guard(whitespaceValidation(nametextField.text!) == true)
            else
        {
            return alert(alertmessage: "name should not be blank")
        }
        guard(whitespaceValidation(daetOfBirthTextField.text!) == true)
            else
        {
            return alert(alertmessage: "daetOfBirth should not be blank")
        }
        guard(whitespaceValidation(genderTextfield.text!) == true)
            else
        {
            return alert(alertmessage: "gender should not be blank")
        }
        let hashedPAssword = passwordTextfield.text?.sha512()
        print(hashedPAssword!)
        var myUrlString:String = hashedPAssword!
        myUrlString = myUrlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlUserAllowed)!
        print("base64Encoded  ",myUrlString)
        let urlSet =  CharacterSet(charactersIn: ";/?:@&=+$, ").inverted
        let finalPassword = myUrlString.addingPercentEncoding(withAllowedCharacters: urlSet)!
        register(password: finalPassword, dob: daetOfBirthTextField.text!, userName: usernameTextfield.text!, bloodgp:"", id: genderID, firstName: nametextField.text!)
        
    }
    func alert(alertmessage:String)
    {
        let alert = UIAlertController(title: alertmessage, message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
    }
    func patientDetails()
    {
        var patientDetailsDic = NSDictionary()
        let para = ["app_os_type":2,"appuser_type":appUserType,"pat_reg_id":patientRegId] as [String : Any]
        let progressHUD = ProgressHUD(text: "")
        self.view.addSubview(progressHUD)
        BDService.patientDetailsview(params: para as [String : AnyObject]){(result, message, status ) in
            progressHUD.hide()
            print(message)
            print(result!)
            if status {
                let serviceDetails = result as? BDService
                patientDetailsDic = (serviceDetails?.patientViewDic)!
                print(patientDetailsDic)
                if patientDetailsDic["status"]as! Int == 1
                {
                    if let codes = patientDetailsDic["response"] as? NSDictionary {
                        if let patient = codes["patient"]as? NSDictionary
                        {
                            if patient["mobile_number"] != nil {
                            emailDataOne = patient["email"]as! String
                            phoneNumb =  patient["mobile_number"]as! String
                            self.genderID = patient["sex"]as! Int
                            if let countryDetails = patient["country"]as? NSDictionary{
                                countryId = countryDetails["country_id"]as! Int
                            }
                            self.mobileVerification = patient["phone_otp_verify"]as! Int
                            self.emailVerification = patient["email_otp_verify_status"]as! Int
                            }
                        }
                       // phoneNumb = phoneData
                       // emailDataOne = emailData
                        
                    }
                    
                }
            }
        }
    }
    func register(password:String,dob:String,userName:String,bloodgp:String,id:Int,firstName:String)
{
    let systemVersion = UIDevice.current.systemVersion
    print(systemVersion)
    let devicemodel = UIDevice.current.model
    print(devicemodel)
    let locManager = CLLocationManager()
    var currentLocation: CLLocation!
    var lat = Double()
    var log = Double()
    locManager.delegate = locationDelegate
    locManager.requestWhenInUseAuthorization()
    if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
        CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
        currentLocation = locManager.location
        lat = currentLocation.coordinate.latitude
        log = currentLocation.coordinate.longitude
        print(lat)
        print(log)
    }
    var registration = NSDictionary()
    let para = ["appuser_type":appUserType,"pat_reg_id":patientRegId!,"password":password,"date_of_birth":dob,"otp_flag":otp,"device_os":systemVersion,"alternate_indian_no":phoneNumb,"longitude":log,"os_type":2,"email":emailDataOne,"versionno":"1","user_country_id":countryId,"firstName":firstName,"mobile_num":phoneNumb,"device_id":"1","deveice_token":deviceTokenStringData,"username":userName,"latitude":lat,"device_model":devicemodel,"blood_group":bloodgp,"sex":id] as [String : Any]
    let progressHUD = ProgressHUD(text: "")
    self.view.addSubview(progressHUD)
    BDService.register(params: para as [String : AnyObject]){(result, message, status ) in
    progressHUD.hide()
    print(message)
    print(result!)
    if status {
    let serviceDetails = result as? BDService
    registration = (serviceDetails?.registrationDetails)!
    print(registration)
    if registration["status"]as! Int == 1
    {
        UserDefaults.standard.set(true, forKey: "regStatus")
        registrationStatus = UserDefaults.standard.object(forKey:"regStatus") as! Bool
        print(registrationStatus)
        if let responseOne = registration["response"]as? NSDictionary{
            UserDefaults.standard.set(responseOne["patientId"]as! Int, forKey: "patientID")
            patientRegId = UserDefaults.standard.object(forKey:"patientID") as! Int
            UserDefaults.standard.set(responseOne["userregid"]as! Int, forKey: "userRegID")
            //responseOne["patientId"]as! Int
            userRegID = UserDefaults.standard.object(forKey:"userRegID") as! Int
        }
        print("Success")
        if countryId == 1 {
            forginTag = false
            if self.mobileVerification == 0 && self.emailVerification == 0
            {
              let vc = self.storyboard?.instantiateViewController(withIdentifier: "BDVerificationViewController")as! BDVerificationViewController
                vc.mobileverif = self.mobileVerification
                vc.emailverif = self.emailVerification
                vc.MobileNo = phoneNumb
                vc.ScreenTag = true
                self.navigationController?.show(vc, sender: self)
            }else if self.mobileVerification == 0 && self.emailVerification == 1{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "BDVerificationViewController")as! BDVerificationViewController
                vc.mobileverif = self.mobileVerification
                vc.emailverif = self.emailVerification
                vc.MobileNo = emailDataOne
                vc.ScreenTag = false
                self.navigationController?.show(vc, sender: self)
            }else if self.mobileVerification == 1 && self.emailVerification == 0{
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "BDVerificationViewController")as! BDVerificationViewController
                vc.mobileverif = self.mobileVerification
                vc.emailverif = self.emailVerification
                vc.MobileNo = phoneNumb
                vc.ScreenTag = true
                self.navigationController?.show(vc, sender: self)
            }else{
                ///move to corresponding page
            }
            
        }else if countryId != 1{
            
            forginTag = true
            if self.emailVerification != 1{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "BDVerificationViewController")as! BDVerificationViewController
                vc.mobileverif = self.mobileVerification
                vc.emailverif = self.emailVerification
                vc.ScreenTag = false
                 vc.MobileNo = emailDataOne
                self.navigationController?.show(vc, sender: self)
            }
            
        }
    if let codes = registration["response"] as? NSDictionary {
    
    }
    
    }else{
        self.alert(alertmessage: registration["error_msg"]as! String)
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

extension String {
    
    func sha512() -> String {
        let data = self.data(using: String.Encoding.utf8)
        var hashData = Data(count: Int(CC_SHA512_DIGEST_LENGTH))
        
        _ = hashData.withUnsafeMutableBytes {digestBytes in
            data?.withUnsafeBytes {messageBytes in
                CC_SHA512(messageBytes, CC_LONG((data?.count)!), digestBytes)
            }
        }
        return hashData.base64EncodedString()
    }
    
}
