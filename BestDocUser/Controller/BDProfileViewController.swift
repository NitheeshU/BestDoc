//
//  BDProfileViewController.swift
//  BestDocUser
//
//  Created by nitheesh.u on 11/01/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//

import UIKit
import SDWebImage
class BDProfileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var nameLabe: UILabel!
    @IBOutlet weak var editProfileView: UIView!
    @IBOutlet weak var mobileNoLabel: UILabel!
    @IBOutlet weak var profileImageLabel: UIImageView!
    var menuNames = [String]()
    var menuIcons = [UIImage]()
    @IBOutlet weak var profileMenuTablView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //   objCache.cleanDisk()
    //    profile()
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.someAction (_:)))
        editProfileView.addGestureRecognizer(gesture)
        menuNames = ["Favorite Doctors","Appointments","Friends and Family","Contact Us","Settings","Logout"]
        menuIcons = [UIImage(named: "ic_favorite")!,UIImage(named: "ic_appoinments")!,UIImage(named: "ic_friendsandfamily")!,UIImage(named: "ic_contactus")!,UIImage(named: "ic_settings")!,UIImage(named: "ic_logout")!]
        profileImageLabel.layer.borderWidth = 1
        profileImageLabel.layer.masksToBounds = false
        profileImageLabel.layer.borderColor = UIColor.lightGray.cgColor
        profileImageLabel.layer.cornerRadius = profileImageLabel.frame.height/2
        profileImageLabel.clipsToBounds = true
        profileMenuTablView.delegate = self
        profileMenuTablView.dataSource = self
        profileMenuTablView.tableFooterView = UIView(frame: .zero)
        if let data = UserDefaults.standard.object(forKey:"loginData") as? NSDictionary{
        logindictionary = data
        }
        if let response = logindictionary["response"]as? NSDictionary{
            if let data = response["login"]as? NSDictionary
            {
                //nameLabe.text = data["first_name"]as? String
               // mobileNoLabel.text =  data["mobile_number"]as? String
               if let profileLmage = data["file_url"]as? String{
                let url = URL(string: profileLmage)
                let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                self.profileImageLabel.image = UIImage(data: data!)
               }else{
                 profileImageLabel.image = UIImage(named:"ic_male")
                }
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    
    
        // Do any additional setup after loading the view.
    }
    
    }
    func profile(){
        if let data = UserDefaults.standard.object(forKey:"loginData") as? NSDictionary{
            logindictionary = data
        if let response = logindictionary["response"]as? NSDictionary{
            if let data = response["login"]as? NSDictionary
            {
                //userIDDetail = (data["userreg_id"])
                patientRegId = (data["patreg_id"])
                //ownerId = (data["userreg_id"])//
                //  mobilenumber = (data["mobile_number"])
            }
        }
        }
        else{
            patientRegId = UserDefaults.standard.object(forKey:"patientID") as! Int
            userRegID = UserDefaults.standard.object(forKey:"userRegID") as! Int
            //  userReg = userRegID
            //patientRegId
        }
        var profileDetails = NSDictionary()
        let para = ["os_type":1,
                    "pat_reg_id":patientRegId,
                    "user_country_id":1,
                    "appuser_type":5] as [String : AnyObject]
        let progressHUD = ProgressHUD(text: "")
        self.view.addSubview(progressHUD)
        BDService.patientView(params: para as [String : AnyObject]){(result, message, status ) in
            progressHUD.hide()
            print(message!)
            print(result!)
            if status {
                let serviceDetails = result as? BDService
                profileDetails = (serviceDetails?.patientDetailsForEdit)!
                print(profileDetails)
                if profileDetails["status"]as! Int == 1
                {
                    if let response = (profileDetails["response"]as? NSDictionary) {
                        if let data = response["patient"]as? NSDictionary
                        {
                            self.nameLabe.text = data["first_name"]as? String
                            self.mobileNoLabel.text =  data["mobile_number"]as? String
                            if let dataimage = data["images"]as? NSDictionary{
                            if let image = dataimage["fileUrl"]as? String{
                                let url = URL(string: image)
                                let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                                self.profileImageLabel.image = UIImage(data: data!)
                            }else{
                                self.profileImageLabel.image = UIImage(named: "ic_male")
                            }
                            }
                        }
                        
                        // patientRegId = responseOne["patientId"]as! Int
                        //userRegID = responseOne["userregid"]as! Int
                    }
                }
            }
        }
    }
    func logout(){
        if let response = logindictionary["response"]as? NSDictionary{
            if let data = response["login"]as? NSDictionary
            {
                //userIDDetail = (data["userreg_id"])
                patientRegId = (data["patreg_id"])
                //ownerId = (data["userreg_id"])//
                //  mobilenumber = (data["mobile_number"])
            }
        }
        else{
            patientRegId = UserDefaults.standard.object(forKey:"patientID") as! Int
            userRegID = UserDefaults.standard.object(forKey:"userRegID") as! Int
          //  userReg = userRegID
            //patientRegId
        }
        var profileDetails = NSDictionary()
        let para = ["os_type":2,
                    "user_country_id":1,
                    "appuser_type":5,"userreg_id":userRegID] as [String : AnyObject]
       // os_type:1
        //user_country_id:1
        //userreg_id:13889
        //appuser_type:5
        let progressHUD = ProgressHUD(text: "")
        self.view.addSubview(progressHUD)
        BDService.logout(params: para as [String : AnyObject]){(result, message, status ) in
            progressHUD.hide()
            print(message!)
            print(result!)
            if status {
                let serviceDetails = result as? BDService
                profileDetails = (serviceDetails?.logout)!
                print(profileDetails)
                if profileDetails["status"]as! Int == 1
                {
                    UserDefaults.standard.set(false, forKey: "regStatus")
                    UserDefaults.standard.set(false, forKey: "loginStatus")
                    let appDomain = Bundle.main.bundleIdentifier!
                    UserDefaults.standard.removePersistentDomain(forName: appDomain)
                    if let bundleID = Bundle.main.bundleIdentifier {
                        UserDefaults.standard.removePersistentDomain(forName: bundleID)
                        self.navigationController?.popToRootViewController(animated: true)
                }
                    UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
                    
                    UserDefaults.standard.synchronize()
            }
        }
    }
    }
    override func viewWillAppear(_ animated: Bool) {
        let objCache = SDImageCache.shared()
        objCache.clearMemory()
        
        profile()
          profileImageLabel.layer.cornerRadius = 35
    }
    @objc func someAction(_ sender:UITapGestureRecognizer){
        let vc = storyboard?.instantiateViewController(withIdentifier:"BDEditProfileViewController" )as! BDEditProfileViewController
        
        navigationController?.show(vc, sender: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButton(_ sender: Any) {
        if let login = UserDefaults.standard.object(forKey:"loginStatus") as? Bool{
            if login == true{
                navigationController?.popToRootViewController(animated: true)
            }
        }else{
        navigationController?.popViewController(animated: true)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return menuNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = tableView.dequeueReusableCell(withIdentifier: "BDMenuTableViewCell", for: indexPath) as! BDMenuTableViewCell
        cell.menuTitle.text = menuNames[indexPath.row]
        cell.menuIcon.image = menuIcons[indexPath.row]
        return cell
    
       
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let x:CGFloat = CGFloat(menuNames.count)
            return profileMenuTablView.frame.height/x+1/x
        
        
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch  indexPath.row {
        case 0:let vc = storyboard?.instantiateViewController(withIdentifier:"BDFavouriteViewController" )as! BDFavouriteViewController
        
        navigationController?.show(vc, sender: self)
        case 1: let vc = storyboard?.instantiateViewController(withIdentifier:"BDAppoinmentsViewController" )as! BDAppoinmentsViewController
        
        navigationController?.show(vc, sender: self)
        case 2: let vc = storyboard?.instantiateViewController(withIdentifier:"BDFriendlistViewController" )as! BDFriendlistViewController
        
        navigationController?.show(vc, sender: self)
            
        case 3: let vc = storyboard?.instantiateViewController(withIdentifier:"BDContactUsViewController")as! BDContactUsViewController
        
        navigationController?.show(vc, sender: self)
        case 4: let vc = storyboard?.instantiateViewController(withIdentifier:"BDSettingViewController")as! BDSettingViewController
        
        navigationController?.show(vc, sender: self)
        case 5: logout()
        default:
            print("invalid")
        }
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
