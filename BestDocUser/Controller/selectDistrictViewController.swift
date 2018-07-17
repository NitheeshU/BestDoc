//
//  selectDistrictViewController.swift
//  BestDocUser
//
//  Created by nitheesh.u on 15/01/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//

import UIKit
import Alamofire
class selectDistrictViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var selectDistrictTableView: UITableView!
    var menuNames = [NSDictionary]()
      var districtArray = [NSDictionary]()
    override func viewDidLoad() {
        super.viewDidLoad()
      // signup()
//menuNames = ["Thiruvananthapuram","Ernakulam","Thrissur","Malappuram","Kozhikode"]
        // Do any additional setup after loading the view.
    }
    var tvm = ["All of Thiruvananthapuram","Kazhakuttam","Medical College","Mele Thampanoor","Pattom Palace"]
    var ekm = ["All of Ernakulam","Cheranallor","Edapally","Edavanakad","Eloor"]
    var thri = ["All of Thrissur","Amalanagar","Anchery","Ayyanthole","Chelakkottukara"]
    var Malappuram = ["All of Malappuram","Kottakkal","Perinthalmanna","Ponani","Tirur"]
    var kozhikod = ["All of Kozhikode","Arakkinar","Arayidathupalam","Calicut Civil Station","Chalapuram"]

    @IBAction func backAction(_ sender: Any) {
        
       
    
            navigationController?.popViewController(animated: true)
    
        
    }
    override func viewWillAppear(_ animated: Bool) {
        districtcal()
    }
    
    func districtcal()
    {
        var districtDic = NSDictionary()
        
        let para = ["stateId":1,"appuser_type":5]as! [String : AnyObject]
        let progressHUD = ProgressHUD(text: "")
        self.view.addSubview(progressHUD)
        BDService.getDistrict(params: para as [String : AnyObject]){(result, message, status ) in
            progressHUD.hide()
            print(message)
            print(result!)
            if status {
                let serviceDetails = result as? BDService
                districtDic = (serviceDetails?.districts)!
                print(districtDic)
                if districtDic["status"]as! Int == 1
                {
                    if let district = districtDic["response"] as? NSDictionary {
                        self.districtArray =  (district["districts"]as? [NSDictionary])!
                        print(self.districtArray)
                        self.menuNames = self.districtArray
                        self.selectDistrictTableView.reloadData()
                    }
                }
                
            }
        }
    }
    func regioncal(regID:Int,districtName:String)
    {
        var regionArray = [NSDictionary]()
        var regionDic = NSDictionary()
        let para = ["stateId":1,"appuser_type":5,"districtId":regID]
        let progressHUD = ProgressHUD(text: "")
        self.view.addSubview(progressHUD)
        BDService.getRegion(params: para as [String : AnyObject]){(result, message, status ) in
            progressHUD.hide()
            print(result!)
            if status {
                let serviceDetails = result as? BDService
                regionDic = (serviceDetails?.region)!
                print(regionDic)
                if regionDic["status"]as! Int == 1
                {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier:"BDSelectLocalityViewController" )as!
                    BDSelectLocalityViewController
                    if let district = regionDic["response"] as? NSDictionary {
                        regionArray =  (district["regions"]as? [NSDictionary])!
                        print(regionArray)
                        vc.data = districtName
                      vc.menuNames = regionArray
                        self.navigationController?.show(vc, sender: self)
                    }
                }
                
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return menuNames.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BDselectDistrictTableViewCell", for: indexPath) as! BDselectDistrictTableViewCell
        cell.districtLabel.text = menuNames[indexPath.row]["value"]as? String
        
        return cell
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = storyboard?.instantiateViewController(withIdentifier:"BDSelectLocalityViewController" )as!
//        BDSelectLocalityViewController
        regioncal(regID: (menuNames[indexPath.row]["id"]as? Int)!,districtName: (menuNames[indexPath.row]["value"]as? String)!)
        districtId = (menuNames[indexPath.row]["id"]as? Int)!
//        switch indexPath.row {
//        case 0:vc.menuNames = tvm
//        case 1:vc.menuNames = ekm
//        case 2:vc.menuNames = thri
//        case 3:vc.menuNames = Malappuram
//        case 4:vc.menuNames = kozhikod
//        default:
//            print("Error")
//        }
//        let vc = storyboard?.instantiateViewController(withIdentifier:"BDSelectLocalityViewController" )as!
//        BDSelectLocalityViewController
       
           //navigationController?.show(vc, sender: self)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 45
        
        
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
