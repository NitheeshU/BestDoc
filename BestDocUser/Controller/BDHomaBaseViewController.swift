//
//  BDHomaBaseViewController.swift
//  BestDocUser
//
//  Created by nitheesh.u on 13/01/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//

import UIKit
import SJSegmentedScrollView
class BDHomaBaseViewController: UIViewController {
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var segmentView: UIView!
    @IBOutlet weak var place: UIButton!
    @IBOutlet weak var specialites: UIButton!
    var segmentedViewController = SJSegmentedViewController()
    var segmentindex = Int()
    override func viewWillAppear(_ animated: Bool) {
        place.setTitle(dataLocality, for: .normal)
        specialites.setTitle(dataSpeciality, for: .normal)
        segmentView.bringSubview(toFront: searchView)
      //  segmentedViewController.setSelectedSegmentAt(2, animated: true)
    }
    @IBAction func searchAction(_ sender: UIButton) {
        segment = true
        switch segmentindex {
        case 0:
            let headerController = storyboard?.instantiateViewController(withIdentifier: "BDHospitalViewController")as! BDHospitalViewController
            navigationController?.show(headerController, sender: self)
            
        case 1:
            let firstViewController = storyboard?.instantiateViewController(withIdentifier: "BDDoctorViewController")as! BDDoctorViewController
            navigationController?.show(firstViewController, sender: self)
            
        case 2:
            let secondViewController = storyboard?.instantiateViewController(withIdentifier: "BDClinicViewController")as! BDClinicViewController
            navigationController?.show(secondViewController, sender: self)
            
        default:
            break
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedViewController.delegate = self
//navigationController?.navigationBar.isHidden = true
        navigationController?.isNavigationBarHidden = true
        segmentedViewController.segmentTitleColor = UIColor.black
        segmentedViewController.segmentTitleFont = UIFont.systemFont(ofSize: 12.0)
        segmentedViewController.selectedSegmentViewHeight = 3.0
       // segmentedViewController.delegate = self
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
             segmentedViewController.segmentBackgroundColor = UIColor(red: 0/255.0, green: 167/255.0, blue: 157/255.0, alpha: 0.85)
            //segmentedViewController.navigationItem.title = "MY PROFILE"
            //         let navigation = storyboard.instantiateViewController(withIdentifier: "SegmentnavigationViewController")as!SegmentnavigationViewController
            //            addChildViewController(segmentedViewController)
            //            self.view.addSubview(segmentedViewController.view)
            //            segmentedViewController.view.frame = self.view.bounds
            //            segmentedViewController.didMove(toParentViewController: self)
            addChildViewController(segmentedViewController)
            self.segmentView.addSubview(segmentedViewController.view)
            segmentedViewController.view.frame = self.segmentView.bounds
//            segmentedViewController.didMoveToParentVewController(self) self.navigationController?.setViewControllers([segmentedViewController], animated: false)
           
            // segmentedViewController.reloadInputViews()
            
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func backAction(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier:"BDMainViewController" )as!
        BDMainViewController
       // vc.data = menuNames[indexPath.row]
        navigationController?.show(vc, sender: self)
    }
    
    @IBAction func allSpeciality(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier:"BDSpecialityViewController" )as! BDSpecialityViewController
        tagspeciality = true
        navigationController?.show(vc, sender: self)
    
    }
    
    @IBAction func localityAction(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier:"selectDistrictViewController" )as! selectDistrictViewController
        tagview = true
        navigationController?.show(vc, sender: self)
        //self.present(vc, animated: true, completion: nil)
        
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
extension BDHomaBaseViewController: SJSegmentedViewControllerDelegate {
    
    func didMoveToPage(_ controller: UIViewController, segment: SJSegmentTab?, index: Int) {
        if segmentedViewController.segments.count > 0 {
            
            _ = segmentedViewController.segments[index]
            print(index)
            segmentindex = index
            //segmentTab.titleColor = .yellow
        }
    }
}
