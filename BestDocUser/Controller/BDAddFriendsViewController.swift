//
//  BDDAddFriendsViewController.swift
//  BestDocUser
//
//  Created by nitheesh.u on 15/01/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//

import UIKit

class BDAddFriendsViewController: UIViewController,UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var heading: UILabel!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var dobTextField: UITextField!
    @IBOutlet weak var nameLabel: UITextField!
    var name = String()
    var dob = String()
    var patientReg : Any?
    let datePicker = UIDatePicker()
    var myPickerView : UIPickerView!
    var genderID = Int()
    var patientDetails = NSDictionary()
    var gender:[NSDictionary] = [
        [
            "gender": "Male",
            "Id": 1
            
        ],
        [
            "gender": "Female",
            "Id": 2
            
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if editFriends == true{
            nameLabel.text = name
            dobTextField.text = dob
            if genderID == 1{
                
                genderTextField.text =  "Male"
            }else if genderID == 1{
               
                genderTextField.text =  "Female"
                
            }
        }
        if addFriendTag == true{
            heading.text = "Patient Details"
            addressTextField.isHidden = false
            nameLabel.text = (patientDetails["first_name"]as! String)
            if let patientlocationData = (patientDetails["location"]as? String){
            addressTextField.text = patientlocationData
            }else{
                 addressTextField.text = ""
            }
            dobTextField.text = (patientDetails["date_of_birth"]as! String)
            if patientDetails["sex"]as? Int == 1{
                genderID  = 1
                genderTextField.text =  "Male"
            }else if patientDetails["sex"]as? Int == 1{
                genderID  = 1
                genderTextField.text =  "FeMale"
                
            }
        }else{
            heading.text = "Add friends or family"
            addressTextField.isHidden = true
        }
     //   heading.text = "Add friends or family"
       // addressTextField.isHidden = true
        showDatePicker()
         pickUp(genderTextField)
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.someAction (_:)))
        self.view.addGestureRecognizer(gesture)
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
        
        dobTextField.inputAccessoryView = toolbar
        dobTextField.inputView = datePicker
        
    }
    
    @objc func donedatePicker(){
        let formatter2 = DateFormatter()
        formatter2.dateFormat =  "yyyy-MM-dd"
        let finaleDate = formatter2.string(from: datePicker.date)
        dobTextField.text = finaleDate
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
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
        genderTextField.text = gender[row]["gender"]as! String
        genderID = gender[row]["Id"]as! Int
        
    }
    //MARK:- TextFiled Delegate
    
    
    @objc func doneClick() {
        genderTextField.resignFirstResponder()
    }
    @objc func cancelClick() {
        genderTextField.resignFirstResponder()
    }
    
    @objc func someAction(_ sender:UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @IBAction func backAction(_ sender: Any) {
        if tagdata == true||addFriendTag == true{
            self.dismiss(animated: true, completion: nil)
            
        }else{
        navigationController?.popViewController(animated: true)
        }
    }
    func addFriend()
    {
       var resultDic = NSDictionary()
        let para = ["date_of_birth":dobTextField.text!,"mobile":"","p_address":appUserType,"email":"","firstname":nameLabel.text!,"op_no":"","inserted_userid": userRegID,"sex":genderID,"pat_reg_id":patientReg,"user_country_id":1,"loc_id":1,"appuser_type":5,"p_blood_group":""] as [String : AnyObject]
      
        print(para)
        let progressHUD = ProgressHUD(text: "")
        self.view.addSubview(progressHUD)
        BDService.addFriends(params: para as [String : AnyObject]){(response, message, status ) in
            progressHUD.hide()
            print(response!)
            if status {
              print("sucesss")
            }
        
    }
    }
    func saveDetails()
    {
        guard(whitespaceValidation(nameLabel.text!) == true)
            else
        {
            return alert(alertmessage: "Please Enter the name ")
        }
        
        guard(whitespaceValidation(dobTextField.text!) == true)
            else
        {
            return alert(alertmessage: "Please Enter the Date of Birth")
        }
        guard(whitespaceValidation(genderTextField.text!) == true)
            else
        {
            return alert(alertmessage: "Please Enter the Gender")
        }
        guard(whitespaceValidation(addressTextField.text!) == true)
            else
        {
            return alert(alertmessage: "Please Enter the address")
        }
        var resultDic = NSDictionary()
       // date_of_birth:2018-05-21
       // age:0
        //location:kaloor
        //os_type:1
        //name:Nibu
      //  gender:1
       // pat_reg_id:23330
      //  user_country_id:1
       // mobile_number:9446547272
       // appuser_type:5
        print(nameLabel.text)
        let para = ["date_of_birth":dobTextField.text!,"age":0,"location":addressTextField.text!,"os_type":2,"name":nameLabel.text!,"gender":genderID,"pat_reg_id":patientRegId!,"user_country_id":1,"mobile_number":patientDetails["mobile_number"],"appuser_type":5] as [String : AnyObject]
        print(para)
        let progressHUD = ProgressHUD(text: "")
        self.view.addSubview(progressHUD)
        BDService.savePatientDetails(params: para as [String : AnyObject]){(response, message, status ) in
            progressHUD.hide()
            print(response!)
            if status {
                print("sucesss")
                let serviceDetails = response as? BDService
                resultDic = (serviceDetails?.savepatientDetails)!
                print(resultDic)
                if resultDic["status"]as! Int == 1
                {
                    var patientregiad = patientRegId
                    OpNumber = ""
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
    @IBAction func addAction(_ sender: UIButton) {
        guard(whitespaceValidation(nameLabel.text!) == true)
            else
        {
            return alert(alertmessage: "Please Enter the name ")
        }
        
        guard(whitespaceValidation(dobTextField.text!) == true)
            else
        {
            return alert(alertmessage: "Please Enter the Date of Birth")
        }
        guard(whitespaceValidation(genderTextField.text!) == true)
            else
        {
            return alert(alertmessage: "Please Enter the Gender")
        }
       
        if addFriendTag == true{
            saveDetails()
            // self.dismiss(animated: true, completion: nil)
        }else{
             addFriend()
        if tagdata == true{
            self.dismiss(animated: true, completion: nil)
            
        }else{
            
            
            navigationController?.popViewController(animated: true)
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
