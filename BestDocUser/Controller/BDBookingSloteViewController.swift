//
//  BDBookingSloteViewController.swift
//  BestDocUser
//
//  Created by nitheesh.u on 16/01/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//

import UIKit

class BDBookingSloteViewController:UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    
    @IBOutlet weak var dateText: UITextField!
    @IBOutlet weak var hospitalNames: UILabel!
    @IBOutlet weak var doctorNames: UILabel!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var slotesCollection: UICollectionView!
    let datePicker = UIDatePicker()
    var sessions:[String]?
    var time:[String]?
    var time2 :[String]?
    var resultDate:String?
    var SessioSlotArray:[NSDictionary] = []
    var pickerTg  = Bool()
    var currentDateV = String()
    var checked = Int()
    var dateStringData = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        if let loginData =  UserDefaults.standard.object(forKey:"loginStatus") as? Bool
        {
        loginStatus =  loginData
        }
        showDatePicker()
        sessions = ["SESSION 09:30 AM - 12:00 PM IST","SESSION 04:30 PM - 06:30 PM IST"]
        time = ["09:30 AM","09:40 AM","09:50 AM","10:00 AM","10:10 AM","10:20 AM","10:30 AM","10:40 AM","10:50 AM","11:00 AM","11:10 AM","11:20 AM","11:30 AM","11:40 AM","11:50 AM"]
        time2 = ["04:30 PM","04:40 PM","04:50 PM","5:00 PM","05:10 PM","05:20 PM","05:30 PM","05:40 PM","05:50 PM","06:00 PM","06:10 PM","06:20 PM"]
        // Do any additional setup after loadig the view.
    }
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        dateText.inputAccessoryView = toolbar
        dateText.inputView = datePicker
        
    }
    
    @objc func donedatePicker(){
        pickerTg = true
        let formatter2 = DateFormatter()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE,dd MMM yyyy"
        formatter2.dateFormat =  "yyyy-MM-dd"
        let finaleDate = formatter2.string(from: datePicker.date)
        resultDate = finaleDate
        dateDetails = resultDate!
        Sessions()
       // currentDateV = formatter.string(from: datePicker.date)
        dateText.text = formatter.string(from: datePicker.date)
        pickerTg = false
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    override func viewWillAppear(_ animated: Bool) {
        
        if checkSlotTag == true {
            resultDate =  (UserDefaults.standard.object(forKey:"availabelDate") as! String)
            print(resultDate!)
            var Checked :Int? = 0
            var ChecksessionDic:NSDictionary?
            let para = ["booking_date":resultDate,"locuser_id":locUserId,"appuser_type":appUserType,"patreg_id":patientRegId,"user_country_id":1] as [String : AnyObject]
            print(para)
            let progressHUD = ProgressHUD(text: "")
            self.view.addSubview(progressHUD)
            BDService.checkBoxResponse(params: para as [String : AnyObject]){(result, message, status ) in
                progressHUD.hide()
                print(result!)
                if status {
                    let serviceDetails = result as? BDService
                    ChecksessionDic = (serviceDetails?.checkDict)!
                    print(ChecksessionDic!)
                    if ChecksessionDic!["status"]as! Int == 1
                    {
                        if let response = ChecksessionDic!["response"]as?NSDictionary{
                            Checked =  response["is_booking_exist"]as? Int
                            if Checked == 0{
                                let vc = self.storyboard?.instantiateViewController(withIdentifier:"BDbookAlertViewController" )as! BDbookAlertViewController
                               // UserDefaults.standard.object(forKey:"loginStatus") as! Bool
                              //  UserDefaults.standard.set(dateAsString, forKey: "slotTime")
  // UserDefaults.standard.set(slotData, forKey: "tokenNumber")
                                let dateAsString = UserDefaults.standard.object(forKey:"slotTime") as! String//slotes[indexPath.row]["slotTime"]as! String
                            intialTime = dateAsString
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "HH:mm:ss"
                                // dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                                let date = dateFormatter.date(from: dateAsString)
                                date24 = dateAsString
                                dateFormatter.dateFormat = "h:mm a"
                                let Date12 = dateFormatter.string(from: date!)
                                timeDetails = Date12
                                vc.modalPresentationStyle = .overCurrentContext
                                vc.tokenNumber = "Token No:\(UserDefaults.standard.object(forKey:"tokenNumber") ?? 0)"
                                slotData = "\(UserDefaults.standard.object(forKey:"tokenNumber") ?? 0)"
                                timeSlot = Date12
                                //slotData = "\(indexPath.row+1)"
                                
                                //        if indexPath.section == 0
                                //        {
                                //            slotData = "\(indexPath.row+1)"
                                //            timeSlot = (time?[indexPath.row])!
                                //
                                //        }
                                //        else if indexPath.section == 1
                                //        {
                                //            slotData = "\(indexPath.row+1)"
                                //            timeSlot = (time2?[indexPath.row])!
                                
                                self.navigationController?.present(vc, animated: true, completion: nil)
                            }else if Checked == 1{
                                let alertController = UIAlertController(title: "Already booked", message: " ", preferredStyle: .alert)
                                
                                // Create the actions
                                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                    UIAlertAction in
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier:"ChoseFriendViewController")as! ChoseFriendViewController
                                    checkSlotTag = true
                                    choseFriends = true
                                    self.present(vc, animated: true, completion: nil)
                                    // self.navigationController?.popViewController(animated: true)
                                }
                                
                                // Add the actions
                                alertController.addAction(okAction)
                                // Present the controller
                                self.present(alertController, animated: true, completion: nil)
                                
                            }
                            print(Checked!)
                        }
                    }
                    
                }else{
                    Checked = 0
                }
                
            }
            
        }
        else{
            let currentDateTime = Date()
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE,dd MMM yyyy"
            
            dateText.text = "\(dateFormatter.string(from: currentDateTime))"
            currentDateV = "\(dateFormatter.string(from: currentDateTime))"
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat =  "yyyy-MM-dd"
            resultDate = formatter.string(from: date)
            print(resultDate!)
            Sessions()
            self.slotesCollection.delegate = self
            self.slotesCollection.dataSource = self
            dateDetails =  resultDate!
            intialDate = resultDate!
        }
        //checked = checkSlot()
        checked = checkSlot()
        if checked == 0{
            print("Hai")
        }else if checked == 1{
             print("Hello")
        }
        doctorNames.text = doctorName
        hospitalNames.text = hospitalName
        
    }
    func Sessions()
    {
        var tagValue = Bool()
        var _:[NSMutableDictionary]?
        var sessionDic:NSDictionary?
        let para = ["date":resultDate,"locUserId":locUserId,"appuser_type":appUserType] as [String : AnyObject]
        print(para)
        let progressHUD = ProgressHUD(text: "")
        self.view.addSubview(progressHUD)
        BDService.viewSession(params: para as [String : AnyObject]){(result, message, status ) in
            progressHUD.hide()
            print(result!)
            if status {
                let serviceDetails = result as? BDService
                sessionDic = (serviceDetails?.sessionDic)!
                print(sessionDic!)
                if sessionDic!["status"]as! Int == 1
                {
                    if let responsedic = sessionDic!["response"]as?NSDictionary{
                        hmsIntegration = (responsedic["isIntegrated"]as! Int)
                        PaymentActive = (responsedic["isPaymentActive"]as! Int)
                        hashpaymentContract = (responsedic["hasPaymentContract"]as! Int)
                        if let sessionArray = responsedic["sessions"]as?[NSDictionary]{
                            print(sessionArray)
                            let hh2 = (Calendar.current.component(.hour, from: Date()))
                            let mm2 = (Calendar.current.component(.minute, from: Date()))
                            let ss2 = (Calendar.current.component(.second, from: Date()))
                            
                            print(hh2,":", mm2,":", ss2)
                            let currenttime = "\(hh2)"+":"+"\(mm2)"+":"+"\(ss2)"
                            if  sessionArray.count != 0{
                                _ = sessionArray[0]["sessionStartTime"]as!String
                                let endString   = sessionArray[0]["sessionEndTime"]as!String
                                
                                // convert strings to `NSDate` objects
                                
                                let formatter = DateFormatter()
                                formatter.dateFormat = "HH:mm:ss"
                                let startTime = formatter.date(from: currenttime)
                                let endTime = formatter.date(from: endString)
                                //  let calendar = NSCalendar.current
                                //let hour = (Calendar.current.component(.hour, from: startTime!))
                                let time1 = 60*Calendar.current.component(.hour, from: endTime!) + Calendar.current.component(.minute, from: endTime!)
                                let time2 =  60*Calendar.current.component(.hour, from: startTime!) + Calendar.current.component(.minute, from:startTime!)
                                if self.dateText.text == self.currentDateV{
                                    if time2 > time1
                                    {
                                        tagValue = true
                                        print(time1)
                                        print(time2)
                                        
                                    }else
                                    {
                                        tagValue = false
                                        print(time1)
                                        print(time2)
                                        
                                    }
                                }
                                else{
                                    tagValue = false
                                }
                                // let startComponents = calendar.components([.hour, .minute,.second], fromDate: startTime!)
                                // let endComponents = calendar.components([.Hour, .Minute], fromDate: endTime!)
                                
                                if currenttime > sessionArray[0]["sessionEndTime"]as!String{
                                    
                                }else
                                {
                                    
                                }
                            }else{
                                tagValue = true
                            }
                            
                            // output: ---> 9 : 10 : 55
                            
                            if tagValue == true{
                             //   print(responsedic["next_available_date"]as! String)
                                
                                
                                if let myDateString = responsedic["next_available_date"]as? String{
                                
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd"
                                let myDate = dateFormatter.date(from: myDateString)!
                                
                                dateFormatter.dateFormat = "EEEE,dd MMM yyyy"
                                let somedateString = dateFormatter.string(from: myDate)
                                let alertController = UIAlertController(title: "No Booking Available", message: "Next available date is \(somedateString)", preferredStyle: .alert)
                                
                                // Create the actions
                                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                    UIAlertAction in
                                    self.resultDate = responsedic["next_available_date"]as? String
                                    self.dateText.text = somedateString
                                    self.Sessions()
                                }
                                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
                                    UIAlertAction in
                                    self.navigationController?.popViewController(animated: true)
                                }
                                
                                // Add the actions
                                alertController.addAction(okAction)
                                alertController.addAction(cancelAction)
                                // Present the controller
                                self.present(alertController, animated: true, completion: nil)
                                }else{
                                    print("No Data")
                                }
                                
                            }
                            else
                            {
                                self.SessioSlotArray = (sessionArray as? [NSDictionary])!
                                self.slotesCollection.reloadData()
                            }
                            
                        }
                    }
                }else if sessionDic!["status"]as! Int == 0{
                    if let responsedic = sessionDic!["response"]as?NSDictionary{
                        if let myDateString = responsedic["next_available_date"]as? String{
                            
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd"
                            let myDate = dateFormatter.date(from: myDateString)!
                            
                            dateFormatter.dateFormat = "EEEE,dd MMM yyyy"
                            let somedateString = dateFormatter.string(from: myDate)
                            let alertController = UIAlertController(title: "No Booking Available", message: "Next available date is\(somedateString)", preferredStyle: .alert)
                            
                            // Create the actions
                            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                UIAlertAction in
                                self.resultDate = responsedic["next_available_date"]as? String
                                self.dateText.text = somedateString
                                self.Sessions()
                            }
                            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
                                UIAlertAction in
                                self.navigationController?.popViewController(animated: true)
                            }
                            
                            // Add the actions
                            alertController.addAction(okAction)
                            alertController.addAction(cancelAction)
                            // Present the controller
                            self.present(alertController, animated: true, completion: nil)
                        }else{
                            print("No Data")
                        }
                        
                    }
                    else
                    {
                        
                    }
                    
                    }
                
            }
            
        }
    }
    func checkSlot()->Int
    {
        var Checked :Int? = 0
        var ChecksessionDic:NSDictionary?
        let para = ["booking_date":resultDate,"locuser_id":locUserId,"appuser_type":appUserType,"patreg_id":patientRegId,"user_country_id":1] as [String : AnyObject]
        print(para)
        let progressHUD = ProgressHUD(text: "")
        self.view.addSubview(progressHUD)
        BDService.checkBoxResponse(params: para as [String : AnyObject]){(result, message, status ) in
            progressHUD.hide()
            print(result!)
            if status {
                let serviceDetails = result as? BDService
                ChecksessionDic = (serviceDetails?.checkDict)!
                print(ChecksessionDic!)
                if ChecksessionDic!["status"]as! Int == 1
                {
                    if let response = ChecksessionDic!["response"]as?NSDictionary{
                        Checked =  response["is_booking_exist"]as? Int
                        print(Checked!)
                    }
                }
                
            }else{
                Checked = 0
            }
        }
        
        return Checked!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //Mark:- collectionView Delegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return (SessioSlotArray.count)
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var number = Int()
        if let arrayoFSlotes =  SessioSlotArray[section]["slots"]as? [NSDictionary]{
            number = arrayoFSlotes.count
        }
        return number
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = slotesCollection.dequeueReusableCell(withReuseIdentifier: "BDSlotsCollectionViewCell", for: indexPath) as! BDSlotsCollectionViewCell
        if let slotes = SessioSlotArray[indexPath.section]["slots"]as? [NSDictionary]{
            let dateAsString = slotes[indexPath.row]["slotTime"]as! String
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss"
            // dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            let date = dateFormatter.date(from: dateAsString)
            
            dateFormatter.dateFormat = "h:mm a"
            let Date12 = dateFormatter.string(from: date!)
            cell.timeLabel.text = Date12
            cell.slotLabel.text = "\(slotes[indexPath.row]["tokenNumber"] ?? 0)"
            if slotes[indexPath.row]["isBooked"]as! Bool == true || slotes[indexPath.row]["isTimedOut"]as! Bool == true {
                cell.slotLabel.backgroundColor = UIColor.gray
                //  cell.contentView.isHidden = true
            }
            else{
                cell.slotLabel.backgroundColor = UIColor(red: 0/255.0, green: 167/255.0, blue: 157/255.0, alpha: 0.85)
                //cell.contentView.isHidden = false
            }
        }
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "BDSlotCollectionReusableView", for: indexPath) as? BDSlotCollectionReusableView{
            let startTime = time24to12(inputTime:SessioSlotArray[indexPath.section]["sessionStartTime"]as! String)
            let stopTime = time24to12(inputTime:SessioSlotArray[indexPath.section]["sessionEndTime"]as! String)
            sectionHeader.sectionHeader.text = "SESSION "+startTime+"-"+stopTime+" IST"
            sectionHeader.layer.addBorder(edge: .bottom, color: UIColor.lightGray, width: self.view.frame.width, thickness: 0.5)
            return sectionHeader
        }
        return UICollectionReusableView()
    }
    @IBAction func backAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       // gtopno()
     
        dateDetails = resultDate!
        UserDefaults.standard.set( resultDate, forKey: "availabelDate")
        if let slotes = SessioSlotArray[indexPath.section]["slots"]as? [NSDictionary]{
            if slotes[indexPath.row]["isBooked"]as! Bool == true || slotes[indexPath.row]["isTimedOut"]as! Bool == true {
                if slotes[indexPath.row]["isTimedOut"]as! Bool == true {
                    print("isTimedOut")
                    
                }
                else{
                    print("isBooked")
                }
                
            }else{
                print(loginStatus)
                if loginStatus == true && registrationStatus == true{
                    loginStatus =  UserDefaults.standard.object(forKey:"loginStatus") as! Bool
                }else if loginStatus == true && registrationStatus == false{
                if let Logindic = UserDefaults.standard.object(forKey:"loginData") as? NSDictionary{
                logindictionary = Logindic
                     loginStatus =  UserDefaults.standard.object(forKey:"loginStatus") as! Bool
                }else{
                    loginStatus = false
                }
                }
                print(logindictionary)
              //  loginStatus =  UserDefaults.standard.object(forKey:"loginStatus") as! Bool
                if  loginStatus == true
                {
                    var Checked :Int? = 0
                    var ChecksessionDic:NSDictionary?
                    let para = ["booking_date":resultDate,"locuser_id":locUserId,"appuser_type":appUserType,"patreg_id":patientRegId,"user_country_id":1] as [String : AnyObject]
                    print(para)
                    let progressHUD = ProgressHUD(text: "")
                    self.view.addSubview(progressHUD)
                    BDService.checkBoxResponse(params: para as [String : AnyObject]){(result, message, status ) in
                        progressHUD.hide()
                        print(result!)
                        if status {
                            let serviceDetails = result as? BDService
                            ChecksessionDic = (serviceDetails?.checkDict)!
                            print(ChecksessionDic!)
                            if ChecksessionDic!["status"]as! Int == 1
                            {
                                UserDefaults.standard.set(slotes[indexPath.row]["slotTime"]as! String, forKey: "slotTime")
                   UserDefaults.standard.set(slotes[indexPath.row]["tokenNumber"], forKey: "tokenNumber")
                                if let response = ChecksessionDic!["response"]as?NSDictionary{
                                    Checked =  response["is_booking_exist"]as? Int
                                    if Checked == 0{
                                        let vc = self.storyboard?.instantiateViewController(withIdentifier:"BDbookAlertViewController" )as! BDbookAlertViewController
                                        
                                        let dateAsString = slotes[indexPath.row]["slotTime"]as! String
                                      
                                        print(UserDefaults.standard.object(forKey:"slotTime") as! String)
                                      //  loginStatus =  UserDefaults.standard.object(forKey:"loginStatus") as! Bool
                                        UserDefaults.standard.set(slotes[indexPath.row]["slotTime"]as! String, forKey: "slotTime")
                                        UserDefaults.standard.set(slotes[indexPath.row]["tokenNumber"], forKey: "tokenNumber")
                                        intialTime = dateAsString
                                        let dateFormatter = DateFormatter()
                                        dateFormatter.dateFormat = "HH:mm:ss"
                                        // dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                                        let date = dateFormatter.date(from: dateAsString)
                                        date24 = dateAsString
                                        dateFormatter.dateFormat = "h:mm a"
                                        let Date12 = dateFormatter.string(from: date!)
                                        timeDetails = Date12
                                        vc.modalPresentationStyle = .overCurrentContext
                                        vc.tokenNumber = "Token No:\(slotes[indexPath.row]["tokenNumber"] ?? 0)"
                                        slotData = "\(slotes[indexPath.row]["tokenNumber"] ?? 0)"
                                       
                                        timeSlot = Date12
                                        //slotData = "\(indexPath.row+1)"
                                        
                                        //        if indexPath.section == 0
                                        //        {
                                        //            slotData = "\(indexPath.row+1)"
                                        //            timeSlot = (time?[indexPath.row])!
                                        //
                                        //        }
                                        //        else if indexPath.section == 1
                                        //        {
                                        //            slotData = "\(indexPath.row+1)"
                                        //            timeSlot = (time2?[indexPath.row])!
                                        
                                        self.navigationController?.present(vc, animated: true, completion: nil)
                                    }else if Checked == 1{
                                        let alertController = UIAlertController(title: "Already booked", message: " ", preferredStyle: .alert)
                                        
                                        // Create the actions
                                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                            UIAlertAction in
                                            let vc = self.storyboard?.instantiateViewController(withIdentifier:"ChoseFriendViewController")as! ChoseFriendViewController
                                            dateDetails = self.resultDate!
                                            checkSlotTag = true
                                            choseFriends = true
                                            self.present(vc, animated: true, completion: nil)
                                            // self.navigationController?.popViewController(animated: true)
                                        }
                                        
                                        // Add the actions
                                        alertController.addAction(okAction)
                                        // Present the controller
                                        self.present(alertController, animated: true, completion: nil)
                                        
                                    }
                                    print(Checked!)
                                }
                            }
                            
                        }else{
                            Checked = 0
                        }
                        
                    }
                }
                else{
                    let vc = storyboard?.instantiateViewController(withIdentifier:"BDLoginViewController" )as! BDLoginViewController
                    logValue = 2
                    self.present(vc, animated: true, completion: nil)
                }
            }
        }
        ///navigationController?.show(vc, sender: self)
        //        let alert = UIAlertController()
        //        alert.title = "For HariPrasad"
        ////        let firstLabel = alert.label[0] as UILabel
        ////        let secondLabel = alert.label[0] as UILabel
        //        alert.message = "Token no:\(indexPath.row+1)"
        //        // add the actions (buttons)
        //        alert.addAction(UIAlertAction(title: "CHOOSE ANOTHER PATIENT", style: UIAlertActionStyle.default, handler: nil))
        //        alert.addAction(UIAlertAction(title: "BOOK", style: UIAlertActionStyle.cancel, handler: nil))
        //
        //        // show the alert
        //        self.present(alert, animated: true, completion: nil)
    }
    func time24to12(inputTime:String)->String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        // dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let date = dateFormatter.date(from: inputTime)
        dateFormatter.dateFormat = "h:mm a"
        let Date12 = dateFormatter.string(from: date!)
        return Date12
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
