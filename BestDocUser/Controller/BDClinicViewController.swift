//
//  BDClinicViewController.swift
//  BestDocUser
//
//  Created by nitheesh.u on 12/01/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//

import UIKit
import MapKit
import SDWebImage
class BDClinicViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    @IBOutlet weak var clinicSearch: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var viewheightConstarint: NSLayoutConstraint!
    var hospitalNames = [String]()
    var locationNames = [String]()
    var distance = [String]()
    var menuIcons = [UIImage]()
    //    var locManager = CLLocationManager()
    //    var currentLocation: CLLocation!
    // var lat = Double()
    //var log = Double()
    var arrFilterData : [NSDictionary] = []
    var isSearch : Bool!
    var clinicArray = [NSDictionary]()
    @IBOutlet weak var clinicsDetails: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        isSearch = false
        if segment == true
        {
            clinicSearch.layer.shadowOffset = CGSize(width: 0, height: 3)
            clinicSearch.layer.shadowOpacity = 0.6
            clinicSearch.layer.shadowRadius = 3.0
            clinicSearch.layer.shadowColor = UIColor.darkGray.cgColor
            viewheightConstarint.constant = 75
        }else{
            viewheightConstarint.constant = 0
        }
        // viewheightConstarint.constant = 0
        //        locManager.requestWhenInUseAuthorization()
        //        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
        //       CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
        //            currentLocation = locManager.location
        //            lat = currentLocation.coordinate.latitude
        //            log = currentLocation.coordinate.longitude
        //            print(currentLocation.coordinate.latitude)
        //            print(currentLocation.coordinate.longitude)
        //       }
        
      //  cliniclist()
        
        
        hospitalNames = ["Align 32 Dental Care","Assisi Homeo","Clove Detal Clinic"]
        //  menuIcons = [UIImage(named: "Align Dental Care")!,UIImage(named: "Asthma Allergy")!,UIImage(named: "Clove")!]
        locationNames = ["Thrissur,Kerala","Thrissur,Kerala","Thrissur,Kerala"]
        distance = ["~4.5kms","~5.5kms","~6.5kms"]
        clinicsDetails.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        cliniclist()
    }
    @IBAction func backAction(_ sender: UIButton) {
        segment = false
        navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let para = ["mylongitude":log,"loc_type_id":2,"longitude":log,"index_to":0,"district_id":districtId,"filterflag":0,"city_loc_pin_id":-1,"mylatitude":lat,"regionId":regionId,"latitude":lat,"specialityId":specialityId,"clinicname":"","appuser_type":5,"kilometer":25] as [String : AnyObject]
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
                    self.clinicsDetails.delegate = self
                    self.clinicsDetails.dataSource = self
                    self.clinicsDetails.reloadData()
                    //                       // vc.data = districtName
                    //                     //   vc.menuNames = regionArray
                    //                      //  self.navigationController?.show(vc, sender: self)
                    //                    }
                }
                
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrFilterData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BDClinicTableViewCell", for: indexPath) as! BDClinicTableViewCell
        cell.clinicDistance.adjustsFontSizeToFitWidth = true
        cell.clinicName.text = arrFilterData[indexPath.row]["location_name"]as? String
        if (arrFilterData[indexPath.row]["fileUrl"]as? String) != nil
        {
            cell.clinicImageView.sd_setImage(with: URL(string:  (arrFilterData[indexPath.row]["fileUrl"]as? String)!), placeholderImage: UIImage(named: "ic_hospital"))
        }
        else
        {
            cell.clinicImageView.image =  UIImage(named: "ic_hospital")
        }
        if arrFilterData[indexPath.row]["distance"]as! NSNumber != 0
        {
            let roundedKm = (arrFilterData[indexPath.row]["distance"]as! Double).rounded(toPlaces: 2)
            cell.clinicDistance.text = "~\(roundedKm )Km"
        }
        else
        {
            
        }
        cell.clinicLocation.text = arrFilterData[indexPath.row]["address"]as? String
        return cell
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        clinicdepDtails()
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
        
        self.clinicsDetails.reloadData()
    }
    func clinicdepDtails()
    {
        
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
