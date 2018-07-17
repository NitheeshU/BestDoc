//
//  BDUpAndPastViewController.swift
//  BestDocUser
//
//  Created by nitheesh.u on 18/01/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//

import UIKit

class BDUpAndPastViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    @IBOutlet weak var upAndPastDetails: UITableView!
    var hospitalN = [String]()
    var hospitalNames = [String]()
    var locationNames = [String]()
    var distance = [String]()
    var menuIcons = [UIImage]()
    var speciality = [String]()
    var fee = [String]()
    var upandpastData = [NSDictionary]()
    override func viewDidLoad() {
        super.viewDidLoad()
        hospitalN = ["Amala Institute of Medical Science", "CAM Hospital","Craft Hospital& Research Centre"]
        hospitalNames = ["Dr.Abdul Khadar.S","Dr.K.R.Sreenath","Dr.Roy Varghese"]
        
        menuIcons = [UIImage(named:"Abdul Khader" )!,UIImage(named: "sreenath")!,UIImage(named: "Roy Varghese")!]
//        locationNames = ["Tue,16 2018 at 9:28 pm,Token 15","Tue,16 2018 at 9:28 pm,Token 15","Tue,16 2018 at 9:28 pm,Token 15"]
        distance = ["~4.5kms","~5.5kms","~9.87Kms"]
       // exp = ["5 yrs exp .","2 yrs exp .","3 yrs exp ."]
        //fee = ["₹500 .","₹200 .","₹300 ."]
        speciality = ["Cardiology","Dermatology","ENT"]
        //fee = ["Confirmed","Visited","Confirmed"]
        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return upandpastData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "BDUpandDownTableViewCell", for: indexPath) as! BDUpandDownTableViewCell
        
        cell.doctorNameLabel.text = (upandpastData[indexPath.row]["doctor_name"]as! String)
        if let staus = upandpastData[indexPath.row]["booking_status"]as?Int{
            
             cell.statusLabel.text = statusCode(x: staus)
            cell.statusLabel.layer.borderWidth = 1
            cell.statusLabel.layer.borderColor = UIColor(rgb:statusColor(x: staus)).cgColor
            cell.statusLabel.textColor = UIColor(rgb:statusColor(x: staus))
        }
        if let speciality = upandpastData[indexPath.row]["speciality"]as? String{
            
           cell.specialityLabel.text = speciality
        }
        var string1 = String()
        var string2 = String()
        var string3 = String()
        if let time = (upandpastData[indexPath.row]["time_slot"]as?String){
            let dateAsString = time
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss"
            // dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            let date = dateFormatter.date(from: dateAsString)
            dateFormatter.dateFormat = "h:mm a"
            let Date12 = dateFormatter.string(from: date!)
            print(Date12)
            string2 =  "at\(Date12)"
        }
        else{
            string2 = ","
        }
        if let dateData = (upandpastData[indexPath.row]["booking_date"]as? String){
            let dateValueAsString = dateData
            let formatter2 = DateFormatter()
            formatter2.dateFormat =  "yyyy-MM-dd"
            let intialDate = formatter2.date(from: dateValueAsString)
            let dateFormatterdate = DateFormatter()
            dateFormatterdate.dateFormat = "EEEE,dd MMM yyyy"
            let finalDate = dateFormatterdate.string(from: intialDate!)
            print(finalDate)
            string1 = finalDate
        }
        else{
            string1 = ""
        }
        if (upandpastData[indexPath.row]["slot_no"]as!Int) != nil{
             string3 = ",Token\(upandpastData[indexPath.row]["slot_no"]as!Int)"
        }
        else{
            string3 = ""
        }
//        let dateAsString = time
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "HH:mm:ss"
//        // dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
//        let date = dateFormatter.date(from: dateAsString)
//        dateFormatter.dateFormat = "h:mm a"
//        let Date12 = dateFormatter.string(from: date!)
//        print(Date12)
        
        
        
        cell.booktimeLabel.text = string1+string2+string3
        
        cell.hospitalnameLabel.text = (upandpastData[indexPath.row]["location_name"]as! String)
        if let imageFile = (upandpastData[indexPath.row]["fileUrl"]as? String) {    // returns optional
            cell.doctorImage.sd_setImage(with: URL(string: imageFile), placeholderImage: UIImage(named: "ic_male"))
        }
        else {
            cell.doctorImage.image =  UIImage(named: "ic_male")
            // user did not have key "name"
            // here would be the place to return "default"
            // or do any other error correction if the key did not exist
        }
       // cell.doctorImage.image = menuIcons[indexPath.row]
//        if cell.statusLabel.text == "Cancelled"
//        {
//
//        }
//        switch indexPath.row {
//        case 2:cell.statusLabel.layer.borderWidth = 1
//        cell.statusLabel.layer.borderColor = UIColor.red.cgColor
//            cell.statusLabel.textColor = UIColor.red
//        default:
//            print("error")
//        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         appoinmentDetailsDict = upandpastData[indexPath.row]
        let vc  = storyboard?.instantiateViewController(withIdentifier: "BDAppoinmentDetailsViewController")as!BDAppoinmentDetailsViewController
        navigationController?.show(vc, sender: self)
       
    }
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    func dateDay(time:String,dateData:String,slot:Int)->String
    {
     
        let dateAsString = time
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        // dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let date = dateFormatter.date(from: dateAsString)
        dateFormatter.dateFormat = "h:mm a"
        let Date12 = dateFormatter.string(from: date!)
        print(Date12)
        
        let dateValueAsString = dateData
        let formatter2 = DateFormatter()
        formatter2.dateFormat =  "yyyy-MM-dd"
        let intialDate = formatter2.date(from: dateValueAsString)
        let dateFormatterdate = DateFormatter()
        dateFormatterdate.dateFormat = "EEEE,dd MMM yyyy"
        let finalDate = dateFormatterdate.string(from: intialDate!)
        print(finalDate)
        return (dateData+"at"+time+",Token\(slot)")
        
    }
    func statusCode(x:Int)->String{
        var dataString = String()
        switch (x) {
            
        case 1:
            dataString =  "Confirmed"
            
        case 2:
            dataString = "Initiated"
            
        case 3:
            dataString = "Visited"
            
        case 4:
            dataString = "Checked in"
            
        case 5:
            dataString = "Cancelled"
            
        case 6:
            dataString = "Deleted"
            
        case 7:
            dataString = "fake booking cancel"
            
        case 8:
            dataString = "cancelled for another booking"
            
            
        default:
            print("invalid")
        }
        return dataString
    }
    func statusColor(x:Int)->Int{
        var dataString = Int()
        switch (x) {
            
        case 1:
            dataString =  0x00a79d
            
        case 2:
            dataString = 0xb3b3b3
            
        case 3:
            dataString = 0x00a79d
            
        case 4:
            dataString = 0x8C0000
            
        case 5:
            dataString = 0xE57373
            
        case 6:
            dataString = 0xE57373
            
        case 7:
            dataString = 0xE57373
            
        case 8:
            dataString = 0xE57373
            
            
        default:
            print("invalid")
        }
        return dataString
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
