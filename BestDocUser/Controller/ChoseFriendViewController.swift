//
//  ChoseFriendViewController.swift
//  BestDocUser
//
//  Created by nitheesh.u on 17/01/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//

import UIKit

class ChoseFriendViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    var hospitalNames = [String]()
    var locationNames = [String]()
    var patientList:[NSDictionary] = []
    @IBOutlet weak var choseFriend: UITableView!
    
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var userNAmeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        choseFriend.delegate = self
        choseFriend.dataSource  = self
        hospitalNames = ["Raju", "Mathew","Fazil","Riya"]
        locationNames = ["3 years","4 years","5 years","19 years"]
        // Do any additional setup after loading the view.
        if let response = logindictionary["response"]as? NSDictionary{
            if let data = response["login"]as? NSDictionary
            {
                if let age = data["age"]as?Int{
                ageLabel.text = "\(age)"
                }
                if let name = data["first_name"]as?String{
                    userNAmeLabel.text = "\(name)"
                }
                //print(data["patreg_id"]!)
                //patientRegId = (data["patreg_id"])
                //userRegID = (data["userreg_id"])
            }
        }
    }
    @IBAction func choseAction(_ sender: UIButton) {
        if let response = logindictionary["response"]as? NSDictionary{
            if let data = response["login"]as? NSDictionary
            {
                if let name = data["first_name"]as?String{
                    patientName = "\(name)"
                }
                    patientRegId = (data["patreg_id"])
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
         frieldsList()
    }
    func frieldsList()
    {
        if let data = UserDefaults.standard.object(forKey:"loginData") as? NSDictionary{
            logindictionary = data
        if let response = logindictionary["response"]as? NSDictionary{
            if let data = response["login"]as? NSDictionary
            {
                //print(data["patreg_id"]!)
                patientRegId = (data["patreg_id"])
                userRegID = (data["userreg_id"])
            }
        }
        }else{
            patientRegId = UserDefaults.standard.object(forKey:"patientID") as! Int
            userRegID = UserDefaults.standard.object(forKey:"userRegID") as! Int
        }
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
                    self.choseFriend.reloadData()
                }
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
    @IBAction func AddpatientAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier:"BDAddFriendsViewController" )as! BDAddFriendsViewController
        tagdata = true
        self.present(vc, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return patientList.count
    }
    @IBAction func backAction(_ sender: UIButton) {
        choseFriendTag  = false
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BDchoseFriendTableViewCell", for: indexPath) as! BDchoseFriendTableViewCell
        cell.nameLabel?.text =  patientList[indexPath.row]["name"]as? String
        if let age = patientList[indexPath.row]["age"]{
            cell.agelabel.text = "\(age)"
        }
       // cell.agelabel.text = locationNames[indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if checkSlotTag == true{
            
            patientName = (patientList[indexPath.row]["name"]as? String)!
            patientRegId = patientList[indexPath.row]["patient_reg_id"] 
        }
        choseFriendTag = true
        print(patientList[indexPath.row])
        patientName = (patientList[indexPath.row]["name"]as? String)!
        patientRegId = patientList[indexPath.row]["patient_reg_id"] 
        
        self.dismiss(animated: true, completion: nil)
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 60
//
//
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
