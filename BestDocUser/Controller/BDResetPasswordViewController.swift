//
//  BDResetPasswordViewController.swift
//  BestDocUser
//
//  Created by nitheesh.u on 21/06/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//

import UIKit

class BDResetPasswordViewController: UIViewController,UIPickerViewDataSource, UIPickerViewDelegate,UITextFieldDelegate {

    @IBOutlet weak var emailIDText: UITextField!
    @IBOutlet weak var phoneNumberText: UITextField!
    @IBOutlet weak var idText: UITextField!
    var codeData = [NSDictionary]()
    var myPickerView : UIPickerView!
    var flag = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        pickUp(idText)
        if validate(value: phoneNumberText.text!) {
            print("True")
        }
        // Do any additional setup after loading the view.
    }
    func validate(value: String) -> Bool {
        let PHONE_REGEX = "^[7-9][0-9]{9}$";
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
   
    func resetCal()
    {
        var resetCalDic = NSDictionary()
        // os_type:1
        

        let para = ["os_type":2,"appuser_type":5,"user_country_id":countryId,"emailid":emailIDText.text!,"mobileno":phoneNumberText.text!] as [String : AnyObject]
        print(para)
        let progressHUD = ProgressHUD(text: "")
        self.view.addSubview(progressHUD)
        BDService.resetPAssword(params: para as [String : AnyObject]){(result, message, status ) in
            progressHUD.hide()
            print(message as Any)
            print(result!)
            if status {
                let serviceDetails = result as? BDService
                resetCalDic = (serviceDetails?.ResetPassword)!
                print(resetCalDic)
                if resetCalDic["status"]as! Int == 1
                {
                    if (resetCalDic["response"] as? NSDictionary) != nil {
                        let vc  = self.storyboard?.instantiateViewController(withIdentifier: "BDNewPasswordViewController")as! BDNewPasswordViewController
                        vc.emailID = self.emailIDText.text!
                        vc.phoneNumber = self.phoneNumberText.text!
                        self.navigationController?.show(vc, sender: self)
                        
                    }else
                    {
                    self.alert(alertmessage:  (resetCalDic["error_msg"]as? String)!)
                        
                    }
                }else{
                    self.alert(alertmessage:  (resetCalDic["error_msg"]as? String)!)
                }
                
            }
        }
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
        self.idText.text = (codeData[row]["country_code"]as! String)
        countryId = (codeData[row]["country_id"]as! Int)
    }
    //MARK:- TextFiled Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickUp(idText)
    }
    @objc func doneClick() {
        idText.resignFirstResponder()
    }
    @objc func cancelClick() {
        idText.resignFirstResponder()
    }
    func alert(alertmessage:String)
    {
        let alert = UIAlertController(title: alertmessage, message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
   
    @IBAction func BackAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitAction(_ sender: UIButton) {
        guard(whitespaceValidation(phoneNumberText.text!) == true)
            else
        {
            return alert(alertmessage: "mobile Number should not be blank")
        }
        
        guard(whitespaceValidation(emailIDText.text!) == true)
            else
        {
            return alert(alertmessage: "Invalid Email Id")
        }
        //if validate(value: phoneNumberText.text!) {
           resetCal()
        //}
       // alert(alertmessage: "Please enter a valid mobile number")
        
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
