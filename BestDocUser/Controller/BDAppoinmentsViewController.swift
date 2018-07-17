//
//  BDAppoinmentsViewController.swift
//  BestDocUser
//
//  Created by nitheesh.u on 18/01/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//

import UIKit
import SJSegmentedScrollView
class BDAppoinmentsViewController: UIViewController {
    
    @IBOutlet weak var segmentView: UIView!
    var segmentedViewController = SJSegmentedViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        appoinments()
        navigationController?.isNavigationBarHidden = true
        segmentedViewController.segmentTitleColor = UIColor.black
        segmentedViewController.segmentTitleFont = UIFont.systemFont(ofSize: 12.0)
        segmentedViewController.selectedSegmentViewHeight = 3.0
      
       
    }
    override func viewWillAppear(_ animated: Bool) {
    
    }
    func appoinments()
    {  // let data =  UserDefaults.standard.object(forKey:"loginData") as! NSDictionary
        // let ptreg :Any?
        var pastData = [NSDictionary]()
        var upcomingData = [NSDictionary]()
        if let data = UserDefaults.standard.object(forKey:"loginData") as? NSDictionary{
            logindictionary = data
        if let response = logindictionary["response"]as? NSDictionary{
            if let data = response["login"]as? NSDictionary
            {
                
                //print(data["patreg_id"]!)
                patientRegId = (data["patreg_id"])
            }
        }
        }else{
            patientRegId = UserDefaults.standard.object(forKey:"patientID") as! Int
            userRegID = UserDefaults.standard.object(forKey:"userRegID") as! Int
        }
        print(userRegID!)
        print(patientRegId!)
        var appoinmentListData = NSDictionary()
        //userreg_id:13907
      //  docuserreg_id:0
       // os_type:1
       // doc_name:
        //book_status:
        //bookdate:
        //pat_reg_id:23363
        //user_country_id:1
        //appuser_type:5
        //book_type:0
        let para = ["os_type":2,"pat_reg_id":patientRegId,"userreg_id":userRegID,"appuser_type":5,"user_country_id":1,"docuserreg_id":0,"doc_name":"","book_status":"","bookdate":""]as [String:AnyObject]
        print(para)
        let progressHUD = ProgressHUD(text: "")
        self.view.addSubview(progressHUD)
        BDService.postAppoinments(params: para as [String : AnyObject]){(result, message, status ) in
            progressHUD.hide()
            print(message!)
            print(result!)
            if status {
                let serviceDetails = result as? BDService
                appoinmentListData = (serviceDetails?.appoinmentList)!
                print(appoinmentListData)
                if appoinmentListData["status"]as! Int == 1
                {
                    
                    if let appoinmentData = appoinmentListData["response"] as? NSDictionary {
                   if let pastBookingdata = appoinmentData["pastBookings"]as? [NSDictionary]
                        {
                           pastData = pastBookingdata
                        }
                        if let presentBookingdata = appoinmentData["upcomingBookings"]as? [NSDictionary]
                        {
                            upcomingData = presentBookingdata
                        }
                    }
                            //                            if let storyboard = self.storyboard{
                            let headerController = self.storyboard?.instantiateViewController(withIdentifier: "BDUpAndPastViewController")as! BDUpAndPastViewController
                            headerController.title = "Past"
                            headerController.locationNames = ["Mon,29 Jan 2018 at 9:28 pm,Token 15","Wed,31 Jan 2018 at 10:28 Am,Token 27","Fri,2 Feb 2018 at 11:28 Am,Token 17"]
                            headerController.upandpastData = pastData
                            headerController.fee = ["Confirmed","Confirmed","Confirmed"]
                            //headerController.delegate = self
                            let firstViewController = self.storyboard?.instantiateViewController(withIdentifier: "BDUpAndPastViewController")as! BDUpAndPastViewController
                            firstViewController.title = "Upcoming"
                    firstViewController.upandpastData = upcomingData
                            firstViewController.locationNames = ["Tue,16 Jan 2018 at 9:28 pm,Token 15","Wed,17 Jan 2018 at 10:28 Am,Token 27","Fri,19 Feb 2018 at 11:28 Am,Token 17"]
                            firstViewController.fee = ["Visited","Visited","Cancelled"]
                            self.segmentedViewController.segmentTitleColor = UIColor.white
                            
                            self.segmentedViewController.segmentShadow = SJShadow.dark()
                            self.segmentedViewController.segmentBounces = false
                            
                            self.segmentedViewController.selectedSegmentViewColor = UIColor.white
                            self.segmentedViewController.segmentControllers = [headerController,firstViewController]
                            self.segmentedViewController.segmentBackgroundColor = UIColor(red: 0/255.0, green: 167/255.0, blue: 157/255.0, alpha: 0.85)
                            self.addChildViewController(self.segmentedViewController)
                            self.segmentView.addSubview(self.segmentedViewController.view)
                            self.segmentedViewController.view.frame = self.segmentView.bounds
                            
                            
                            
                       // } // self.favouriteListArray = favouriteDataArray
//                            //self.favoritetable.reloadData()
                  //    }
                        //                        self.districtArray =  (district["districts"]as? [NSDictionary])!
                        //                        print(self.favourite)
                        //                        self.menuNames = self.districtArray
                        //                        self.selectDistrictTableView.reloadData()
                   // }
                }
                
            }
        }
    }
func didSelectSegmentAtIndex(_ index:Int)
{
     if let storyboard = self.storyboard{
if index == 0
{
    let headerController = storyboard.instantiateViewController(withIdentifier: "BDUpAndPastViewController")as! BDUpAndPastViewController
    headerController.title = "Upcomming(3)"
    headerController.locationNames = ["Tue,30 Jan 2018 at 9:28 pm,Token 15","Wed,31 Jan 2018 at 10:28 Am,Token 27","Fri,2 Feb 2018 at 11:28 Am,Token 17"]
    }
else if index == 1 {
    //headerController.delegate = self
    let firstViewController = storyboard.instantiateViewController(withIdentifier: "BDUpAndPastViewController")as! BDUpAndPastViewController
    firstViewController.title = "Past(3)"
    firstViewController.locationNames = ["Tue,16 Jan 2018 at 9:28 pm,Token 15","Wed,17 Jan 2018 at 10:28 Am,Token 27","Fri,19 Feb 2018 at 11:28 Am,Token 17"]
    }
        }
    }
    @IBAction func backAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
