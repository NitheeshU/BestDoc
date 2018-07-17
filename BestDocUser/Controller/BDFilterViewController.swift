//
//  BDFilterViewController.swift
//  BestDocUser
//
//  Created by nitheesh.u on 27/03/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//

import UIKit

class BDFilterViewController: UIViewController{

    @IBOutlet weak var sortSegment: UISegmentedControl!
    @IBOutlet weak var genderSegment: UISegmentedControl!
    @IBOutlet weak var feeSegment: UISegmentedControl!
    @IBOutlet weak var consultationSegment: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        UILabel.appearance(whenContainedInInstancesOf: [UISegmentedControl.self]).numberOfLines = 0
 self.view.backgroundColor =  UIColor.black.withAlphaComponent(0.7)
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.someAction (_:)))
        self.view.addGestureRecognizer(gesture)
        // Do any additional setup after loading the view.
    }
    @objc func someAction(_ sender:UITapGestureRecognizer){
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func sortSegment(_ sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 0){
            print("fee")
            
        }else{//choice 2
             print("Distance")
        }
    }
    
    @IBAction func GenderSegment(_ sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 0){
            print("Male")
            genderDataID = 1
            
        }else  if (sender.selectedSegmentIndex == 1){//choice 2
            print("Female")
             genderDataID = 2
        }
        else if (sender.selectedSegmentIndex == 2){
            print("Any")
            genderDataID = 0

        }
    }
    @IBAction func consultationSegment(_ sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 0){
           startTime = "00:00:00"
            endTime = "12:00:00"
            
        }else  if (sender.selectedSegmentIndex == 1){//choice 2
           
            startTime = "12:00:00"
            endTime = "16:00:00"
        }
        else if (sender.selectedSegmentIndex == 2){
            startTime = "16:00:00"
            endTime = "20:00:00";
        }
        else if (sender.selectedSegmentIndex == 3){
            startTime = "20:00:00"
            endTime = "23:00:00";
        }
    }
    
    @IBAction func feeSegment(_ sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 0){
            feeMin = -1
            feeMax = -1
            
            
        }else  if (sender.selectedSegmentIndex == 1){//choice 2
            feeMin = 1
            feeMax = 200
        }
        else if (sender.selectedSegmentIndex == 2){
            feeMin = 200
            feeMax = 500
        }
        else if (sender.selectedSegmentIndex == 3){
            feeMin = 500
            feeMax = 1000
        }
    }
    @IBAction func resetAction(_ sender: UIButton) {
        feeMin = 0
            feeMax = 0
        genderDataID = 0
        startTime = "00:00:00"
        endTime = "23:00:00"
       self.sortSegment.selectedSegmentIndex = UISegmentedControlNoSegment
        self.genderSegment.selectedSegmentIndex = UISegmentedControlNoSegment
        self.feeSegment.selectedSegmentIndex = UISegmentedControlNoSegment
        self.consultationSegment.selectedSegmentIndex = UISegmentedControlNoSegment
    }
    
   
    @IBAction func applyAction(_ sender: UIButton) {
       // let vc = BDDoctorViewController()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
       // vc.viewDidLoad()
        //vc.doctorlist()
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func closeAction(_ sender: UIButton) {
         self.dismiss(animated: true, completion: nil)
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
