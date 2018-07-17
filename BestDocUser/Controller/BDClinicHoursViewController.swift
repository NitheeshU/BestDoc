//
//  BDClinicHoursViewController.swift
//  BestDocUser
//
//  Created by nitheesh.u on 17/04/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//

import UIKit

class BDClinicHoursViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    

    @IBOutlet weak var doctorName: UILabel!
    @IBOutlet weak var clinicHours: UITableView!
    var arrayData = [NSDictionary]()
    var doctorNA = String()
    override func viewDidLoad() {
        super.viewDidLoad()
       doctorName.text = doctorNA
       clinicHours.estimatedRowHeight = 200
        
       // clinicHours.rowHeight = UITableViewAutomaticDimension
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 80
        
   }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayData.count
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
         return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BDclinicHoursTableViewCell")as!BDclinicHoursTableViewCell
       if Date().dayOfWeek() == arrayData[indexPath.row]["day"]as? String       {
        print(Date().dayOfWeek()!)
            cell.dayLabel.textColor = UIColor.black
       }else
      {
          cell.dayLabel.textColor = UIColor.lightGray
       }
        
        
       // cell.dayLabel.textColor = UIColor.lightGray
        cell.dayLabel.text = arrayData[indexPath.row]["day"]as? String
        let timedata = arrayData[indexPath.row]["time"]as! [String]
       print(timedata.joined())
            if timedata.count != 0
            {
                cell.sessionLabel.textColor = UIColor.lightGray
                cell.sessionLabel.text = timedata.joined(separator: ",")
        }else
            {
                cell.sessionLabel.textColor = UIColor.red
                cell.sessionLabel.text = "NO Session Available"
                
               
        }
            
    
        
        return cell
    }

    @IBAction func backAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
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
extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
}


