//
//  BDAppoinMentDetailsTableViewController.swift
//  BestDocUser
//
//  Created by nitheesh.u on 11/07/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//

import UIKit

class BDAppoinMentDetailsTableViewController: UITableViewController {
    @IBOutlet weak var paymentAmountLabel: UILabel!
    @IBOutlet weak var paymentStaus: UIView!
    @IBOutlet weak var paymentStatusLabel: UILabel!
    @IBOutlet weak var recomend: UIImageView!
    @IBOutlet weak var ratingTableView: UIView!
    @IBOutlet weak var rieviewmessage: UIView!
    @IBOutlet weak var recomendTable: UITableViewCell!
    @IBOutlet weak var recommentdView: UIView!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var bookButton: UIButton!
    @IBOutlet weak var bookButtonCell: UITableViewCell!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var hospitalNameDa: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var tokenDetails: UILabel!
    @IBOutlet weak var reccomandIamge: UILabel!
    @IBOutlet weak var addRatingLabel: UILabel!
    @IBOutlet weak var paymentDetailsZCell: UITableViewCell!
    @IBOutlet weak var speciality: UILabel!
    @IBOutlet weak var docName: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var pyment: UITableViewCell!
    var bookingStatus = Int()
    var bookTag  = Bool()
    var PAYMENT_GATEWAY = 2
   var PAYMENT_COMPLETED = 3
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(appoinmentDetailsDict)
        bookingStatus = (appoinmentDetailsDict["booking_status"]as? Int)!
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.someAction (_:)))
        if let  paymentDic = appoinmentDetailsDict["payment"]as? NSDictionary{
            print(paymentDic)
            if paymentDic["payment_flag"]as? Int == 1{
                
                if paymentDic["payment_type"]as? Int == PAYMENT_GATEWAY && paymentDic["status"]as? Int == PAYMENT_COMPLETED{
                    paymentDetailsZCell.isHidden = false
                    
                    pyment.isHidden = false
                    paymentStaus.isHidden = false
                    paymentAmountLabel.isHidden = false
                    paymentStatusLabel.isHidden = false
                    paymentAmountLabel.text = "Amount: \(paymentDic["amount"] ?? 0)"
                     paymentStatusLabel.text = "Status: Payment Succeeded"
                }
                else{
                     paymentDetailsZCell.isHidden = true
                    paymentStaus.isHidden = true
                    paymentAmountLabel.isHidden = true
                    paymentStatusLabel.isHidden = true
                    pyment.isHidden = true
                }
                
            }
            else{
                 paymentDetailsZCell.isHidden = true
                paymentStaus.isHidden = true
                paymentAmountLabel.isHidden = true
                paymentStatusLabel.isHidden = true
                pyment.isHidden = true
            }
            
        }
        else{
            paymentStaus.isHidden = true
            paymentAmountLabel.isHidden = true
            paymentStatusLabel.isHidden = true
        }
        addRatingLabel.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
        ratingView.addGestureRecognizer(gesture)
        addressLabel.text = appoinmentDetailsDict["address"]as? String
        hospitalNameDa.text = appoinmentDetailsDict["location_name"]as? String
        docName.text = appoinmentDetailsDict["doctor_name"]as? String
        
        if let imageFile = (appoinmentDetailsDict["fileUrl"]as? String) {    // returns optional
           profileImage.sd_setImage(with: URL(string: imageFile), placeholderImage: UIImage(named: "ic_male"))
        }
        else {
           profileImage.image =  UIImage(named: "ic_male")
            // user did not have key "name"
            // here would be the place to return "default"
            // or do any other error correction if the key did not exist
        }
        var string1 = String()
        var string2 = String()
        var string3 = String()
        if let time = (appoinmentDetailsDict["time_slot"]as?String){
            let dateAsString = time
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss"
            // dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            let date = dateFormatter.date(from: dateAsString)
            dateFormatter.dateFormat = "h:mm a"
            let Date12 = dateFormatter.string(from: date!)
            print(Date12)
            string2 =  "at\(Date12)"
        }
        else{
            string2 = ","
        }
        if let dateData = (appoinmentDetailsDict["booking_date"]as? String)
        {
            let dateValueAsString = dateData
            let formatter2 = DateFormatter()
            formatter2.dateFormat =  "yyyy-MM-dd"
            let intialDate = formatter2.date(from: dateValueAsString)
            let dateFormatterdate = DateFormatter()
            dateFormatterdate.dateFormat = "EEEE,dd MMM yyyy"
            let finalDate = dateFormatterdate.string(from: intialDate!)
            print(finalDate)
            string1 = finalDate
        }
        else{
            string1 = ""
        }
        if (appoinmentDetailsDict["slot_no"]as!Int) != nil{
            string3 = ",Token\(appoinmentDetailsDict["slot_no"]as!Int)"
        }
        else{
            string3 = ""
        }
        //        let dateAsString = time
        //        let dateFormatter = DateFormatter()
        //        dateFormatter.dateFormat = "HH:mm:ss"
        //        // dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        //        let date = dateFormatter.date(from: dateAsString)
        //        dateFormatter.dateFormat = "h:mm a"
        //        let Date12 = dateFormatter.string(from: date!)
        //        print(Date12)
        
        
        
        tokenDetails.text = string1+string2+string3
        if let specialityD = appoinmentDetailsDict["speciality"]as? String{
            
            speciality.text = specialityD
        }
         let staus = bookingStatus
            
            statusLabel.text = statusCode(x: staus)
            statusLabel.layer.borderWidth = 1
            statusLabel.layer.borderColor = UIColor(rgb:statusColor(x: staus)).cgColor
           statusLabel.textColor = UIColor(rgb:statusColor(x: staus))
        
        if appoinmentDetailsDict["hms_intgrtion_status"]as?Int == 1{
            bookButtonCell.isHidden = true
           // bookButton.setTitle("BOOK AGAIN", for: .normal)
            
        }
        if appoinmentDetailsDict["booking_status"]as! Int  != 3{
            ratingTableView.isHidden = true
            rieviewmessage.isHidden = true
           // recomendTable.isHidden = true
           // recomendTable.frame.height = 0
        }
        else{
            rating()
             rieviewmessage.isHidden = false
          ratingTableView.isHidden = false
        }
        //if bookingStatus  != 5{
            
          //  bookButton.setTitle("Cancel Appoinments", for: .normal)
          //  bookTag = false
            
      //  }else
          //  if bookingStatus != 6{
                
        //}
       // else{
            bookButton.setTitle("BOOK AGAIN", for: .normal)
            bookTag = true
       // }
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    func callNumber(phoneNumber:String) {
        
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    func rating()
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
       // os_type:1
      //  patRegId:21529
       // user_country_id:1
       // userRegId:3458
        //appuser_type:5
        let dateTimeD = "\(appoinmentDetailsDict["booking_date"]as! String)"
        var resetCalDic = NSDictionary()
        let para = ["os_type":2,"appuser_type":5,"user_country_id":countryId,"userRegId":(appoinmentDetailsDict["doc_user_reg_id"]as?Int)!,"patRegId":(appoinmentDetailsDict["pat_reg_id"]as?Int)!] as [String : AnyObject]
        print(para)
        let progressHUD = ProgressHUD(text: "")
        self.view.addSubview(progressHUD)
        BDService.showRating(params: para as [String : AnyObject]){(result, message, status ) in
            progressHUD.hide()
            print(message as Any)
            print(result!)
            if status {
                let serviceDetails = result as? BDService
                resetCalDic = (serviceDetails?.viewRating)!
                print(resetCalDic)
                if resetCalDic["status"]as! Int == 1
                {
                    if let response =  resetCalDic["response"]as? NSDictionary{
                        if let rateData = response["rating"]{
                        self.addRatingLabel.text = "\(rateData)"
                        }else{
                             self.addRatingLabel.text = "1"
                        }
                        if let recommand = response["recommendation"]{
                            if recommand as!Int == 1{
                             self.recomend.image = UIImage(named: "like")
                            }else{
                                self.recomend.image = UIImage(named: "likeClear")
                            }
                        }
                    }
                    //self.alert(alertmessage:"success")
                    
                    
                }else{
                    self.alert(alertmessage:  (resetCalDic["error_msg"]as? String)!)
                }
                
            }
        }
        // }
    }
    override func viewWillAppear(_ animated: Bool) {
        
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        profileImage.clipsToBounds = true
    }
    @IBAction func shareAction(_ sender: Any) {
        "BestDoc".share()
    }
    
    @IBAction func clAction(_ sender: UIButton) {
        callNumber(phoneNumber:"9020602222")
    }
    @IBAction func docReviewAction(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "BDReviewDocViewController")as! BDReviewDocViewController
        navigationController?.show(vc, sender: self)
    }
    @IBAction func recommended(_ sender: UIButton) {
       // sender.isSelected = !sender.isSelected
        recomend(recommandation:"true")
    }
    @IBAction func ratingAction(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier:"BDRatingViewController" )as! BDRatingViewController
        
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    @objc func loadList(){
        //load data here
        addRatingLabel.text = ratingValue
        self.tableView.reloadData()
    }
    @objc func someAction(_ sender:UITapGestureRecognizer){
        let vc = storyboard?.instantiateViewController(withIdentifier:"BDRatingViewController" )as! BDRatingViewController
        
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    func statusCode(x:Int)->String{
        var dataString = String()
        switch (x) {
            
        case 1:
            dataString =  "Confirmed"
            bookButton.setTitle("BOOK AGAIN", for: .normal)
            bookTag = true
            
        case 2:
            dataString = "Initiated"
            bookButton.setTitle("BOOK AGAIN", for: .normal)
            bookTag = true
            
        case 3:
            dataString = "Visited"
            bookButton.setTitle("BOOK AGAIN", for: .normal)
            bookTag = true
            
        case 4:
            dataString = "Checked in"
            bookButton.setTitle("BOOK AGAIN", for: .normal)
            bookTag = true
            
        case 5:
            dataString = "Cancelled"
            bookButton.setTitle("Cancel Appoinments", for: .normal)
            bookTag = false
            
        case 6:
            dataString = "Deleted"
            bookButton.setTitle("Cancel Appoinments", for: .normal)
            bookTag = false
            
        case 7:
            dataString = "fake booking cancel"
            
        case 8:
            dataString = "cancelled for another booking"
            
            
        default:
            print("invalid")
        }
        return dataString
    }
    func statusColor(x:Int)->Int{
        var dataString = Int()
        switch (x) {
            
        case 1:
            dataString =  0x00a79d
            
        case 2:
            dataString = 0xb3b3b3
            
        case 3:
            dataString = 0x00a79d
            
        case 4:
            dataString = 0x8C0000
            
        case 5:
            dataString = 0xE57373
            
        case 6:
            dataString = 0xE57373
            
        case 7:
            dataString = 0xE57373
            
        case 8:
            dataString = 0xE57373
            
            
        default:
            print("invalid")
        }
        return dataString
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func bookAction(_ sender: UIButton) {
        if bookTag == true{
            doctorName = (appoinmentDetailsDict["doctor_name"] as! String)
            hospitalName = (appoinmentDetailsDict["location_name"] as! String)
            //  doctorImageData = arrFilterData[indexPath.row]["fileUrl"]as! String
            locUserId = (appoinmentDetailsDict["loc_user_id"])
            docregid = (appoinmentDetailsDict["doc_user_reg_id"])!
            // patRegID = arrFilterData[indexPath.row]["userreg_id"]
           // locationId = (appoinmentDetailsDict["locid"])!
            // Slotlist()
            if appoinmentDetailsDict["consultationfee"]as? Float == -2
            {
                feeDataValue = " Fee Unavailable"
            }
            else if appoinmentDetailsDict["consultationfee"]as? Float == -1
            {
                feeDataValue = "Free"
            }
            else if appoinmentDetailsDict["consultationfee"]as? Float == 0
            {
                feeDataValue = "Free"
            }
            else
            {
                feeDataValue = "₹\(appoinmentDetailsDict["consultationfee"]as? Float ?? 0)"
                feeFlotValue = (appoinmentDetailsDict["consultationfee"]as? Float)!
            }
            
            let next = storyboard?.instantiateViewController(withIdentifier: "BDBookingSloteViewController") as! BDBookingSloteViewController
            
            self.navigationController?.show(next,sender:self)
        }else if bookTag == false{
           cancelbooking()
        }
    }
//    func cancelbooking()
//    {
//        //sectn_slot:37
//       // booktime:13:00:00
//       // booked_date:2018-07-10
//        //appuser_type:5
//      //  booking_id:39780
//      //  user_country_id:1
//       // locuser_id:1913
//       // booking_status:5
//      //  userreg_id:12317
//       // pat_reg_id:21529
//        //os_type:1
//    }
        func cancelbooking()
        {
            if let response = logindictionary["response"]as? NSDictionary{
                if let data = response["login"]as? NSDictionary
                {
                    userRegID = (data["userreg_id"])
                    //ownerId = (data["userreg_id"])//print(data["patreg_id"]!)
                   // mobilenumber = (data["mobile_number"])
                }
            }
          //  if let encodedPassword = newpasswordText.text?.sha512()
           // {
               // var myUrlString:String = encodedPassword
               // myUrlString = myUrlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlUserAllowed)!
               // print("base64Encoded  ",myUrlString)
               // let urlSet =  CharacterSet(charactersIn: ";/?:@&=+$, ").inverted
               // let finalPassword = //myUrlString.addingPercentEncoding(withAllowedCharacters: urlSet)!
                var resetCalDic = NSDictionary()
            let para = ["os_type":2,"appuser_type":5,"user_country_id":countryId,"sectn_slot":appoinmentDetailsDict["slot_no"]as!Int,"booktime":(appoinmentDetailsDict["time_slot"]as?String)!,"booked_date":(appoinmentDetailsDict["booking_date"]as? String)!,"booking_id":(appoinmentDetailsDict["book_id"]as?Int)!,"locuser_id":(appoinmentDetailsDict["loc_user_id"]as?Int)!,"booking_status":(appoinmentDetailsDict["booking_status"]as?Int)!,"userreg_id":(appoinmentDetailsDict["doc_user_reg_id"]as?Int)!,"pat_reg_id":(appoinmentDetailsDict["pat_reg_id"]as?Int)!] as [String : AnyObject]
                print(para)
                let progressHUD = ProgressHUD(text: "")
                self.view.addSubview(progressHUD)
                BDService.cancelBooking(params: para as [String : AnyObject]){(result, message, status ) in
                    progressHUD.hide()
                    print(message as Any)
                    print(result!)
                    if status {
                        let serviceDetails = result as? BDService
                        resetCalDic = (serviceDetails?.cancelBooking)!
                        print(resetCalDic)
                        if resetCalDic["status"]as! Int == 1
                        {
                            self.bookButton.setTitle("BOOK AGAIN", for: .normal)
                            self.bookTag = true
                            self.bookingStatus = 5
                            let staus = self.bookingStatus
                            
                            self.statusLabel.text = self.statusCode(x: staus)
                            self.statusLabel.layer.borderWidth = 1
                            self.statusLabel.layer.borderColor = UIColor(rgb:self.statusColor(x: staus)).cgColor
                            self.statusLabel.textColor = UIColor(rgb:self.statusColor(x: staus))
                            self.tableView.reloadData()
                               self.alert(alertmessage: (resetCalDic["msg"]as? String)!)
                        }else{
                            self.alert(alertmessage: (resetCalDic["error_msg"]as? String)!)
                        }
                    }
                }
           // }
        }
    func recomend(recommandation:String)
    {
        if let response = logindictionary["response"]as? NSDictionary{
            if let data = response["login"]as? NSDictionary
            {
                userRegID = (data["userreg_id"])
                //ownerId = (data["userreg_id"])//print(data["patreg_id"]!)
                // mobilenumber = (data["mobile_number"])
            }
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
        let para = ["os_type":2,"appuser_type":5,"user_country_id":countryId,"ratingRecommendationDate":dateTimeD,"userRegId":(appoinmentDetailsDict["doc_user_reg_id"]as?Int)!,"patRegId":(appoinmentDetailsDict["pat_reg_id"]as?Int)!,"friendsAndFamilyFlag":"false","recommendation":recommandation,"ratingRecommendationFlag":1,"rating": self.addRatingLabel.text!,"friendsAndFamilyId":(appoinmentDetailsDict["pat_reg_id"]as?Int)!] as [String : AnyObject]
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
                    self.recomend.image = UIImage(named: "like")
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
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

                }
