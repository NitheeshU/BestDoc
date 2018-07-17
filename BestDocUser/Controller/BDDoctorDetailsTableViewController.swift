//
//  BDDoctorDetailsTableViewController.swift
//  BestDocUser
//
//  Created by nitheesh.u on 15/01/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//

import UIKit
import Alamofire
class BDDoctorDetailsTableViewController: UITableViewController,testProtocol {
    @IBOutlet weak var ratelabel: UILabel!
    @IBOutlet weak var firstView: UIView!
    
    @IBOutlet weak var recommendLabel: UILabel!
    @IBOutlet weak var fviteButton: UIButton!
    @IBOutlet weak var otherClinic: BDOtherClinics!
    
    @IBOutlet weak var docUnitData: BDDoctorinUnit!
    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    @IBOutlet weak var favouriteView: UIView!
    @IBOutlet weak var recoendview: UIView!
    @IBOutlet weak var ratingViews: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var qualificationLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var backgroundimage: UIImageView!
    
    @IBOutlet weak var feeLabel: UILabel!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var hospithalName: UILabel!
    
    @IBOutlet weak var reviewLabelCell: UITableViewCell!
    @IBOutlet weak var doctorNameLabel: UILabel!
    @IBOutlet weak var experience: UILabel!
    @IBOutlet weak var doctorNameDetailsLabel: UILabel!
    
    @IBOutlet weak var docUnitCell: UITableViewCell!
    @IBOutlet weak var clinicsCell: UITableViewCell!
    @IBOutlet weak var reviewCell: UITableViewCell!
    @IBOutlet weak var experianceView: UIView!
    var cellHeight = Float()
    var SessionArray = [NSDictionary]()
    var  docName = String()
    var attendeesArrayFromDatabase = [NSDictionary]()
    var fvtdctr:Int?
    var docUserReg :Any?
    override func viewDidLoad() {
        super.viewDidLoad()
        doctorProfile()
     otherClinic.delegateDetails = self
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        backgroundimage.addBlurEffect()
        firstView.bringSubview(toFront: profileImage)
       // let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.someAction (_:)))
        //ratingView.addGestureRecognizer(gesture)
    }
    @objc func loadList(){
        //load data here
        ratelabel.text = ratingValue
        self.tableView.reloadData()
    }
    @objc func someAction(_ sender:UITapGestureRecognizer){
        let vc = storyboard?.instantiateViewController(withIdentifier:"BDRatingViewController" )as! BDRatingViewController
        
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func fvouriteAction(_ sender: UIButton) {
        if loginStatus != false{
        sender.isSelected = !sender.isSelected
        if fvtdctr != 0 {
           
         fvite()
           
        }else{
            
           fvite()
        }
        }
    }
    
    func fvite()
    {
        var userReg:Any?
        if let data = UserDefaults.standard.object(forKey:"loginData") as? NSDictionary{
            logindictionary = data
        if let response = logindictionary["response"]as? NSDictionary{
            if let data = response["login"]as? NSDictionary
            {
                userReg = (data["userreg_id"])
                patientRegId = (data["patreg_id"])
                //ownerId = (data["userreg_id"])//
                //  mobilenumber = (data["mobile_number"])
            }}
        }else{
            
                patientRegId = UserDefaults.standard.object(forKey:"patientID") as! Int
                userRegID = UserDefaults.standard.object(forKey:"userRegID") as! Int
            }
        
        var addFvite = NSDictionary()
       // os_type:1
       // loc_user_id:3422
       // userreg_id:13331
        //pat_reg_id:10291
        //user_country_id:1
       // appuser_type:5
//patient_fav_doc_id:0
        let para = ["os_type":2,"loc_user_id":locUserId,"userreg_id":self.docUserReg,"appuser_type":5,"pat_reg_id":patientRegId,"user_country_id":1,"patient_fav_doc_id":fvtdctr]as [String : AnyObject]
        print(para)
        let progressHUD = ProgressHUD(text: "")
        self.view.addSubview(progressHUD)
        BDService.addRemove(params: para as [String : AnyObject]){(result, message, status ) in
            progressHUD.hide()
            print(message)
            print(result!)
            if status {
                let serviceDetails = result as? BDService
                addFvite = (serviceDetails?.addRemove)!
                print(addFvite)
                
                if addFvite["status"]as! Int == 1
                {
                    if let district = addFvite["response"] as? NSDictionary {
                        if let fvite = (district["patient_fav_doc_id"] as? Int){
                    //self.fvtdctr = fvite
                           // print(self.fvtdctr!)
                        }
                        if let message = (district["message"] as? String){
                            self.alert(alertmessage:message)
                        }
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
    @IBAction func likeButtonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    override func viewWillAppear(_ animated: Bool) {
        
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        profileImage.clipsToBounds = true
    }
    @IBAction func backAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func doctorProfile()
    {
        
        let progressHUD = ProgressHUD(text: "")
        self.view.addSubview(progressHUD)
        let headers = [
            "authorization": authTokens,
            "content-type": "application/x-www-form-urlencoded",
            "cache-control": "no-cache",
            "postman-token": "244aa9f2-2590-92fd-02d3-2742889ee66d"
        ]
        var userReg:Any?
        if let response = logindictionary["response"]as? NSDictionary{
            if let data = response["login"]as? NSDictionary
            {
                userReg = (data["userreg_id"])
                patientRegId = (data["patreg_id"])
                //ownerId = (data["userreg_id"])//
                //  mobilenumber = (data["mobile_number"])
            }}
        if patientRegId == nil{
            patientRegId = 0
        }
        let parameters = ["loc_user_id":locUserId,"userreg_id":userReg,"pat_reg_id":patientRegId!,"locId":locationId,"appuser_type":5] as [String : AnyObject]
        
        let namesData : NSData = NSKeyedArchiver.archivedData(withRootObject: parameters) as NSData
        do{
            let backToNames = try NSKeyedUnarchiver.unarchiveObject(with:namesData as Data) as! NSDictionary
            print(backToNames)
        }catch{
            print("Unable to successfully convert NSData to NSDictionary")
        }
        let postData = NSMutableData(data: "loc_user_id=\(locUserId!)".data(using: String.Encoding.utf8)!)
        postData.append("&userreg_id=\(docregid!)".data(using: String.Encoding.utf8)!)
        postData.append("&pat_reg_id=\(patientRegId!)".data(using: String.Encoding.utf8)!)
        postData.append("&loc_id=\(locationId!)".data(using: String.Encoding.utf8)!)
        postData.append("&appuser_type=\(appUserType)".data(using: String.Encoding.utf8)!)
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.bestdocapp.com/bestdoc_prod_v7_5_4/webresources/doctor_profile_by_patient")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request as URLRequest) { data,response,error in
            progressHUD.hide()
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    print(jsonResult)
                    if let resultData = jsonResult["response"]as? NSDictionary{
                        let doctorProfileDetails = resultData["doctor_profile"]as! NSDictionary
                        locUserId = doctorProfileDetails["loc_user_id"]!
                        self.fvtdctr = doctorProfileDetails["favourate_docid"]as? Int
//                        DispatchQueue.main.async {
//                        self.doctorNameLabel.text = doctorProfileDetails["doctor_name"]as? String
//                        }
                        if doctorProfileDetails["rating"]as? Float != 0
                        {
                            DispatchQueue.main.async {
                                self.ratelabel.text = "\(doctorProfileDetails["rating"]as? Float ?? 0 )"
                            }
                        }
                        else
                        {
                            DispatchQueue.main.async {
                                self.ratingViews.isHidden = true
                            }
                        }
                        if doctorProfileDetails["years_of_exp"]as? Float != 0
                        {
                            DispatchQueue.main.async {
                                self.experience.text = "\(doctorProfileDetails["years_of_exp"]as? Float ?? 0) Years Experience"
                            }
                        }
                        else
                        {
                            DispatchQueue.main.async {
                                self.experianceView.isHidden = true
                            }
                        }
                        DispatchQueue.main.async {
                            if doctorProfileDetails["consult_fee"]as? Float == -2
                            {
                                feeDataValue = "Fee Unavailable"
                                self.feeLabel.text = "Fee Unavailable"
                            }
                            else if doctorProfileDetails["consult_fee"]as? Float == -1
                            {
                                feeDataValue = "Free"
                                self.feeLabel.text = "Free"
                            }
                            else if doctorProfileDetails["consult_fee"]as? Float == 0
                            {
                                feeDataValue = "Free"
                                self.feeLabel.text = "Free"
                            }
                            else
                            {
                                feeDataValue = "₹\(doctorProfileDetails["consult_fee"]as? Float ?? 0)"
                                feeFlotValue = (doctorProfileDetails["consult_fee"]as? Float)!
                                self.feeLabel.text = "₹\(doctorProfileDetails["consult_fee"]as? Float ??  0) Consultation Fee"
                            }
                            
                        }
                        if doctorProfileDetails["consult_fee"]as? Float != 0
                        {
                            
                        }
                        else
                        {
                            DispatchQueue.main.async {
                                self.feeLabel.text = "Fee Unavailable"
                            }
                        }
                        if doctorProfileDetails["recommendation"]as? Float != 0
                        {
                             DispatchQueue.main.async {
                            self.recommendLabel.text = "\(doctorProfileDetails["recommendation"] ?? 0)"
                            }
                        }
                        else
                        {
                            DispatchQueue.main.async {
                                self.recoendview.isHidden = true
                            }
                        }
                        if doctorProfileDetails["favourate_docid"]as? Float != 0
                        {
                            DispatchQueue.main.async {
                            self.fviteButton.isSelected = true
                            }
                        }else if doctorProfileDetails["favourate_docid"]as? Float == 0{
                            DispatchQueue.main.async {
                            self.fviteButton.isSelected = false
                            }
                        }
                        
                        if let imageFile = (doctorProfileDetails["fileUrl"]as? String) {    // returns optional
                            self.backgroundimage.sd_setImage(with: URL(string:  imageFile), placeholderImage: UIImage(named: "ic_male"))
                            self.profileImage.sd_setImage(with: URL(string:  imageFile), placeholderImage: UIImage(named: "ic_male"))
                        }
                        else {
                              DispatchQueue.main.async {
                            self.backgroundimage.image = UIImage(named: "dzire-banner")
                            self.profileImage.image = UIImage(named: "ic_male")
                            }
                        }
                        if let reviewArray = doctorProfileDetails["review"]as?[NSDictionary]
                        {
                            print(reviewArray)
                            self.attendeesArrayFromDatabase = reviewArray
                            if self.attendeesArrayFromDatabase.count != 0
                            {
                                self.secondVC.arrayReview = self.attendeesArrayFromDatabase
                                 DispatchQueue.main.async {
                                self.secondVC.tableView.reloadData()
                                    self.tableView.reloadData()
                                }
                            }
                        }
                        else{
                            DispatchQueue.main.async {
                                self.reviewLabelCell.isHidden = true
                                self.reviewCell.isHidden = true
                                 self.cellHeight = 0
                            }
                        }
                            if let otherClinicData = doctorProfileDetails["clinics"]as?[NSDictionary]
                            {
                                print(otherClinicData)
                                
                                self.otherClinic.card = otherClinicData
                                print(self.otherClinic.card)
        
                                 DispatchQueue.main.async {
                                 self.otherClinic.reloadData()
                                }
                            }
                            else{
                                DispatchQueue.main.async {
                                    self.clinicsCell.isHidden = true
                                    self.cellHeight = 0
                                }
                            //reviewCell.heightAnchor = 0
                        }
                        if let doctorUnit = doctorProfileDetails["doctor_names"]as?[NSDictionary]
                        {
                            print(doctorUnit)
                            
                            self.docUnitData.card = doctorUnit
                            print(self.docUnitData.card)
                            
                            DispatchQueue.main.async {
                                self.docUnitData.reloadData()
                            }
                        }
                        else{
                            DispatchQueue.main.async {
                                self.docUnitCell.isHidden = true
                                self.cellHeight = 0
                            }
                            //reviewCell.heightAnchor = 0
                        }
                        self.SessionArray = doctorProfileDetails["session"]as! [NSDictionary]
                        self.docName = (doctorProfileDetails["doctor_name"]as? String)!
                        DispatchQueue.main.async {
                            self.doctorNameLabel.text = doctorProfileDetails["doctor_name"]as? String
                            self.qualificationLabel.text = doctorProfileDetails["qualification"]as? String
                            //hospithalName.text = hospitalName
                            self.doctorNameDetailsLabel.text = doctorProfileDetails["doctor_name"]as? String
                            self.addressLabel.text = doctorProfileDetails["location_name"]as? String
                           self.docUserReg = doctorProfileDetails["userreg_id"]
                            docregid = doctorProfileDetails["userreg_id"]
                            //                    self.feeLabel.text = "₹\(doctorProfileDetails["consult_fee"]as? Float ??  0) Consultation Fee"
                        }
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        dataTask.resume()
       // self.performSegue(withIdentifier: "BDReviewTableViewController",sender: self)
        self.tableView.reloadData()
        
        
    }
    
    @IBAction func checkForClinicHoursAction(_ sender: UIButton) {
        let vc  = storyboard?.instantiateViewController(withIdentifier:"BDClinicHoursViewController")as? BDClinicHoursViewController
        vc?.arrayData = SessionArray
        vc?.doctorNA = docName
        
        self.navigationController?.show(vc!, sender: self)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 6
        {
            if attendeesArrayFromDatabase.count != 0
            {
            let height:CGFloat = CGFloat(attendeesArrayFromDatabase.count * 70)
                containerHeight.constant = CGFloat(attendeesArrayFromDatabase.count * 85)
                cellHeight = Float(height)
              
            }else
            {
                cellHeight = 0
               
            }
        }
            
        else if indexPath.row == 0{
            cellHeight = 234
            
        }
        else if indexPath.row == 1{
            cellHeight = 94
            
        }
            
        else if indexPath.row == 2{
            cellHeight = 109
            
        }
        else if indexPath.row == 3{
            cellHeight = 109
        }
        else if indexPath.row == 4{
            cellHeight = 64
        }
        else if indexPath.row == 5{
            if attendeesArrayFromDatabase.count != 0
            {
            cellHeight = 50
            }else
            {
            cellHeight = 0
                
            }
            
        }
        else if indexPath.row == 7{
            if self.otherClinic.card.count != 0
            {
                let height:CGFloat = CGFloat(self.otherClinic.card.count * 90)
                //containerHeight.constant = CGFloat(self.otherClinic.card.count * 70)
                cellHeight = Float(height+30)
                
            }else
            {
                cellHeight = 0
                
            }
        }
        else if indexPath.row == 8{
            if self.docUnitData.card.count != 0
            {
                let height:CGFloat = CGFloat(self.docUnitData.card.count * 90)
                //containerHeight.constant = CGFloat(self.otherClinic.card.count * 70)
                cellHeight = Float(height+30)
                
            }else
            {
                cellHeight = 0
                
            }
        }
        return CGFloat(cellHeight)
    }
    var secondVC: BDReviewTableViewController!
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if segue.identifier == "BDReviewTableViewController"
        {
           // let vc = segue.destination as! BDReviewTableViewController
         DispatchQueue.main.async {
            
                self.secondVC = segue.destination as! BDReviewTableViewController
                self.secondVC.arrayReview = self.attendeesArrayFromDatabase
            segue.destination.view.translatesAutoresizingMaskIntoConstraints = false
                print(self.attendeesArrayFromDatabase)
            
        }
        }
    }
    func testDelegate() {
        let vc = storyboard?.instantiateViewController(withIdentifier:"BDBookingSloteViewController" )as! BDBookingSloteViewController
        vc.modalTransitionStyle = .crossDissolve
         let index  = otherClinic.indexOfRow
       // locationId =
            navigationController?.show(vc, sender: self)
        //self.present(vc, animated: true, completion: nil)
     
        
//        let accountDetailsController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddAccountIdentifer") as! AddAccountTableViewController
//        //DispatchQueue.main.asyncAfter(deadline: afer) {
//        let transition = CATransition()
//        transition.duration = 0.5
//        accountDetailsController.editmode = true
//        let realm = try?Realm()
//        let Savedaccount = realm?.objects(AccountDetailsView.self)
//        accountDetailsController.savedDetails = (Savedaccount?[index.row+1])!
//
//        navigationController?.view.layer.add(transition, forKey: nil)
//        //
//        navigationController?.pushViewController(accountDetailsController, animated: false)
        
        
    }
}
