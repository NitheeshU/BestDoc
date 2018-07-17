//
//  BDFriendlistViewController.swift
//  BestDocUser
//
//  Created by nitheesh.u on 17/01/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//

import UIKit

class BDFriendlistViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
   
    var patientList:[NSDictionary] = []
    @IBOutlet weak var friendslistTabelView: UITableView!
    var hospitalNames = [String]()
    var locationNames = [String]()
    var selectedPatientreg:Any?
    
    override func viewDidLoad() {
        super.viewDidLoad()
         hospitalNames = [" Raju", " Mathew"," Fazil"," Riya"]
         locationNames = ["3 years","4 years","5 years","19 years"]
        
        // Do any additional setup after loading the view.
    
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
         frieldsList()
    }
    func frieldsList()
    {
        
     var dataList = NSDictionary()
        let para = ["user_country_id":1,"userreg_id":userRegID,"appuser_type":appUserType,] as [String : AnyObject]
        print(para)
        let progressHUD = ProgressHUD(text: "")
        self.view.addSubview(progressHUD)
        BDService.getFriendsList(params: para as [String : AnyObject]){(response, message, status ) in
            progressHUD.hide()
            print(response!)
            if status {
                let friendList = response as? BDService
                if friendList?.friendslist["status"]as! Int == 0{
                self.alert(alertmessage:friendList?.friendslist["error_msg"]as! String)
                }
                else{
                    dataList = (friendList?.friendslist)!
                }
                print(dataList)
                if let patientdic = dataList["response"]as? NSDictionary{
                    self.patientList = patientdic["patient list"] as! [NSDictionary]
                    self.friendslistTabelView.reloadData()
                }
        }
    }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       // if let data = patientList[indexPath.row]as? NSDictionary{
          //  selectedPatientreg = data["patient_reg_id"]as! String
       // }
    }
    func friendsDelete()
    {
        
        var dataList = NSDictionary()
        let para = ["user_country_id":1,"insertedid":userRegID,"appuser_type":appUserType,"os_type":2,"patreg_id":selectedPatientreg] as [String : AnyObject]
     //   request parameters: insertedid:7513  appuser_type:5  user_country_id:1  patreg_id:21534  os_type:1
        

        print(para)
        let progressHUD = ProgressHUD(text: "")
        self.view.addSubview(progressHUD)
        BDService.deleteFriendsFamily(params: para as [String : AnyObject]){(response, message, status ) in
            progressHUD.hide()
            print(response!)
            if status {
                let friendList = response as? BDService
                if friendList?.deleteFriends["status"]as! Int == 0{
                    self.alert(alertmessage:friendList?.deleteFriends["error_msg"]as! String)
                }
                else{
                    self.frieldsList()
                }
//                print(dataList)
//                if let patientdic = dataList["response"]as? NSDictionary{
//                    self.patientList = patientdic["patient list"] as! [NSDictionary]
//                    self.friendslistTabelView.reloadData()
               // }
            }
        }
    }
    func alert(alertmessage:String)
    {
        let alert = UIAlertController(title: alertmessage, message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
    }
    @IBAction func backAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Add(_ sender: UIButton) {
        
    let vc = storyboard?.instantiateViewController(withIdentifier:"BDAddFriendsViewController" )as! BDAddFriendsViewController
        vc.patientReg = 0
        addFriendTag = false
      navigationController?.show(vc, sender: self)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return patientList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BDFriendsTableViewCell", for: indexPath) as! BDFriendsTableViewCell
        cell.namelabel?.text = patientList[indexPath.row]["name"]as? String
        if let age = patientList[indexPath.row]["age"]{
            cell.ageLabel.text = "\(age)years"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var datadetails = NSDictionary()
        if let data = patientList[indexPath.row]as? NSDictionary{
            datadetails = data
            selectedPatientreg = data["patient_reg_id"]
        }
        
        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
        editFriends = true
            let vc = self.storyboard?.instantiateViewController(withIdentifier:"BDAddFriendsViewController" )as! BDAddFriendsViewController
            vc.genderID = (datadetails["sex"]as? Int)!
            vc.name = (datadetails["name"]as? String)!
            vc.dob = (datadetails["date_of_birth"]as? String)!
            vc.patientReg = datadetails["patient_reg_id"]
            addFriendTag = false
            self.navigationController?.show(vc, sender: self)
        })
        editAction.backgroundColor = UIColor.blue
        
        // action two
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            self.friendsDelete()
        })
        deleteAction.backgroundColor = UIColor.red
        
        return [editAction, deleteAction]
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
