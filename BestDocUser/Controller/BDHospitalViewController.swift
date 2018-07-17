//
//  BDHospitalViewController.swift
//  BestDocUser
//
//  Created by nitheesh.u on 12/01/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//
import Foundation
import UIKit
import MapKit
import SDWebImage
class BDHospitalViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    var arrFilterData : [NSDictionary] = []
    var isSearch : Bool!
    var hospitalNames = [String]()
    var locationNames = [String]()
    var distance = [String]()
    var menuIcons = [UIImage]()
     var menuNames =  [NSDictionary]()
      var clinicArray = [NSDictionary]()
//    var locManager = CLLocationManager()
//    var currentLocation: CLLocation!
//    var lat = Double()
//    var log = Double()
    @IBOutlet weak var hospitalDetails: UITableView!
    
    @IBOutlet weak var hospitalSearch: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var hospitalheight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        isSearch = false
        if segment == true
        {
            hospitalSearch.layer.shadowOffset = CGSize(width: 0, height: 3)
            hospitalSearch.layer.shadowOpacity = 0.6
            hospitalSearch.layer.shadowRadius = 3.0
            hospitalSearch.layer.shadowColor = UIColor.darkGray.cgColor
           // setShadow(shadowView: hospitalSearch, opacity: 0.5, radius: 5)
           // hospitalSearch.dropShadow()
        hospitalheight.constant = 75
        }else{
        hospitalheight.constant = 0
        }
//        locManager.requestWhenInUseAuthorization()
//            if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
//                CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
//        currentLocation = locManager.location
//
//        lat = currentLocation.coordinate.latitude
//        log = currentLocation.coordinate.longitude
//        print(currentLocation.coordinate.latitude)
//        print(currentLocation.coordinate.longitude)
//         }
       // if lat != 0
       // {
          //  cliniclist()
       // }
        hospitalNames = ["Amala Institute of Medical Science","CAM Hospital","Daya General Hospital","Craft Hospital & Research Centre"]
        menuIcons = [UIImage(named: "amala")!,UIImage(named: "CAM")!,UIImage(named: "DAYA")!,UIImage(named: "CRAFT")!]
        locationNames = ["Thrissur,Kerala","Thrissur,Kerala","Thrissur,Kerala","Thrissur,Kerala"]
        distance = ["~4.5km","~5.5km","~6.5km","~7.5km"]
        hospitalDetails.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        cliniclist()
    }
    func cliniclist()
    {
        print(districtId)
        print(regionId)
        print(specialityId)
        
        let locManager = CLLocationManager()
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
        var regionDic = NSDictionary()
        //  let para = ["mylongitude":log,"appuser_type":5,"loc_type_id":2,"longitude":log,"index_to":0,"district_id":districtId,"filterflag":0,"city_loc_pin_id":-1,"mylatitude":lat,"regionId":regionId,"latitude":lat, "specialityId":specialityId,"clinicname":"","kilometer":25] as [String : AnyObject]
        let para = ["mylongitude":log,"loc_type_id":1,"longitude":log,"index_to":0,"district_id":districtId,"filterflag":0,"city_loc_pin_id":-1,"mylatitude":lat,"regionId":regionId,"latitude":lat,"specialityId":specialityId,"clinicname":"","appuser_type":5,"kilometer":25] as [String : AnyObject]
        print(para)
        let progressHUD = ProgressHUD(text: "")
        self.view.addSubview(progressHUD)
        BDService.getClinic(params: para as [String : AnyObject]){(result, message, status ) in
            progressHUD.hide()
            print(result!)
            if status {
                let serviceDetails = result as? BDService
                regionDic = (serviceDetails?.clinic)!
                print(regionDic)
                if regionDic["status"]as! Int == 1
                {
                    // let vc = self.storyboard?.instantiateViewController(withIdentifier:"BDSelectLocalityViewController" )as!
                    //    BDSelectLocalityViewController
                    if let district = regionDic["response"] as? NSDictionary {
                        self.clinicArray =  (district["clinic search"]as? [NSDictionary])!
                        print(self.clinicArray)
                        self.arrFilterData = self.clinicArray
                    }
                    self.hospitalDetails.delegate = self
                    self.hospitalDetails.dataSource = self
                    self.hospitalDetails.reloadData()
                    //                       // vc.data = districtName
                    //                     //   vc.menuNames = regionArray
                    //                      //  self.navigationController?.show(vc, sender: self)
                    //                    }
                }
                
            }
        }
    }
    func setShadow(shadowView: UIView, opacity: Float,radius:CGFloat)
    {
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = opacity
        shadowView.layer.shadowOffset = CGSize.zero
        shadowView.layer.shadowRadius = radius
    }
    @IBAction func backButton(_ sender: UIButton) {
        segment = false
    navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrFilterData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BDHospitalsTableViewCell", for: indexPath) as! BDHospitalsTableViewCell
        cell.distance.adjustsFontSizeToFitWidth = true
        cell.hospitalName.text = arrFilterData[indexPath.row]["location_name"]as? String
        if let imageFile = (arrFilterData[indexPath.row]["fileUrl"]as? String) {    // returns optional
            cell.hospitalimageView?.sd_setImage(with: URL(string: imageFile), placeholderImage: UIImage(named: "ic_hospital"))
        }
        else {
            cell.hospitalimageView?.image =  UIImage(named: "ic_hospital")
            // user did not have key "name"
            // here would be the place to return "default"
            // or do any other error correction if the key did not exist
        }
        //cell.hospitalimageView?.sd_setImage(with: URL(string:  (arrFilterData[indexPath.row]["fileUrl"]as? String)!), placeholderImage: UIImage(named: "ic_hospital"))
        cell.locatioName.text = arrFilterData[indexPath.row]["address"]as? String
        if arrFilterData[indexPath.row]["distance"]as! Double  != 0 {
            let roundedKm = (arrFilterData[indexPath.row]["distance"]as! Double).rounded(toPlaces: 2)
            cell.distance.text = "~\(roundedKm )Km"
        }
        else
        {
       cell.distance.isHidden = true
        }
        return cell
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        var clinicDepartmentDic = NSDictionary()
        locationId = arrFilterData[indexPath.row]["loc_id"]
        userRegID = (arrFilterData[indexPath.row]["clinic_userregid"])
        let para = ["locId":locationId,"appuser_type":appUserType] as [String : AnyObject]
        print(para)
        let progressHUD = ProgressHUD(text: "")
        self.view.addSubview(progressHUD)
        BDService.getdepartment(params: para as [String : AnyObject]){(result, message, status ) in
            progressHUD.hide()
            print(result!)
            if status {
                let serviceDetails = result as? BDService
                clinicDepartmentDic = (serviceDetails?.clinicDepDetailsDic)!
                print(clinicDepartmentDic)
                print(clinicDepartmentDic["response"] as Any)
                if let resposeDa:NSDictionary = clinicDepartmentDic["response"]as? NSDictionary
                {
                    let clinicprof:NSDictionary = (resposeDa["clinic_profile"]as? NSDictionary)!
                    clinicDepartmentArray =  (clinicprof["departmentList"]as?[NSDictionary])!
                    print(clinicDepartmentArray)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier:"BDClinicDetailsViewController" )as! BDClinicDetailsViewController
                    hospitalData = (self.clinicArray[indexPath.row]["location_name"]as? String)!
                    var imageview : UIImageView?
                    imageview?.sd_setImage(with: URL(string:  (self.arrFilterData[indexPath.row]["fileUrl"]as? String)!), placeholderImage: UIImage(named: "ic_hospital"))
                    clinicDetails =  (self.arrFilterData[indexPath.row])
                    print(clinicDetails)
                    if let hosImg = (self.arrFilterData[indexPath.row]["fileUrl"]as? String){
                        
                        hospitalImage = hosImg
                        
                    }
                    else
                    {
                        
                    }
                    self.navigationController?.show(vc, sender:self)
                }
                
                //  clinicDepartmentArray = (clinicDepartmentDic["departmentList"]as![NSDictionary])
                // print(clinicDepartmentArray)
                
            }
        }
        
    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//
////        let vc = storyboard?.instantiateViewController(withIdentifier:"BDClinicDetailsViewController" )as! BDClinicDetailsViewController
////        hospitalData = (clinicArray[indexPath.row]["location_name"]as? String)!
////        clinicDetails =  (arrFilterData[indexPath.row])
////
////        hospitalImage = arrFilterData[indexPath.row]["fileUrl"]as? String!
////
////      //  hospitalImage = menuIcons[indexPath.row]
////        navigationController?.show(vc, sender:self)
//    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        // When user has entered text into the search box
        // Use the filter method to iterate over all items in the data array
        // For each item, return true if the item should be included and false if the
        // item should NOT be included
        arrFilterData = (searchText.isEmpty ? clinicArray : clinicArray.filter({(dataString: NSDictionary) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return (dataString["location_name"] as! String).range(of: searchText, options: .caseInsensitive) != nil
        }))
        
        self.hospitalDetails.reloadData()
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
extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
