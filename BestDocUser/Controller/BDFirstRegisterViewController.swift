//
//  BDFirstRegisterViewController.swift
//  BestDocUser
//
//  Created by nitheesh.u on 05/05/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//

import UIKit

class BDFirstRegisterViewController: UIViewController,UIPickerViewDataSource, UIPickerViewDelegate,UITextFieldDelegate {
   
    @IBOutlet weak var mobileNumbertextField: UITextField!
    @IBOutlet weak var emailtextField: UITextField!
    @IBOutlet weak var countryCode: UITextField!
    var codeData = [NSDictionary]()
    var myPickerView : UIPickerView!
    var flag = 0
    override func viewDidLoad() {
        super.viewDidLoad()
       self.hideKeyboardWhenTappedAround()
       pickUp(countryCode)
        // Do any additional setup after loading the view.
    }
    func validate(value: String) -> Bool {
        let PHONE_REGEX = "^[7-9][0-9]{9}$";
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    func isValidEmail(testStr:String) -> Bool {
        print("validate emilId: \(testStr)")
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
  //  alert(alertmessage: "Please enter a valid mobile number")
    @IBAction func nextAction(_ sender: UIButton) {
        guard(whitespaceValidation(mobileNumbertextField.text!) == true)
            else
        {
            return alert(alertmessage: "mobile Number should not be blank")
        }
        
        guard(isValidEmail(testStr: emailtextField.text!) == true)
            else
        {
            return alert(alertmessage: "Invalid Email Id")
        }
        guard(whitespaceValidation(countryCode.text!) == true)
            else
        {
            return alert(alertmessage: "Invalid countryCode")
        }
        guard(validate(value: mobileNumbertextField.text!) == true)
        else
        {
          return alert(alertmessage: "mobile Number not valid")
        }
        if countryId != 1{
            alert(alertmessage: "mobile Number not valid")
        }
      //  if validate(value: mobileNumbertextField.text!) {
    registrtionCheck(emailData:emailtextField.text!,phoneData:mobileNumbertextField.text!,countrysID:countryId)
     //   }
      //  alert(alertmessage: "Please enter a valid mobile number")
       
    }
    @IBAction func backAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    func alert(alertmessage:String)
    {
        let alert = UIAlertController(title: alertmessage, message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
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
        return codeData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return (codeData[row]["country_name"]as! String)+(codeData[row]["country_code"]as! String)+"(\(codeData[row]["iso_code"]as! String))"
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.countryCode.text = (codeData[row]["country_code"]as! String)
        countryId = (codeData[row]["country_id"]as! Int)
    }
    //MARK:- TextFiled Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickUp(countryCode)
    }
    @objc func doneClick() {
        countryCode.resignFirstResponder()
    }
    @objc func cancelClick() {
        countryCode.resignFirstResponder()
    }
    func registrtionCheck(emailData:String,phoneData:String,countrysID:Int)
    {
        
        var registrationCheck = NSDictionary()
        let para = ["os_type":2,"appuser_type":appUserType,"email":emailData,"phone":phoneData,"user_country_id":countrysID] as [String : Any]
        phoneNumb = phoneData
        emailDataOne = emailData
        let progressHUD = ProgressHUD(text: "")
        self.view.addSubview(progressHUD)
        BDService.checkRegistration(params: para as [String : AnyObject]){(result, message, status ) in
            progressHUD.hide()
            print(message!)
            print(result!)
            if status {
                let serviceDetails = result as? BDService
                registrationCheck = (serviceDetails?.registrationCheck)!
                print(registrationCheck)
                if let Status = registrationCheck["status"]as? Int
                {
                if Status == 1{
                   firstRegflag = 1
                    if let codes = registrationCheck["response"] as? NSDictionary {
                        if codes["register_status"]as! Int == 1{
                            self.alert(alertmessage: codes["msg"]as! String)
                        }else  if codes["repeating_status"]as! Int == 1 && codes["flag"]as! Int == 3{
                            if self.mobileNumbertextField.text != (codes["mobile"]as! String){
                            // self.alert(alertmessage: )
                            let alert = UIAlertController(title:"Email provided is already linked with this ******\(codes["mobile"])", message: "", preferredStyle: UIAlertControllerStyle.alert)
                            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                UIAlertAction in
                                self.emailtextField.text = ""
                            }
                            alert.addAction(okAction)
                            // show the alert
                            self.present(alert, animated: true, completion: nil)
                            }
                            
                        }
                        else{
                            
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BDOtpViewController")as! BDOtpViewController
                            vc.phoneNumber = codes["mobile"] as! String
                            
                            self.navigationController?.show(vc, sender: self)
                        }
                        
                       
                        
                        
                            
                            // self.districtArray =  (district["districts"]as? [NSDictionary])!
                            // print(self.districtArray)
                            // self.menuNames = self.districtArray
                            // self.selectDistrictTableView.reloadData()
                        
                    }
                    
                
                else{
                    self.flag = 0
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "BDSecondRegisterViewController")as! BDSecondRegisterViewController
                    patientRegId = 0
                    firstRegflag = 0
                    self.navigationController?.show(vc, sender: self)
                }
                }
                else{
                    self.flag = 0
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "BDSecondRegisterViewController")as! BDSecondRegisterViewController
                    patientRegId = 0
                    firstRegflag = 0
                    self.navigationController?.show(vc, sender: self)
                    //self.alert(alertmessage: registrationCheck["error_msg"]as! String)
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
