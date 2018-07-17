//
//  BDDoctorinUnit.swift
//  BestDocUser
//
//  Created by nitheesh.u on 13/07/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//

import Foundation
import UIKit

protocol doctestProtocol:class {
    func testDelegate() // this function the first controllers
}
class BDDoctorinUnit : UITableView, UITableViewDelegate, UITableViewDataSource {
    var card :[NSDictionary] = []
    
    weak var delegateDetails: doctestProtocol?
    var indexOfRow = IndexPath()
    //var  accountValue = AccountDetailsView()
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.delegate = self
        self.dataSource = self
        self.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return card.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BDDocINUnitTableViewCell", for: indexPath) as!BDDocINUnitTableViewCell
        //cell.clinicAddress.adjustsFontForContentSizeCategory = true
        cell.backgroundColor = UIColor.clear
        if(cell.docname.text != nil)
        {
            cell.docname.text = card[indexPath.row]["doctor_name"]as? String
            if let sessionDa = card[indexPath.row]["sessions"]as? [NSDictionary]{
                let session = sessionDa[0]
                let dateFormatter = DateFormatter()
                let timeString = session["sessionStartTime"]as! String
                dateFormatter.dateFormat = "HH:mm:ss"
                // dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                let date = dateFormatter.date(from: timeString)
              // date24 = dateAsString
                dateFormatter.dateFormat = "h:mm a"
                let Date12 = dateFormatter.string(from: date!)
                print(Date12)
                let dateFormatter2 = DateFormatter()
                let timeString2 = session["sessionEndTime"]as! String
                dateFormatter2.dateFormat = "HH:mm:ss"
                // dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                let date2 = dateFormatter2.date(from: timeString2)
                // date24 = dateAsString
                dateFormatter2.dateFormat = "h:mm a"
                let Date122 = dateFormatter2.string(from: date2!)
                print(Date122)
               // timeDetails = Date12
                cell.sessionLabel.text = (Date12)+"-"+(Date122)
            
            }
            if let imageurl = card[indexPath.row]["file_url"]as?String{
                cell.docProfileImage.sd_setImage(with: URL(string: imageurl), placeholderImage: UIImage(named: "ic_male"))
            }
            else {
               cell.docProfileImage.image =  UIImage(named: "ic_male")
            }
        }
        else
        {
            print("cell is empty")
        }
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor.groupTableViewBackground
        }else {
            cell.backgroundColor = UIColor.white
        }
        return cell
        
    }
    
    //    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
    //        return 0
    //    }
    //    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
    //        return 0
    //    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    //    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //        return 0
    //    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        indexOfRow = indexPath
//        locUserId = card[indexPath.row]["locuserid"]
//        locationId =  card[indexPath.row]["loc_id"]
//        delegateDetails?.testDelegate()
//        
//        
//    }
    
    
    
    
    
}
