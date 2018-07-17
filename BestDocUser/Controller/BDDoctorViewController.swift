//
//  BDDoctorViewController.swift
//  BestDocUser
//
//  Created by nitheesh.u on 12/01/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//

import UIKit
import MapKit
import SDWebImage
class BDDoctorViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,YourCellDelegate,UISearchBarDelegate {
    
    @IBOutlet weak var filterHeight: NSLayoutConstraint!
    @IBOutlet weak var docheightConstarint: NSLayoutConstraint!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var filterView: UIView!
    
    @IBOutlet weak var doctorList: UITableView!
    var hospitalN = [String]()
    var hospitalNames = [String]()
    var locationNames = [String]()
    var distance = [String]()
    var menuIcons = [UIImage]()
     var exp = [String]()
    var fee = [String]()
    var speciality = [String]()
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
   // var lat = Double()
   // var log = Double()
    var arrFilterData : [NSDictionary] = []
    var isSearch : Bool!
    var clinicArray = [NSDictionary]()
    var pageNumber = 0
    var isDataLoading:Bool=false
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        isSearch = false
        filterHeight.constant = 0
        if segment == true
        {
            docheightConstarint.constant = 60
        }else{
            docheightConstarint.constant = 0
        }
        //docheightConstarint.constant = 0
        hospitalN = ["Amala Institute Of Medical Science","Daya General Hospital", "CAM Hospital","Craft Hospital& Research Centre"]
        hospitalNames = ["Dr.Abdul Khadar.S","Dr.Balu Mohan","Dr.K.R.Sreenath","Dr.Roy Varghese"]
        menuIcons = [UIImage(named: "Abdul Khader")!,UIImage(named: "Balu Mohan")!,UIImage(named: "sreenath")!,UIImage(named: "Roy Varghese")!]
        locationNames = ["cliniclocation1","cliniclocation2","cliniclocation3","cliniclocation4","cliniclocation5","clinclocation6"]
        distance = ["~14.5kms","~4.5kms","~5.5kms","~9.87Kms"]
        exp = ["32 yrs exp .","12 yrs exp .","2 yrs exp .","23 yrs exp ."]
        fee = ["₹400 .","₹500 .","₹200 .","₹300 ."]
        speciality = ["Cardiology","Cardiology","Dermatology","ENT"]
        doctorlist()
        doctorList.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("scrollViewWillBeginDragging")
        isDataLoading = false
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
    }
    override func viewWillAppear(_ animated: Bool) {
       
    }
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
         //doctorlist()
    }
    @objc func loadList(){
        arrFilterData.removeAll()
        doctorlist()
        //load data here
       
    }
    @IBAction func backAction(_ sender: UIButton) {
         segment = false
        navigationController?.popViewController(animated: true)
    }
    func didTapButton(_ sender: UIButton) {
        if let indexPath = getCurrentCellIndexPath(sender) {
            print(indexPath)
            doctorName = arrFilterData[indexPath.row]["doctor_name"] as! String
            hospitalName = arrFilterData[indexPath.row]["location_name"] as! String
          //  doctorImageData = arrFilterData[indexPath.row]["fileUrl"]as! String
            locUserId = (arrFilterData[indexPath.row]["loc_user_id"])
            docregid = (arrFilterData[indexPath.row]["userreg_id"])!
            // patRegID = arrFilterData[indexPath.row]["userreg_id"]
            locationId = (arrFilterData[indexPath.row]["locid"])!
           // Slotlist()
            if arrFilterData[indexPath.row]["consult_fee"]as? Float == -2
            {
                feeDataValue = " Fee Unavailable"
            }
            else if arrFilterData[indexPath.row]["consult_fee"]as? Float == -1
            {
                feeDataValue = "Free"
            }
            else if arrFilterData[indexPath.row]["consult_fee"]as? Float == 0
            {
                feeDataValue = "Free"
            }
            else
            {
                feeDataValue = "₹\(arrFilterData[indexPath.row]["consult_fee"]as? Float ?? 0)"
                feeFlotValue = (arrFilterData[indexPath.row]["consult_fee"]as? Float)!
            }
            
            let next = storyboard?.instantiateViewController(withIdentifier: "BDBookingSloteViewController") as! BDBookingSloteViewController
            
            self.navigationController?.show(next,sender:self)
        }
    }
    func didTapButtonCall(_ sender: UIButton) {
    if let indexPath = getCurrentCellIndexPath(sender) {
        print(indexPath)
        let phoneNumber = "9020602222"
        print(phoneNumber)
        if let url = URL(string: "tel://\(phoneNumber )") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    }
//        func Slotlist()
//        {
//            var slotList = NSDictionary()
//
//            let para = ["date":"2018-03-14","locUserId":2209,"appuser_type":5] as [String : AnyObject]
//            print(para)
//            let progressHUD = ProgressHUD(text: "")
//            self.view.addSubview(progressHUD)
//            BDService.viewSession(params: para as [String : AnyObject]){(result, message, status ) in
//                progressHUD.hide()
//                print(result!)
//                if status {
//                    let serviceDetails = result as? BDService
//                    slotList = (serviceDetails?.sessionDic)!
//                     print(slotList)
//                    print(slotList["response"] as Any)
////                    if let resposeDa:NSDictionary = slotList["response"]as? NSDictionary
////                    {
////                        let clinicprof:NSDictionary = (resposeDa["clinic_profile"]as? NSDictionary)!
////                       // clinicDepartmentArray =  (clinicprof["departmentList"]as?[NSDictionary])!
////                       // print(clinicDepartmentArray)
////                        let vc = self.storyboard?.instantiateViewController(withIdentifier:"BDClinicDetailsViewController" )as! BDClinicDetailsViewController
////                       // hospitalData = (self.clinicArray[indexPath.row]["location_name"]as? String)!
////                        var imageview : UIImageView?
////                      //  imageview?.sd_setImage(with: URL(string:  (self.arrFilterData[indexPath.row]["fileUrl"]as? String)!), placeholderImage: UIImage(named: "ic_hospital"))
////                      //  clinicDetails =  (self.arrFilterData[indexPath.row])
////                        print(clinicDetails)
////                      //  if let hosImg = (self.arrFilterData[indexPath.row]["fileUrl"]as? String){
//////
//////                            hospitalImage = hosImg
//////
//////                        }
//////                        else
////                        {
////
////                        }
//                      //  self.navigationController?.show(vc, sender:self)
//                    }
//
//                    //  clinicDepartmentArray = (clinicDepartmentDic["departmentList"]as![NSDictionary])
//                    // print(clinicDepartmentArray)
//
//                }
//            }
//
    
    
    func doctorlist()
    {
        //let locManager = CLLocationManager()
        var currentLocation: CLLocation!
        var lat = Double()
        var log = Double()
        print(districtId)
        print(regionId)
        print(specialityId)
        locManager.delegate = locationDelegate
        locManager.requestWhenInUseAuthorization()
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            currentLocation = locManager.location
            lat = currentLocation.coordinate.latitude
            log = currentLocation.coordinate.longitude
            print(currentLocation.coordinate.latitude)
            print(currentLocation.coordinate.longitude)
        }
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: date)
        print(result)
        var docArray = [NSDictionary]()
        var regionDic = NSDictionary()
        //  let para = ["mylongitude":log,"appuser_type":5,"loc_type_id":2,"longitude":log,"index_to":0,"district_id":districtId,"filterflag":0,"city_loc_pin_id":-1,"mylatitude":lat,"regionId":regionId,"latitude":lat, "specialityId":specialityId,"clinicname":"","kilometer":25] as [String : AnyObject]
        let para = ["mylongitude":log,"available_date":result,"end_time":endTime,"longitude":log,"start_time":startTime,"index_to":pageNumber,"district_id":districtId,"sort_by":SelectedSort,"radius":"25","city_loc_pin_id":"-1","speciality_id":specialityId,"regionId":regionId,"mylatitude":lat,"search_text":"","latitude":lat,"consult_fee_from":feeMin,"sex":genderDataID,"consult_fee_to":feeMax,"appuser_type":5,"sort_order":"1"]as[String:AnyObject]
        print(para)
        let progressHUD = ProgressHUD(text: "")
        self.view.addSubview(progressHUD)
        BDService.getDoctor(params: para as [String : AnyObject]){(result, message, status ) in
            progressHUD.hide()
            print(result!)
            if status {
                let serviceDetails = result as? BDService
                regionDic = (serviceDetails?.doctor)!
                print(regionDic)
                if regionDic["status"]as! Int == 1
                {
                    // let vc = self.storyboard?.instantiateViewController(withIdentifier:"BDSelectLocalityViewController" )as!
                    //    BDSelectLocalityViewController
                    if let district = regionDic["response"] as? NSDictionary {
                        self.clinicArray =  (district["doctors"]as? [NSDictionary])!
                        print(self.clinicArray)
                        self.arrFilterData = self.arrFilterData+self.clinicArray
                         print(self.arrFilterData)
                    }
                
                    
                    self.doctorList.delegate = self
                    self.doctorList.dataSource = self
                    self.doctorList.reloadData()
//                    self.clinicsDetails.delegate = self
//                    self.clinicsDetails.dataSource = self
//                    self.clinicsDetails.reloadData()
                    //                       // vc.data = districtName
                    //                     //   vc.menuNames = regionArray
                    //                      //  self.navigationController?.show(vc, sender: self)
                    //                    }
                }
                
            }
        }
    
    }
    
    func getCurrentCellIndexPath(_ sender: UIButton) -> IndexPath? {
        let buttonPosition = (sender as AnyObject).convert(CGPoint.zero, to: self.doctorList)
        // sender.convert(CGPoint.zero, to: tableView)
        if let indexPath: IndexPath = doctorList.indexPathForRow(at: buttonPosition) {
            return indexPath
        }
        return nil
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return arrFilterData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BBDoctorTableViewCell", for: indexPath) as! BBDoctorTableViewCell
        cell.experinceLabel.adjustsFontSizeToFitWidth = true
        cell.distanceLabel.adjustsFontSizeToFitWidth = true
        cell.feeLabel.adjustsFontSizeToFitWidth = true
        cell.doctorName.text = arrFilterData[indexPath.row]["doctor_name"]as? String
        if arrFilterData[indexPath.row]["distance"]!as! NSNumber != 0
        {
            let roundedKm = (arrFilterData[indexPath.row]["distance"]as! Double).rounded(toPlaces: 2)
            cell.distanceLabel.text = "~\(roundedKm)Km"
        }
        else
        {
           cell.distanceLabel.isHidden = true
        }
        cell.doctorSpecialty.text = arrFilterData[indexPath.row]["speciality"]as? String
        
        cell.experinceLabel.text = "\(arrFilterData[indexPath.row]["years_of_exp"]as? Float ?? 0)yrs exp"
        if arrFilterData[indexPath.row]["consult_fee"]as? Float == -2
        {
        cell.feeLabel.text = "Fee Unavailable"
        }
        else if arrFilterData[indexPath.row]["consult_fee"]as? Float == -1
        {
            cell.feeLabel.text = "Free"
        }
        else if arrFilterData[indexPath.row]["consult_fee"]as? Float == 0
        {
            cell.feeLabel.text = "Free"
        }
        else
        {
          cell.feeLabel.text = "₹\(arrFilterData[indexPath.row]["consult_fee"]as? Float ?? 0)"
        }
       
        cell.HosptalName.text = arrFilterData[indexPath.row]["location_name"]as? String
        if let imageFile = (arrFilterData[indexPath.row]["fileUrl"]as? String) {    // returns optional
            cell.doctorIcon.sd_setImage(with: URL(string: imageFile), placeholderImage: UIImage(named: "ic_male"))
        }
        else {
            cell.doctorIcon.image =  UIImage(named: "ic_male")
            // user did not have key "name"
            // here would be the place to return "default"
            // or do any other error correction if the key did not exist
        }
       
       
        cell.cellDelegate = self
         return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier:"BDDoctorDetailsViewController" )as! BDDoctorDetailsViewController
        doctorName = arrFilterData[indexPath.row]["doctor_name"] as? String
        hospitalName = arrFilterData[indexPath.row]["location_name"] as? String
       // appUserType = (arrFilterData[indexPath.row]["appUserType"])
        locUserId = (arrFilterData[indexPath.row]["loc_user_id"])
        docregid = (arrFilterData[indexPath.row]["userreg_id"])!
        // patRegID = arrFilterData[indexPath.row]["userreg_id"]
        locationId = (arrFilterData[indexPath.row]["locid"])!
        //feeDataValue = arrFilterData[indexPath.row]["consult_fee"]as? Float ?? 0
        //doctorDetails = arrFilterData[indexPath.row]
       // doctorName = hospitalNames[indexPath.row]
       // hospitalName = hospitalN[indexPath.row]
       // doctorImageData = menuIcons[indexPath.row]
        navigationController?.show(vc, sender:self)
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        // When user has entered text into the search box
        // Use the filter method to iterate over all items in the data array
        // For each item, return true if the item should be included and false if the
        // item should NOT be included
        arrFilterData = (searchText.isEmpty ? clinicArray : clinicArray.filter({(dataString: NSDictionary) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return (dataString["doctor_name"] as! String).range(of: searchText, options: .caseInsensitive) != nil
        }))
        
        self.doctorList.reloadData()
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let lastElement = arrFilterData.count - 1
//        if !isDataLoading && indexPath.row == lastElement {
//            isDataLoading = true
//            pageNumber = pageNumber+1
//
//        }
        
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 {
            pageNumber = pageNumber+1
            if clinicArray.count != 0{
            self.doctorlist()
            }
        }
        if targetContentOffset.pointee.y < scrollView.contentOffset.y {
            // it's going up
            UIView.animate(withDuration: 0.5, animations: { // 3.0 are the seconds
                self.filterHeight.constant = 70
                // Write your code here for e.g. Increasing any Subviews height.
                
                self.view.layoutIfNeeded()
                
            })
            
        } else {
            UIView.animate(withDuration: 0.5, animations: { // 3.0 are the seconds
                self.filterHeight.constant = 0
                // Write your code here for e.g. Increasing any Subviews height.
                
                self.view.layoutIfNeeded()
                
            })
                       // it's going down
        }
        
    }
    @IBAction func filterButtonAction(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier:"BDFilterViewController" )as! BDFilterViewController
        
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
        
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
