//
//  BDOtherClinics.swift
//  BestDocUser
//
//  Created by nitheesh.u on 18/04/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//

import Foundation
import Foundation
import UIKit

protocol testProtocol:class {
    func testDelegate() // this function the first controllers
}
class BDOtherClinics : UITableView, UITableViewDelegate, UITableViewDataSource {
    var card :[NSDictionary] = []
    
    weak var delegateDetails: testProtocol?
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "BDOtherClinicsTableViewCell", for: indexPath) as!BDOtherClinicsTableViewCell
        cell.clinicAddress.adjustsFontForContentSizeCategory = true
        cell.backgroundColor = UIColor.clear
        if(cell.ClinicName.text != nil)
        {
            cell.ClinicName.text = card[indexPath.row]["location_name"]as? String
            cell.clinicAddress.text = card[indexPath.row]["address"]as? String
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        indexOfRow = indexPath
        locUserId = card[indexPath.row]["locuserid"]
        locationId =  card[indexPath.row]["loc_id"]
        delegateDetails?.testDelegate()
       
        
    }
    
    
  
    
    
}
