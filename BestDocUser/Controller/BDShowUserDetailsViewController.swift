//
//  BDShowUserDetailsViewController.swift
//  BestDocUser
//
//  Created by nitheesh.u on 18/05/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//

import UIKit

class BDShowUserDetailsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    
    var userDetails = [NSDictionary]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "BDUserDetailsTableViewCell")as!BDUserDetailsTableViewCell
        cell.namelabel.text = userDetails[indexPath.row]["patient_name"]as! String
        return cell
    }
    @IBOutlet weak var enterNameLabel: UIButton!
    @IBAction func enterNameAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BDSecondRegisterViewController")as! BDSecondRegisterViewController
        vc.patientName = ""
        otp = 1
        patientRegId = 0
        self.navigationController?.show(vc, sender: self)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BDSecondRegisterViewController")as! BDSecondRegisterViewController
        otp = 1
        patientRegId = userDetails[indexPath.row]["patient_id"]as! Int
        vc.patientName = userDetails[indexPath.row]["patient_name"]as! String
        self.navigationController?.show(vc, sender: self)
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
