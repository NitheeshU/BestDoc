//
//  BDContactUsViewController.swift
//  BestDocUser
//
//  Created by nitheesh.u on 25/01/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//

import UIKit

class BDContactUsViewController: UIViewController {
    @IBOutlet weak var contacView: UIView!
    @IBOutlet weak var feedBAckButton: UIButton!
    
    @IBOutlet weak var requestButton: UIButton!
    @IBOutlet weak var reportButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.someAction (_:)))
        // Do any additional setup after loading the view.
        self.view.addGestureRecognizer(gesture)
        
    }
@objc func someAction(_ sender:UITapGestureRecognizer){
    self.view.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func callNumber(phoneNumber:String) {
        
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func callAction(_ sender: UIButton) {
         callNumber(phoneNumber:"9020602222")
    }
    @IBAction func backAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        contacView.isHidden = true
    }
    @IBAction func givefeedBack(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        reportButton.isSelected = false
        requestButton.isSelected = false
        contacView.isHidden = false
    }
    
    @IBAction func reportBugAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        feedBAckButton.isSelected = false
        requestButton.isSelected = false
        contacView.isHidden = false
    }
    @IBAction func requestFetures(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        feedBAckButton.isSelected = false
        reportButton.isSelected = false
        contacView.isHidden = false
    }
    @IBOutlet weak var reportBug: UIButton!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
