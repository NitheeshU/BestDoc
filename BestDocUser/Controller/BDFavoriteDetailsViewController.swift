//
//  BDFavoriteTableViewController.swift
//  BestDocUser
//
//  Created by nitheesh.u on 17/01/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//

import UIKit

class BDFavoriteDetailsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,nextCellDelegate {
    
    @IBOutlet weak var favoritetable: UITableView!
    var hospitalNames = [String]()
    var locationNames = [String]()
    var distance = [String]()
    var menuIcons = [UIImage]()
    var favouriteListArray = [NSDictionary]()
    override func viewDidLoad() {
        super.viewDidLoad()
        hospitalNames = ["Dr.Balu Mohan","Dr.K.R.Sreenath","Dr.Roy Varghese"]
        menuIcons = [UIImage(named: "Balu Mohan")!,UIImage(named: "sreenath")!,UIImage(named: "Roy Varghese")!,UIImage(named: "ic_male")!]
        locationNames = ["Daya General Hospital", "CAM Hospital","Craft Hospital& Research Centre"]
        distance = ["MBBS","MD","MBBS","MBBS"]
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillAppear(_ animated: Bool) {
        favouriteList()
    }
    func getCurrentCellIndexPath(_ sender: UIButton) -> IndexPath? {
        let buttonPosition = (sender as AnyObject).convert(CGPoint.zero, to: self.favoritetable)
        // sender.convert(CGPoint.zero, to: tableView)
        if let indexPath: IndexPath = favoritetable.indexPathForRow(at: buttonPosition) {
            return indexPath
        }
        return nil
    }
    func didTapButton(_ sender: UIButton) {
        if let indexPath = getCurrentCellIndexPath(sender) {
            print(indexPath)
            doctorName = favouriteListArray[indexPath.row]["doctor_name"] as! String
            hospitalName = favouriteListArray[indexPath.row]["location_name"] as! String
            //  doctorImageData = arrFilterData[indexPath.row]["fileUrl"]as! String
            locUserId = (favouriteListArray[indexPath.row]["loc_user_id"])
            docregid = (favouriteListArray[indexPath.row]["userreg_id"])!
            // patRegID = arrFilterData[indexPath.row]["userreg_id"]
            locationId = (favouriteListArray[indexPath.row]["locid"])!
            // Slotlist()
            if favouriteListArray[indexPath.row]["consult_fee"]as? Float == -2
            {
                feeDataValue = "Unavailable"
            }
            else if favouriteListArray[indexPath.row]["consult_fee"]as? Float == -1
            {
                feeDataValue = "Free"
            }
            else if favouriteListArray[indexPath.row]["consult_fee"]as? Float == 0
            {
                feeDataValue = "Free"
            }
            else
            {
                feeDataValue = "₹\(favouriteListArray[indexPath.row]["consult_fee"]as? Float ?? 0)"
                feeFlotValue = favouriteListArray[indexPath.row]["consult_fee"]as? Float ?? 0
            }
            
            let next = storyboard?.instantiateViewController(withIdentifier: "BDBookingSloteViewController") as! BDBookingSloteViewController
            
            self.navigationController?.show(next,sender:self)
        }
//            doctorName = (favouriteListArray[indexPath.row]["doctor_name"]as! String)
//            hospitalName = (favouriteListArray[indexPath.row]["location_name"]as! String)
//            locUserId = (favouriteListArray[indexPath.row]["loc_user_id"])
//            userRegID = (favouriteListArray[indexPath.row]["userreg_id"])!
//            // patRegID = arrFilterData[indexPath.row]["userreg_id"]
//            locationId = (favouriteListArray[indexPath.row]["locid"])!
//            // Slotlist()
//            let next = storyboard?.instantiateViewController(withIdentifier: "BDBookingSloteViewController") as! BDBookingSloteViewController
//
//            self.navigationController?.show(next,sender:self)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func favouriteList()
    {
    var userReg:Any?
    if let response = logindictionary["response"]as? NSDictionary{
        if let data = response["login"]as? NSDictionary
        {
            userReg = (data["userreg_id"])
            //patientRegId = (data["patreg_id"])
            //ownerId = (data["userreg_id"])//
            //  mobilenumber = (data["mobile_number"])
        }}
    //{ // let data =  UserDefaults.standard.object(forKey:"loginData") as! NSDictionary
       // let ptreg :Any?
        if let response = logindictionary["response"]as? NSDictionary{
            if let data = response["login"]as? NSDictionary
            {
                //print(data["patreg_id"]!)
                patientRegId = (data["patreg_id"])
            }
        }
        print(userRegID!)
        print(patientRegId!)
        var favourite = NSDictionary()
        let para = ["os_type":2,"pat_reg_id":patientRegId,"userreg_id":0,"patient_fav_doc_id":0,"appuser_type":5,"user_country_id":1]
        let progressHUD = ProgressHUD(text: "")
        self.view.addSubview(progressHUD)
        BDService.postFavourite(params: para as [String : AnyObject]){(result, message, status ) in
            progressHUD.hide()
            print(message!)
            print(result!)
            if status {
                let serviceDetails = result as? BDService
                favourite = (serviceDetails?.favouriteListDic)!
                print(favourite)
                if favourite["status"]as! Int == 1
                {
                    if let favouriteData = favourite["response"] as? NSDictionary {
                        if let favouriteDataArray = favouriteData["favorite_doctor"]as? [NSDictionary]
                        {
                            self.favouriteListArray = favouriteDataArray
                            self.favoritetable.reloadData()
                        }
//                        self.districtArray =  (district["districts"]as? [NSDictionary])!
//                        print(self.favourite)
//                        self.menuNames = self.districtArray
//                        self.selectDistrictTableView.reloadData()
                    }
                }
                
            }
        }
    }
    // MARK: - Table view data source

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.favouriteListArray.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BDFavoriteTableViewCell", for: indexPath) as! BDFavoriteTableViewCell
        cell.doctorName.text = (favouriteListArray[indexPath.row]["doctor_name"]as! String)
        if let fvtDocImage = (favouriteListArray[indexPath.row]["fileUrl"]as? String){
             cell.drprofileImage.sd_setImage(with: URL(string: fvtDocImage), placeholderImage: UIImage(named: "ic_male"))
            
        }else{
            cell.drprofileImage.image =  UIImage(named: "ic_male")
        }
        
        cell.speciality.text =  (favouriteListArray[indexPath.row]["speciality"]as! String)
        cell.qualification.text =  (favouriteListArray[indexPath.row]["qualification"]as! String)
        cell.cellDelegate = self
        return cell
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier:"BDDoctorDetailsViewController" )as! BDDoctorDetailsViewController
        doctorName = (favouriteListArray[indexPath.row]["doctor_name"]as! String)
        hospitalName = (favouriteListArray[indexPath.row]["location_name"]as! String)
        locUserId = (favouriteListArray[indexPath.row]["loc_user_id"])
        docregid = (favouriteListArray[indexPath.row]["userreg_id"])!
        // patRegID = arrFilterData[indexPath.row]["userreg_id"]
        locationId = (favouriteListArray[indexPath.row]["locid"])!
        if let fvtDocImage = (favouriteListArray[indexPath.row]["fileUrl"]as? String){
           //cell.drprofileImage.sd_setImage(with: URL(string: fvtDocImage), placeholderImage: UIImage(named: "ic_male"))
            
        }else{
            //cell.drprofileImage.image =  UIImage(named: "ic_male")
        }
        //doctorImageData = menuIcons[indexPath.row]
        navigationController?.show(vc, sender:self)
    }

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
