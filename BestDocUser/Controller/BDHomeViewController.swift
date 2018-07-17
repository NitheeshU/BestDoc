//
//  BDHomeViewController.swift
//  BestDocUser
//
//  Created by nitheesh.u on 12/01/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//

import UIKit
import SJSegmentedScrollView
import MapKit
class BDHomeViewController: UIViewController{
   
    var segmentedViewController = SJSegmentedViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        segmentedViewController.segmentTitleColor = UIColor.black
        segmentedViewController.segmentTitleFont = UIFont.systemFont(ofSize: 12.0)
        segmentedViewController.selectedSegmentViewHeight = 3.0
        if let storyboard = self.storyboard{
            let headerController = storyboard.instantiateViewController(withIdentifier: "BDHospitalViewController")as! BDHospitalViewController
            headerController.title = "HOSPITALS"
            //headerController.delegate = self
            let firstViewController = storyboard.instantiateViewController(withIdentifier: "BDDoctorViewController")as! BDDoctorViewController
            firstViewController.title = "DOCTORS"
            segmentedViewController.segmentTitleColor = UIColor.white
            let secondViewController = storyboard.instantiateViewController(withIdentifier: "BDClinicViewController")as! BDClinicViewController
            secondViewController.title = "CLINICS"
            segmentedViewController.segmentShadow = SJShadow.dark()
            segmentedViewController.segmentBounces = false
             //segmentedViewController.view.frame = self.view.bounds
            segmentedViewController.selectedSegmentViewColor = UIColor.white
            segmentedViewController.segmentControllers = [headerController,firstViewController,secondViewController]
            //segmentedViewController.navigationItem.title = "MY PROFILE"
//         let navigation = storyboard.instantiateViewController(withIdentifier: "SegmentnavigationViewController")as!SegmentnavigationViewController
//            addChildViewController(segmentedViewController)
//            self.view.addSubview(segmentedViewController.view)
//            segmentedViewController.view.frame = self.view.bounds
//            segmentedViewController.didMove(toParentViewController: self)
            self.navigationController?.setViewControllers([segmentedViewController], animated: false)
            segmentedViewController.segmentBackgroundColor = UIColor(red: 0/255.0, green: 167/255.0, blue: 157/255.0, alpha: 0.85)
           // segmentedViewController.reloadInputViews()
            
        }
        // Do any additional setup after loading the view.
    }
    func setSelectedSegmentAt(_ index: Int, animated: Bool){
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func viewForSegmentControllerToObserveContentOffsetChange(controller: UIViewController,
//                                                              
//                                                              index: Int) -> UIView {
//        segmentedViewController.segmentBounces = false
//        return view
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
