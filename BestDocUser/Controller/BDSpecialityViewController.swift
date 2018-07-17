//
//  BDSpecialityViewController.swift
//  BestDocUser
//
//  Created by nitheesh.u on 15/01/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//

import UIKit

class BDSpecialityViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var allspecilality: UIButton!
    
    @IBOutlet weak var heightAllSpeciality: NSLayoutConstraint!
    @IBOutlet weak var Bdspecialities: UITableView!
    var arrFilterData : [NSDictionary] = []
    var isSearch : Bool!
     var menuNames =  [NSDictionary]()
    override func viewDidLoad() {
        super.viewDidLoad()
         searchBar.delegate = self
        isSearch = false
       
         // menuNames = ["All Specialities","Cardiology","Dentistry","Dermatology","Ear Nose Throat (ENT)","General Medicine"]
        speciality()
        // Do any additional setup after loading the view.
    }
    func speciality()
    {
         var specialityArray = [NSDictionary]()
        var districtDic = NSDictionary()
        let para = ["search":"","appuser_type":5,"district_id":districtId,"city_loc_pin_id":-1,"searchflag":2,"available_speciality":1,"regionId":regionId] as [String : Any]
        print(para)
        let progressHUD = ProgressHUD(text: "")
        self.view.addSubview(progressHUD)
        BDService.getSpeciality(params: para as [String : AnyObject]){(result, message, status ) in
            progressHUD.hide()
            print(result!)
            if status {
                let serviceDetails = result as? BDService
                districtDic = (serviceDetails?.speciality)!
                print(districtDic)
                if districtDic["status"]as! Int == 1
                {
                    if let district = districtDic["response"] as? NSDictionary {
                       specialityArray =  (district["department_list"]as? [NSDictionary])!
                        print(specialityArray)
                        if specialityArray.count == 0
                        {
                            
                        }
                       
                        self.menuNames = specialityArray
                        
                        self.arrFilterData = self.menuNames
                        self.Bdspecialities.reloadData()
                        
                    }
                }
                
            }
        }
    }
    @IBAction func backAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func AllSpecialityAction(_ sender: UIButton) {
        if districtId == nil{
         
        }else{
        let vc = storyboard?.instantiateViewController(withIdentifier:"BDHomaBaseViewController" )as! BDHomaBaseViewController
        dataSpeciality = "All Specialities"
        specialityId = 0
        navigationController?.show(vc, sender: self)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrFilterData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BDSpecialityTableViewCell", for: indexPath) as! BDSpecialityTableViewCell
        cell.specialitiesLabel.text = arrFilterData[indexPath.row]["department_name"]as? String
        
        
        return cell
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tagspeciality == true
        {
        let vc = storyboard?.instantiateViewController(withIdentifier:"BDHomaBaseViewController" )as! BDHomaBaseViewController
        dataSpeciality = arrFilterData[indexPath.row]["department_name"]as? String
            specialityId = (arrFilterData[indexPath.row]["department_id"]as? Int)!
            navigationController?.show(vc, sender: self)
        }
        else
        {
            let vc = storyboard?.instantiateViewController(withIdentifier:"BDMainViewController" )as! BDMainViewController
            dataSpeciality = arrFilterData[indexPath.row]["department_name"]as? String
            specialityId = (arrFilterData[indexPath.row]["department_id"]as? Int)!
            navigationController?.show(vc, sender: self)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 45
        
        
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        
        if targetContentOffset.pointee.y < scrollView.contentOffset.y {
            // it's going up
            UIView.animate(withDuration: 0.4, animations: { // 3.0 are the seconds
                self.allspecilality.isHidden = true
                self.heightAllSpeciality.constant = 0
                // Write your code here for e.g. Increasing any Subviews height.
                
                self.view.layoutIfNeeded()
                
            })
            
        } else {
            UIView.animate(withDuration: 0.4, animations: { // 3.0 are the seconds
                self.heightAllSpeciality.constant = 60
                self.allspecilality.isHidden = false
                // Write your code here for e.g. Increasing any Subviews height.
                
                self.view.layoutIfNeeded()
                
            })
            // it's going down
        }
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        // When user has entered text into the search box
        // Use the filter method to iterate over all items in the data array
        // For each item, return true if the item should be included and false if the
        // item should NOT be included
        arrFilterData = (searchText.isEmpty ? menuNames : menuNames.filter({(dataString: NSDictionary) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return (dataString["department_name"] as! String).range(of: searchText, options: .caseInsensitive) != nil
        }))
        
         self.Bdspecialities.reloadData()
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
