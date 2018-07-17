//
//  BDConfirmationTableViewController.swift
//  BestDocUser
//
//  Created by nitheesh.u on 22/01/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//

import UIKit
protocol TrendingProductsCustomDelegate: class { //Setting up a Custom delegate for this class. I am using `class` here to make it weak.
    func sendDataBackToHomePageViewController(categoryToRefresh: String?) //This function will send the data back to origin viewcontroller.
}

//import PayU_coreSDK_Swift
class BDConfirmationTableViewController: UITableViewController {

    @IBOutlet weak var frrVisitLabel: UILabel!
    @IBOutlet weak var feetableCell: UITableViewCell!
    @IBOutlet weak var mainTotalLabel: UILabel!
    @IBOutlet weak var convenienceLabel: UILabel!
    @IBOutlet weak var registrationLabel: UILabel!
    @IBOutlet weak var consultationLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var tokenTimeSlote: UILabel!
    @IBOutlet weak var tokenNumber: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var clinicNamelabel: UILabel!
    @IBOutlet weak var doctorNameLabel: UILabel!
     weak var customDelegateForDataReturn: TrendingProductsCustomDelegate?
    var totalAmount = Double()
    override func viewDidLoad() {
        super.viewDidLoad()
        if hmsIntegration == 1&&PaymentActive == 1&&hashpaymentContract == 1{
           confirmBooking(opNumberData:OpNumber)
        }else{
            self.consultationLabel.text = "₹\(feeFlotValue)"
            //\((amountDetailsData["consultation_fee"]as! Double) + (amountDetailsData["hospital_charges"]as! Double) + (amountDetailsData["file_charge"]as! Double))"
            self.registrationLabel.text = "₹\(0)"
            self.convenienceLabel.text = "₹10"
            self.amountLabel.text = "₹\((feeFlotValue)+( 10.0))"
            self.mainTotalLabel.text = "₹\((feeFlotValue)+(10.0))"
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        doctorNameLabel.text = doctorName
        clinicNamelabel.text = hospitalName
        let currentDateTime = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        // yourLabel.text = "\(dateFormatter.string(from: currentDateTime))"
        dateLabel.text = "\(dateDetails)"
        tokenNumber.text = "Token No:\(slotData)"
        tokenTimeSlote.text = "Token Time:\(timeSlot)"
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func confirmBooking(opNumberData:String)
{
        var userIDDetail:Any?
        var genderID = Int()
        var resultDic = NSDictionary()
        if let response = logindictionary["response"]as? NSDictionary{
            if let data = response["login"]as? NSDictionary
            {
                userIDDetail = (data["userreg_id"])
                //ownerId = (data["userreg_id"])//print(data["patreg_id"]!)
                //  mobilenumber = (data["mobile_number"])
            }
        }
    
        //date_of_birth:2018-05-21
        // mobile:9446547272
        // os_type:1
        // p_address:
        //email:
        // firstname:Karthu
        //op_no:DH2018/099571
        // pat_reg_id:0
        // user_country_id:1
        // loc_id:180
        // p_blood_group:
        //inserted_userid:12317
        //  sex:2
        //appuser_type:5
        // paramData["id"]
   // params :
//    os_type:1
//    loc_user_id:228
//    op_number:
//    user_country_id:1
//    patientreg_id:23189
//    appuser_type:5
    let xdata  = 10.0
    let para = ["os_type":2,"loc_user_id":locUserId,"op_number":opNumberData,"user_country_id":1,"patientreg_id":patientRegId,"appuser_type":5,"booking_date":(intialDate+" "+intialTime)] as [String : AnyObject]
        print(para)
        let progressHUD = ProgressHUD(text: "")
        self.view.addSubview(progressHUD)
        BDService.confirmBooking(params: para as [String : AnyObject]){(response, message, status ) in
            progressHUD.hide()
            print(response!)
            if status {
                let serviceDetails = response as? BDService
                resultDic = (serviceDetails?.confirmBookigData)!
                print(resultDic)
                if resultDic["status"]as! Int == 1
                {
                    if let responsedata = resultDic["response"]as? NSDictionary{
                        let amountDetailsData = responsedata["amount_details"]as! NSDictionary
                        if amountDetailsData["total_amount"]as! Double != 0{
                            let consultationCharge = (amountDetailsData["consultation_fee"]as! Double) + (amountDetailsData["hospital_charges"]as! Double)
                        self.consultationLabel.text = "₹\(consultationCharge)"
                        //\((amountDetailsData["consultation_fee"]as! Double) + (amountDetailsData["hospital_charges"]as! Double) + (amountDetailsData["file_charge"]as! Double))"
                        self.registrationLabel.text = "₹\(amountDetailsData["file_charge"]as! Double)"
                        self.convenienceLabel.text = "₹10"
                        self.amountLabel.text = "₹\((amountDetailsData["total_amount"]as! Double)+( 10.0))"
                        
                        self.mainTotalLabel.text = "₹\((amountDetailsData["total_amount"]as! Double)+(10.0))"
                       
                        self.totalAmount = (amountDetailsData["total_amount"]as! Double)+(10.0)
                        print(self.totalAmount)
                        print("\(amountDetailsData["total_amount"]as! Double+(10.0))")
//                        let childVC = storyboard?.instantiateViewController(withIdentifier: "")as con
                      //  childVC.amountDataString = "\((amountDetailsData["total_amount"]as! Double)+(10.0))"
                        var dat = "\(amountDetailsData["total_amount"]as! Double+(10.0))"
                        totalAmountData =  self.totalAmount
                        print(totalAmountData)
                        //self.customDelegateForDataReturn?.sendDataBackToHomePageViewController(categoryToRefresh: dat)
                        //self.
                            self.frrVisitLabel.text = ""
                        }else{
                           self.mainTotalLabel.text = "₹0"
                            self.frrVisitLabel.text = "This is a revisit. Consultation is free of charge"
                            self.feetableCell.isHidden = true
                        }
                        
                    }
                    
                        
                    }
                }
            }
            
        }
    
   
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

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
