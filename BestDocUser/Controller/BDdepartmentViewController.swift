//
//  departmentViewController.swift
//  BestDocUser
//
//  Created by nitheesh.u on 13/01/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//

import UIKit
import SDWebImage

class BDdepartmentViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,YourCellDelegates{
   
    
    @IBOutlet weak var tableView: UITableView!
    let kHeaderSectionTag: Int = 6900;
    var sections = [Section(genre: "Cardiology", movies: ["Dr.Abdul Khadar.S","Dr.Rupesh George"],imageD:[UIImage(named:"Abdul Khader")!,UIImage(named:"Rupesh George")!],expanded: false),Section(genre: "Dentistry", movies: ["Dr.Beena Philip","Dr.Sabu John"],imageD:[UIImage(named:"Beena Philip")!,UIImage(named:"Sabu John")!],expanded: false),
                    Section(genre: "Dermatology", movies: ["Dr.Abel Francis","Dr.Anitta Shojan"],imageD:[UIImage(named:"Abel Francis")!,UIImage(named:"Anitta Shojjan")!],  expanded: false)]
    var tabelData = [NSDictionary]()
    var expandedSectionHeaderNumber: Int = -1
    var expandedSectionHeader: UITableViewHeaderFooterView!
    var sectionItems: Array<Any> = []
    var sectionNames: Array<Any> = []
    // Do any additional setup after loading the view.

   
    override func viewDidLoad() {
        super.viewDidLoad()
      tabelData = clinicDepartmentArray
        print(tabelData)
         self.tableView!.tableFooterView = UIView()
}
   override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if tabelData.count > 0 {
            tableView.backgroundView = nil
            return tabelData.count
        } else {
            let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height))
            messageLabel.text = "Unavailable"
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = .center;
            messageLabel.font = UIFont(name: "HelveticaNeue", size: 20.0)!
            messageLabel.sizeToFit()
            self.tableView.backgroundView = messageLabel;
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.expandedSectionHeaderNumber == section) {
             let sectionIt = (tabelData[section]["doctors"]as! [NSDictionary])
            let arrayOfItems = sectionIt
            return arrayOfItems.count;
        } else {
            return 0;
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0;
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 0;
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (self.tabelData.count != 0) {
            return self.tabelData[section]["departmentName"] as? String
        }
        return ""
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        //recast your view as a UITableViewHeaderFooterView
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor.groupTableViewBackground
        //colorWithHexString(hexStr: "#408000")
        header.textLabel?.textColor = UIColor.darkGray
        
        if let viewWithTag = self.view.viewWithTag(kHeaderSectionTag + section) {
            viewWithTag.removeFromSuperview()
        }
        let headerFrame = self.view.frame.size
        let theImageView = UIImageView(frame: CGRect(x: headerFrame.width - 32, y: 13, width: 18, height: 18));
        theImageView.image = UIImage(named: "Chevron-Dn-Wht")
        theImageView.tag = kHeaderSectionTag + section
        header.addSubview(theImageView)
        
        // make headers touchable
        header.tag = section
        let headerTapGesture = UITapGestureRecognizer()
        headerTapGesture.addTarget(self, action: #selector(self.sectionHeaderWasTouched(_:)))
        header.addGestureRecognizer(headerTapGesture)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "departmentTableViewCell", for: indexPath) as! departmentTableViewCell
        let section = tabelData[indexPath.section]["doctors"]as![NSDictionary]
        cell.celltitle?.textColor = UIColor.black
        cell.celltitle?.text = section[indexPath.row]["doctor_name"] as? String
        
        if let imageFile = ( section[indexPath.row]["fileUrl"]as? String){    // returns optional
             cell.cellImage.sd_setImage(with: URL(string: imageFile), placeholderImage: UIImage(named: "ic_male"))
        }
        else {
            cell.cellImage.image =  UIImage(named: "ic_male")
        }
        cell.cellDelegate = self
//        cell.yourobj =
//            {
//                let vc = self.storyboard?.instantiateViewController(withIdentifier:"BDBookingSloteViewController" )as! BDBookingSloteViewController
//                vc.modalTransitionStyle = .crossDissolve
//                //self.present(vc, animated: true, completion: nil)
//               self.navigationController?.show(vc, sender: self)
//        }
        let specialityArray = section[indexPath.row]["specialities"] as? [String]
        if specialityArray?.count != 0
        {
        cell.hospitalName.text = specialityArray?.joined(separator: ",")
        }
        else
        {
            cell.hospitalName.isHidden = true
        }
        if section[indexPath.row]["consult_fee"]as! Double != 0
        {
            if section[indexPath.row]["consult_fee"]as? Float == -2
            {
                cell.feeLabel.text = "Fee Unavailable"
            }
            else if section[indexPath.row]["consult_fee"]as? Float == -1
            {
                cell.feeLabel.text = "Free"
            }
            else if section[indexPath.row]["consult_fee"]as? Float == 0
            {
                cell.feeLabel.text = "Free"
            }
            else
            {
                cell.feeLabel.text = "₹\(section[indexPath.row]["consult_fee"]as? Float ?? 0)"
            }
            //cell.feeLabel.text = "₹\(section[indexPath.row]["consult_fee"] ?? 0)"
        }
        else
        {
            cell.feeLabel.isHidden = true
        }
        return cell
    
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let header = ExpandableHeaderView()
//        header.customInit(title: sections[section].genre, section: section, delegate: self)
//        return header
////    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "labelCell")
//        cell?.textLabel?.text = sections[indexPath.section].movies[indexPath.row]
//        return cell!
//    }
//    func toggleSection(header: ExpandableHeaderView, section: Int) {
//        sections[section].expanded = !sections[section].expanded
//        tableView.beginUpdates()
//        for i in 0 ..< sections[section].movies.count{
//            tableView.reloadRows(at: [IndexPath(row:i,section:section)], with: .automatic)
//
//        }
//        tableView.endUpdates()
//    }
    func getCurrentCellIndexPath(_ sender: UIButton) -> IndexPath? {
        let buttonPosition = (sender as AnyObject).convert(CGPoint.zero, to: self.tableView)
        // sender.convert(CGPoint.zero, to: tableView)
        if let indexPath: IndexPath = tableView.indexPathForRow(at: buttonPosition) {
            return indexPath
        }
        return nil
    }
    func didTapButton(_ sender: UIButton) {
        if let indexPath = getCurrentCellIndexPath(sender) {
            print(indexPath)
            let section = tabelData[indexPath.section]["doctors"]as![NSDictionary]
            hospitalName = hospitalData
            doctorName = section[indexPath.row]["doctor_name"] as? String
            //appUserType = (section[indexPath.row]["appUserType"])
            locUserId = (section[indexPath.row]["loc_user_id"])
            docregid = (section[indexPath.row]["userreg_id"])
            if section[indexPath.row]["consult_fee"]as? Float == -2
            {
                feeDataValue = "Fee Unavailable"
               // self.feeLabel.text = "Unavailable"
            }
            else if section[indexPath.row]["consult_fee"]as? Float == -1
            {
                feeDataValue = "Free"
               // self.feeLabel.text = "Free"
            }
            else if section[indexPath.row]["consult_fee"]as? Float == 0
            {
                feeDataValue = "Free"
               // self.feeLabel.text = "Free"
            }
            else
            {
                feeDataValue = "₹\(section[indexPath.row]["consult_fee"]as? Float ?? 0)"
                feeFlotValue = (section[indexPath.row]["consult_fee"]as? Float)!
                //self.feeLabel.text = "₹\(doctorProfileDetails["consult_fee"]as? Float ??  0) Consultation Fee"
            }
            
            // patRegID = arrFilterData[indexPath.row]["userreg_id"]
           // locationId = (section[indexPath.row]["loc_id"])
            // Slotlist()
            let next = storyboard?.instantiateViewController(withIdentifier: "BDBookingSloteViewController") as! BDBookingSloteViewController
            
            self.navigationController?.show(next,sender:self)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier:"BDDoctorDetailsViewController" )as! BDDoctorDetailsViewController
          let section = tabelData[indexPath.section]["doctors"]as![NSDictionary]
        hospitalName = hospitalData
        doctorName = section[indexPath.row]["doctor_name"] as? String
        //appUserType = (section[indexPath.row]["appUserType"])
        locUserId = (section[indexPath.row]["loc_user_id"])
        docregid = (section[indexPath.row]["userreg_id"])
        // patRegID = arrFilterData[indexPath.row]["userreg_id"]
        //locationId = (section[indexPath.row]["loc_id"])
       // doctorImageData = ( section[indexPath.row]["fileUrl"]as? String)!
        //hospitalName = hospitalN[indexPath.row]
        navigationController?.show(vc, sender:self)
    }
    // MARK: - Expand / Collapse Methods
    
    @objc func sectionHeaderWasTouched(_ sender: UITapGestureRecognizer) {
        let headerView = sender.view as! UITableViewHeaderFooterView
        let section    = headerView.tag
        let eImageView = headerView.viewWithTag(kHeaderSectionTag + section) as? UIImageView
        
        if (self.expandedSectionHeaderNumber == -1) {
            self.expandedSectionHeaderNumber = section
            tableViewExpandSection(section, imageView: eImageView!)
        } else {
            if (self.expandedSectionHeaderNumber == section) {
                tableViewCollapeSection(section, imageView: eImageView!)
            } else {
                let cImageView = self.view.viewWithTag(kHeaderSectionTag + self.expandedSectionHeaderNumber) as? UIImageView
                tableViewCollapeSection(self.expandedSectionHeaderNumber, imageView: cImageView!)
                tableViewExpandSection(section, imageView: eImageView!)
            }
        }
    }
    
    func tableViewCollapeSection(_ section: Int, imageView: UIImageView) {
        let sectionOne = tabelData[section]["doctors"]as![NSDictionary]
        let sectionData = sectionOne
        self.expandedSectionHeaderNumber = -1;
        if (sectionData.count == 0) {
            return;
        } else {
            UIView.animate(withDuration: 0.4, animations: {
                imageView.transform = CGAffineTransform(rotationAngle: (0.0 * CGFloat(Double.pi)) / 180.0)
            })
            var indexesPath = [IndexPath]()
            for i in 0 ..< sectionData.count {
                let index = IndexPath(row: i, section: section)
                indexesPath.append(index)
            }
            self.tableView!.beginUpdates()
            self.tableView!.deleteRows(at: indexesPath, with: UITableViewRowAnimation.fade)
            self.tableView!.endUpdates()
        }
    }
    
    func tableViewExpandSection(_ section: Int, imageView: UIImageView) {
        let sectionOne = tabelData[section]["doctors"]as![NSDictionary]
        
       
        let sectionData = sectionOne
        
        if (sectionData.count == 0) {
            self.expandedSectionHeaderNumber = -1;
            return;
        } else {
            UIView.animate(withDuration: 0.4, animations: {
                imageView.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
            })
            var indexesPath = [IndexPath]()
            for i in 0 ..< sectionData.count {
                let index = IndexPath(row: i, section: section)
                indexesPath.append(index)
            }
            self.expandedSectionHeaderNumber = section
            self.tableView!.beginUpdates()
            self.tableView!.insertRows(at: indexesPath, with: UITableViewRowAnimation.fade)
            self.tableView!.endUpdates()
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
