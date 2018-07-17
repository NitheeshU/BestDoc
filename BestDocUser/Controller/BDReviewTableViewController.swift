//
//  BDReviewTableViewController.swift
//  BestDocUser
//
//  Created by nitheesh.u on 17/04/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//

import UIKit

class BDReviewTableViewController: UITableViewController {
var arrayReview = [NSDictionary]()
    override func viewDidLoad() {
        super.viewDidLoad()
       

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: tableView.contentSize.height+5)
    }
    override func viewDidLayoutSubviews(){
       self.view.frame = CGRect(x:  self.tableView.frame.origin.x, y:  self.tableView.frame.origin.y, width: self.tableView.frame.size.width, height: self.tableView.contentSize.height+5)
    }
//        tableView.reloadData()   }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrayReview.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BDDoctorReviewTableViewCell", for: indexPath)as! BDDoctorReviewTableViewCell
        cell.nameLabel.text = arrayReview[indexPath.row]["patientname"]as?String
         cell.reviewLabel.text = arrayReview[indexPath.row]["feedback"]as?String
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        
        if let date = dateFormatterGet.date(from: (arrayReview[indexPath.row]["date_time"]as?String)!){
            cell.dateLabel.text = dateFormatterPrint.string(from: date)
            print(dateFormatterPrint.string(from: date))
        }
        else {
            print("There was an error decoding the string")
        }
        
        if let imageFile = (arrayReview[indexPath.row]["fileUrl"]as?String) {
          cell.reviewimageView.sd_setImage(with: URL(string:  imageFile), placeholderImage: UIImage(named: "ic_male"))
        }else{
             cell.reviewimageView.image = UIImage(named: "ic_male")
        }
        
        // Configure the cell...
        
        return cell
    }
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
