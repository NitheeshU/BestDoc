//
//  BDpatientDetailsAlertViewController.swift
//  BestDocUser
//
//  Created by nitheesh.u on 02/06/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//

import UIKit

class BDpatientDetailsAlertViewController: UIViewController {

   
    @IBOutlet weak var alertMessageLabel: UILabel!
    @IBOutlet weak var labelView: UIView!
    @IBOutlet weak var bookbutton: UIButton!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var datelabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var patientAlert: UIView!
    var patientDic = NSDictionary()
    var msg = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        labelView.layer.addBorder(edge:.bottom, color: .lightGray, width: labelView.frame.width, thickness: 0.5)
        genderLabel.text = (patientDic["gender"]as! String)
        datelabel.text = (patientDic["dob"]as! String)
        nameLabel.text = (patientDic["patient_name"]as! String)
        alertMessageLabel.text = msg
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func notNowAction(_ sender: UIButton) {
    }
    
    @IBAction func bookAction(_ sender: UIButton) {
       // patientRegId =   response["patientId"]
      //  OpNumber = opupper!
        if PaymentActive == 1{
            let vc = self.storyboard?.instantiateViewController(withIdentifier:"ConfirmBookingViewController" )as! ConfirmBookingViewController
            //tagdata = true
            self.present(vc, animated: true, completion: nil)
        }else if PaymentActive == 0{
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier:"BDConfirmBookingpaymentinactiveViewController" )as! BDConfirmBookingpaymentinactiveViewController
            
            //tagdata = true
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true, completion: nil)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        bookbutton.layer.cornerRadius = 5
        patientAlert.layer.cornerRadius = 5
        self.view.backgroundColor =  UIColor.black.withAlphaComponent(0.7)
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.someAction (_:)))
        self.view.addGestureRecognizer(gesture)
    }
    @objc func someAction(_ sender:UITapGestureRecognizer){
        self.dismiss(animated: true, completion: nil)
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
