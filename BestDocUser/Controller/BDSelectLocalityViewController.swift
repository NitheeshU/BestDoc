//
//  BDSelectLocalityViewController.swift
//  BestDocUser
//
//  Created by nitheesh.u on 15/01/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//

import UIKit

class BDSelectLocalityViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var changeDistrict: UIButton!
    @IBOutlet weak var localityTableView: UITableView!
    @IBOutlet weak var districtName: UILabel!
     @IBOutlet weak var Alloflocality: UIButton!
    var menuNames = [NSDictionary]()
    var data = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        districtName.text = data
        Alloflocality.setTitle("All of \(data)", for: .normal)
//        menuNames = ["Anchery","Ayyanthole","Chembukkav","East Fort","Thiruvambady"]
        changeDistrict.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }
   
    @IBAction func allOfLocalityAction(_ sender: UIButton) {
        dataLocality = "All of \(data)"
        regionId = -1
        if  tagview == true
        {
            let vc = storyboard?.instantiateViewController(withIdentifier:"BDHomaBaseViewController" )as! BDHomaBaseViewController
            navigationController?.show(vc, sender: self)
            
            
        }else
        {
            let vc = storyboard?.instantiateViewController(withIdentifier:"BDMainViewController" )as! BDMainViewController
            navigationController?.show(vc, sender: self)
        }
    }
   
    @IBOutlet weak var backAction: UIButton!
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
       
    }
    @IBAction func changeDistrictAction(_ sender: Any) {
         navigationController?.popViewController(animated: true)
//        let vc = storyboard?.instantiateViewController(withIdentifier:"selectDistrictViewController" )as! selectDistrictViewController
//
//        navigationController?.show(vc, sender: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return menuNames.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BDLocalityTableViewCell", for: indexPath) as! BDLocalityTableViewCell
        
        cell.localityLabel.text = menuNames[indexPath.row]["value"]as? String
        
        return cell
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        dataLocality = menuNames[indexPath.row]["value"]as? String
        regionId = (menuNames[indexPath.row]["id"]as? Int)!
        if  tagview == true
        {
             let vc = storyboard?.instantiateViewController(withIdentifier:"BDHomaBaseViewController" )as! BDHomaBaseViewController
            navigationController?.show(vc, sender: self)
            
            
        }else
        {
             let vc = storyboard?.instantiateViewController(withIdentifier:"BDMainViewController" )as! BDMainViewController
        navigationController?.show(vc, sender: self)
    }
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
