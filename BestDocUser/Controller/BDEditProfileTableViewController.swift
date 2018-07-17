//
//  BDEditProfileTableViewController.swift
//  BestDocUser
//
//  Created by nitheesh.u on 17/01/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//
import Alamofire
import UIKit
import Photos
import SDWebImage
import UIImageCropper
class BDEditProfileTableViewController: UITableViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imagetableView: UITableViewCell!
    @IBOutlet weak var bloodgroupText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var mobiletext: UITextField!
    @IBOutlet weak var dobText: UITextField!
    @IBOutlet weak var nametext: UITextField!
    @IBOutlet weak var femalebutton: UIButton!
    @IBOutlet weak var maleSelected: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    private let cropper = UIImageCropper(cropRatio: 1/1)

    var pickerflag = Bool()
    var genderID = Int()
   var picker = UIImagePickerController()
    var fileType : String?
    var mimeName : String?
    var errorCode : NSDictionary?
     var cameraFlag = Int()
      var userReg:Any?
    var editImage = UIImage()
     let datePicker = UIDatePicker()
    var profileImageUpdateDetails : NSDictionary?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cropper.delegate = self
        cropper.cropButtonText = "Crop"
        let objCache = SDImageCache.shared()
        objCache.clearMemory()
     //   objCache.cleanDisk()
        profile()
        if let response = logindictionary["response"]as? NSDictionary{
            if let data = response["login"]as? NSDictionary
            {
                userReg = (data["userreg_id"])
                patientRegId = (data["patreg_id"])
                //ownerId = (data["userreg_id"])//
                //  mobilenumber = (data["mobile_number"])
            }}
        else{
            patientRegId = UserDefaults.standard.object(forKey:"patientID") as! Int
            userRegID = UserDefaults.standard.object(forKey:"userRegID") as! Int
            userReg = userRegID
            //patientRegId
        }
        profileImage.layer.borderWidth = 1
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.lightGray.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
      // maleSelected.isSelected = true
        let gesture3 = UITapGestureRecognizer(target: self, action:  #selector (self.someActiontap (_:)))
        let geture = UITapGestureRecognizer(target: self, action:  #selector (self.someActiontapImage (_:)))
        self.imagetableView.addGestureRecognizer(geture)
        self.tableView.addGestureRecognizer(gesture3)
        if let data = UserDefaults.standard.object(forKey:"loginData") as? NSDictionary{
        logindictionary = data
        }

        let gesturetwo = UITapGestureRecognizer(target: self, action:  #selector (self.someAction2 (_:)))
        self.mobiletext.addGestureRecognizer(gesturetwo)
        showDatePicker()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    
    
    // Do any additional setup after loading the view.
}
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        dobText.inputAccessoryView = toolbar
        dobText.inputView = datePicker
        
    }
    
    @objc func donedatePicker(){
        let formatter2 = DateFormatter()
        formatter2.dateFormat =  "yyyy-MM-dd"
        let finaleDate = formatter2.string(from: datePicker.date)
        dobText.text = finaleDate
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    override func viewWillAppear(_ animated: Bool) {
      // profile()
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
                            self.nametext.text = data["first_name"]as? String
                            self.mobiletext.text =  data["mobile_number"]as? String
                            if let dataImage = data["images"]as? NSDictionary{
                            if let image = dataImage["fileUrl"]as? String{
                                let url = URL(string: image)
                                let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                                self.profileImage.image = UIImage(data: data!)
                            }else{
                                self.profileImage.image = UIImage(named: "ic_male")
                            }
                            }
                            self.dobText.text = data["date_of_birth"]as? String
                            self.emailText.text = data["email"]as? String
                            emailDataOne =  (data["email"]as? String)!
                            self.self.emailText.isEnabled = false
                            self.bloodgroupText.text = data["blood_group"]as? String
                            if data["sex"]as! Int == 1{
                                self.maleSelected.isSelected = true
                                self.femalebutton.isSelected = false
                            }
                            else if data["sex"]as! Int == 0{
                                self.femalebutton.isSelected = true
                                self.maleSelected.isSelected = false
                            }
                        }
                       
                        // patientRegId = responseOne["patientId"]as! Int
                        //userRegID = responseOne["userregid"]as! Int
                    }
                }
            }
        }
    }
@objc func someAction2(_ sender:UITapGestureRecognizer){
    registrationStatus = false
    let vc = self.storyboard?.instantiateViewController(withIdentifier: "BDVerificationViewController")as! BDVerificationViewController
    vc.MobileNo =  mobiletext.text!
    vc.ScreenTag = true
    vc.mobileverif = 0
    forginTag = false
    self.navigationController?.show(vc, sender: self)
    
    // do other task
    }
    @objc func someActiontapImage(_ sender:UITapGestureRecognizer){
        image()
        // do other task
    }
    func image(){
        cropper.picker = picker
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        cropper.cancelButtonText = "Retake"
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Camera", comment: ""), style: .default) { _ in
            self.picker.sourceType = .camera
            self.present(self.picker, animated: true, completion: nil)
        })
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Gallery", comment: ""), style: .default) { _ in
            self.picker.sourceType = .photoLibrary
            self.present(self.picker, animated: true, completion: nil)
        })
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: { _ in
        }))
        self.present(alertController, animated: true, completion: nil)
    }

//func openCamera(){
//    if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
//        picker.sourceType = UIImagePickerControllerSourceType.camera
//        self .present(picker, animated: true, completion: nil)
//         cameraFlag = 0
//    }else{
//        let alert = UIAlertView()
//        alert.title = "Warning"
//        alert.message = "You don't have camera"
//        alert.addButton(withTitle: "OK")
//        alert.show()
//    }
//}
//func openGallary(){
//    picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
//    self.present(picker, animated: true, completion: nil)
//      cameraFlag = 1
//}
//MARK:UIImagePickerControllerDelegate
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        pickerflag = true
//        editImage = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
//        profileImage.image=info[UIImagePickerControllerOriginalImage] as? UIImage
//        if cameraFlag == 0{
//            let documentDirectory: NSString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
//            let imageName = "temp"
//            let imagePath = documentDirectory.appendingPathComponent(imageName)
//            if let data = UIImageJPEGRepresentation(profileImage.image!, 80) {
//                do {
//                    try data.write(to: URL(fileURLWithPath: imagePath), options: .atomic)
//                } catch {
//                    print(error)
//                }
//            }
//            mimeName = "image/jpeg"
//            fileType = "P_\(userReg!).jpeg"
//        } else if cameraFlag == 1{
//            let assetPath = info[UIImagePickerControllerReferenceURL] as! NSURL
//            let result = PHAsset.fetchAssets(withALAssetURLs: [assetPath as URL], options: nil)
//            let asset = result.firstObject
//            var fileName = "P_\(userReg!)"
//            mimeName = "image/jpeg"
//            fileType = "\(fileName).jpeg"
//            if fileName == nil {
//
//            fileName = "P_\(userReg!)"
//                fileType = "\(fileName).jpeg"
//            } else {
//                //let fileUrl = URL(string: fileName as! String)
//            fileName = "P_\(userReg!)"
//                 fileType = "\(fileName).jpeg"
//            }
////            if (assetPath.absoluteString?.hasSuffix("JPG"))! {
////                mimeName = "image/jpeg"
////                fileType = "\(fileName).jpeg"
////            } else if (assetPath.absoluteString?.hasSuffix("JPEG"))! {
////                mimeName = "image/jpeg"
////                fileType = "\(fileName).jpeg"
////            } else if (assetPath.absoluteString?.hasSuffix("PNG"))! {
////                mimeName = "image/jpeg"
////                fileType = "\(fileName).jpeg"
////            } else if (assetPath.absoluteString?.hasSuffix("GIF"))! {
////                mimeName = "image/jpeg"
////                fileType = "\(fileName).jpeg"
////            } else if (assetPath.absoluteString?.hasSuffix("SVG"))! {
////                mimeName = "image/jpeg"
////                fileType = "\(fileName).jpeg"
////            } else if (assetPath.absoluteString?.hasSuffix("TIFF"))! {
////                mimeName = "image/jpeg"
////                fileType = "\(fileName).jpeg"
////            }
//        }
//                picker .dismiss(animated: true, completion: nil)
//    }
////    func uploadWithAlamofire() {
////    let imageDa = profileImage.image
//////9744502084
////    // define parameters
////    let parameters = ["file1":fileType,"fileNames":fileType!,"id":userReg,"userType":"5"]as [String:AnyObject]
////    let header = ["Authorization": authTokens]
////        print(parameters)
////        print(header)
////        //"http://35.231.13.2:8080/bestdoc6_dev/webresourcesimage/imageupload"
////   //     uploadImage(urlString:"http://35.231.13.2:8080/bestdoc6_dev/webresources/image/imageupload",headers:header,params:(parameters as? [String : String]),image:imageDa)
////  //      uploadImage (url: String,param : NSDictionary,arrImage: NSArray)
////    }
//
//
////        func uploadWithAlamofire() {
////
////            let imageDa = profileImage.image
////            let parameters = ["file1":"\(fileType!)","fileNames":"\(fileType!)","id":"\(userReg!)","userType":"5"]
////
////            print(parameters)
////            //let header = ["Authorization": authTokens]
////            let progressHUD = ProgressHUD(text: "")
////            self.view.addSubview(progressHUD)
////            // define parameters
////
////
////            Alamofire.upload(multipartFormData: { multipartFormData in
////                if let imageData = UIImageJPEGRepresentation(imageDa!, 1) {
////                    multipartFormData.append(imageData, withName: "p_\(self.userReg!)", fileName: "\(self.fileType!)", mimeType: "image/jpg")
////                }
////
////                for (key, value) in parameters {
////                    multipartFormData.append((value.data(using: .utf8))!, withName: key)
////                }}, to: "http://35.231.13.2:8080/bestdoc6_dev/webresources/image/imageupload", method: .post, headers: ["Authorization": authTokens,"Content-Type": "image/jpg"],
////                    encodingCompletion: { encodingResult in
////                         progressHUD.hide()
////                        switch encodingResult {
////                        case .success(let upload, _, _):
////                            upload.response { [weak self] response in
////                                guard let strongSelf = self else {
////                                    return
////                                }
////                                debugPrint(response)
////                            }
////                        case .failure(let encodingError):
////                            print("error:\(encodingError)")
////                        }
////            })
////
////    }
////    func profileImageUpdateFunction() {
////        var userReg:Any?
////        if let imageDa = profileImage.image{
////            var jpgImage = imageDa.jpeg
////        if let response = logindictionary["response"]as? NSDictionary{
////            if let data = response["login"]as? NSDictionary
////            {
////                userReg = (data["userreg_id"])
////                patientRegId = (data["patreg_id"])
////                //ownerId = (data["userreg_id"])//
////                //  mobilenumber = (data["mobile_number"])
////            }
////        }
////        let progressHUD = ProgressHUD(text: "")
////        self.view.addSubview(progressHUD)
////        let prams  = ["file1":fileType,"fileNames":fileType!,"id":userReg,"userType":5]as [String:AnyObject]
////        BDService.profileImageUpdate(params: prams, imageName: (profileImage.image)!,fileExtension : fileType!,mimeType: mimeName!) {(result, message, status )in
////            progressHUD.hide()
////            if status {
////                let profileImageUpdateDictionary = result as? BDService
////                self.profileImageUpdateDetails = (profileImageUpdateDictionary?.profileImageUpdateData)!
////                if self.profileImageUpdateDetails?["error"] as? NSDictionary != nil
////                {
////                    self.errorCode = self.profileImageUpdateDetails?["error"] as? NSDictionary
////                    if self.errorCode?["attachment"] != nil {
////                        if let attachmentError = (self.errorCode?["attachment"] as? [String]){
////                            for attachmentItem in attachmentError{
////                                self.alertMessage(alerttitle: "", attachmentItem)
////                            }
////                        }
////                    }
////                } else if self.profileImageUpdateDetails?["status"] as? Int == 200 || self.profileImageUpdateDetails?["data"] != nil
////                {
////                    self.alertMessage(alerttitle: "", (self.profileImageUpdateDetails?["msg"] as? String)!)
////                    userProfile = (self.profileImageUpdateDetails?["profile"] as? String)!
////                } else if self.profileImageUpdateDetails?["msg"] as? String == "Unauthorized access"
////                {
////                    self.alertMessage(alerttitle: "", (self.profileImageUpdateDetails?["msg"] as? String)!)
////                }
////            } else {
////                self.alertMessage(alerttitle: "", "Sorry for the inconvenience!!!!!Try again later....")
////            }
////        }
////        }
////    }
    func alertMessage(alerttitle:String,_ message : String){
        let alertViewController = UIAlertController(title:alerttitle,  message:message, preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertViewController, animated: true, completion: nil)
    }
    
//  @objc private func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
//   profileImage.image=info[UIImagePickerControllerOriginalImage] as? UIImage
//       picker .dismiss(animated: true, completion: nil)
//}
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
    print("picker cancel.")
         picker .dismiss(animated: true, completion: nil)
}
    func saveDetails()
    {
        guard(whitespaceValidation(nametext.text!) == true)
            else
        {
            return alert(alertmessage: "Please Enter the name ")
        }
        
        guard(whitespaceValidation(dobText.text!) == true)
            else
        {
            return alert(alertmessage: "Please Enter the Date of Birth")
        }
    
        var userIDDetail:Any?
       
//        let  vc = storyboard?.instantiateViewController(withIdentifier: "BDEditProfileViewController")as!BDEditProfileViewController
//        vc.bloodGp = bloodgroupText.text!
//        vc.name = nametext.text!
//        vc.email = emailText.text!
//        vc.dob = dobText.text!
//        vc.genderID = genderID
        if let response = logindictionary["response"]as? NSDictionary{
            if let data = response["login"]as? NSDictionary
            {
                userIDDetail = (data["userreg_id"])
                patientRegId = (data["patreg_id"])
                //ownerId = (data["userreg_id"])//
                //  mobilenumber = (data["mobile_number"])
            }
        }
        //http://35.231.13.2:8080/bestdoc6_dev/webresources/patient_reg
       // params :
        //address:
       // password:
        //date_of_birth:1994-06-08
       // otp_flag:0
      //  alternate_indian_no:+91 7025408076
       // os_type:1
       // email:clint@bestdocapp.com
       // pat_reg_id:10291
        //user_country_id:1
       // firstName:Roy thomas
       // age:
        //mobile_num:+91 7025408076
       // username:
       // blood_group:Blood+Group
       // sex:1
       // appuser_type:10
        var saveDetails = NSDictionary()
        let para = ["appuser_type":appUserType,"pat_reg_id":patientRegId!,"password":"","date_of_birth":dobText.text as Any,"otp_flag":otp,"alternate_indian_no":phoneNumb,"os_type":2,"email":emailText.text!,"user_country_id":1,"firstName":nametext.text!,"mobile_num":phoneNumb,"username":nametext.text!,"blood_group":bloodgroupText.text as Any,"sex":genderID,"age":"","address":""] as [String : Any]
        let progressHUD = ProgressHUD(text: "")
        self.view.addSubview(progressHUD)
        BDService.register(params: para as [String : AnyObject]){(result, message, status ) in
            progressHUD.hide()
            print(message!)
            print(result!)
            if status {
                let serviceDetails = result as? BDService
                saveDetails = (serviceDetails?.registrationDetails)!
                print(saveDetails)
                if saveDetails["status"]as! Int == 1
                {
                    if (saveDetails["response"]as? NSDictionary) != nil{
                       // self.profile()
                        self.alert(alertmessage: "success")
                       // patientRegId = responseOne["patientId"]as! Int
                        //userRegID = responseOne["userregid"]as! Int
                    }
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   @objc func someActiontap(_ sender:UITapGestureRecognizer){
        self.tableView.endEditing(true)
    }
    @IBAction func maleButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        genderID = 1
         femalebutton.isSelected = false
    }
    
    @IBAction func femaleButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        genderID = 0
         maleSelected.isSelected = false
    }
//    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 100
//    }
//    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let footerView = UIView(frame:CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
//        //(0,0,320,40)
//        let loginButton = UIButton(type: .custom)
//        loginButton.setTitle("Save", for: .normal)
//        loginButton.addTarget(self, action: Selector(("saveAction")), for: .touchUpInside)
//        loginButton.setTitleColor(UIColor.white, for: .normal)
//        loginButton.backgroundColor = UIColor.blue
//        loginButton.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50)
//
//        footerView.addSubview(loginButton)
//
//        return footerView
//    }
    func imageUploadUrl()
    {
       
        let dicImgData : NSMutableDictionary? = NSMutableDictionary()
//
//        if let img = profileImage.image {
//            if let data:Data = UIImagePNGRepresentation(img) {
//                let imageData : Data = data
//                dicImgData! .setObject(imageData, forKey: "data" as NSCopying)
//                dicImgData! .setObject("file", forKey: "name" as NSCopying)
//                dicImgData! .setObject("file.png", forKey: "fileName" as NSCopying)
//                dicImgData! .setObject("image/png", forKey: "type" as NSCopying)
//
//                let dicParameter = ["file1":"p_\(self.userReg!)","fileNames":"p_\(self.userReg!)","id":"\(userReg!)","userType":"5"]
//
//                self.uploadImage(url: "http://35.231.13.2:8080/bestdoc6_dev/webresources/image/imageupload", Parameter: dicParameter as NSDictionary, Images: [dicImgData!])
//            }
//        }
         let headers = ["Authorization": authTokens]
        let parameters =  ["file1":"P_\(self.userReg!)","fileNames":"P_\(self.userReg!)","id":"\(userReg!)","userType":"5"]
         DispatchQueue.global().async {

            Alamofire.upload(multipartFormData:
                {
                    (multipartFormData) in
                    multipartFormData.append(UIImageJPEGRepresentation(self.editImage, 0.1)!, withName: "file1", fileName: "file.jpeg", mimeType: "image/jpeg")
                    for (key, value) in parameters
                    {
                        multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                    }
                   //multipartFormData.
            }, to:"https://api.bestdocapp.com/bestdoc_prod_v7_5_4/webresources/image/imageupload",headers:headers)
            { (result) in
                switch result {
                case .success(let upload,_,_ ):
                    upload.uploadProgress(closure: { (progress) in
                        print(progress)
                    })
                    upload.responseJSON
                        { response in
                            print(response.result)
                            if response.result.value != nil
                            {
                                let dict :NSDictionary = response.result.value! as! NSDictionary
                                let status = dict.value(forKey: "status")as! Bool
                                if status == true
                                {
                                    print("DATA UPLOAD SUCCESSFULLY")
                                }
                            }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                    break
                }
            }
        }
    }
//    func uploadImage (url: String, Parameter param : NSDictionary, Images arrImage: NSArray) -> Void
//    {
//        var requestURL : String! = url
//        let headers = [
//            "Authorization": authTokens,
//            "Accept": "application/json",
//            ]
//
//        print("---------------------")
//        print("Request URL :- \(requestURL)")
//        print("---------------------")
//
//        Alamofire.upload(multipartFormData: { (data) in
//
//            for (key, value) in param {
//                data.append((value as! String).data(using: .utf8)!, withName: key as! String)
//            }
//
//            for imageInfo in arrImage
//            {
//                var dicInfo : NSDictionary! = imageInfo as! NSDictionary
//                data.append(dicInfo["data"] as! Data, withName: dicInfo["name"] as! String, fileName: dicInfo["fileName"] as! String, mimeType: dicInfo["type"] as! String)
//                dicInfo = nil
//            }
//
//        }, to: requestURL, method: .post , headers:headers, encodingCompletion: { (encodeResult) in
//            switch encodeResult {
//            case .success(let upload, _, _):
//
//                upload.responseJSON(completionHandler: { (response) in
//
//                    switch response.result
//                    {
//                    case .success(let responseJSON):
//                        guard let dicResponse = responseJSON as? NSDictionary else{
//                            return
//                        }
//
//                        print("Response : \((dicResponse))")
//
//                    case .failure(let error):
//
//                        print(error)
//
//                        break
//                    }
//                })
//            case .failure(let error):
//                print(error)
//                break
//            }
//        })
//    }
    @IBAction func saveAction(_ sender: UIButton) {
        
        //uploadImage( image:image!)
       
        if pickerflag == true{
           imageUploadUrl()
        }
       // imageUploadUrl()
    //imageUpload()
       //\\ uploadImageAndData()
        //uploadWithAlamofire
    saveDetails()
  //profileImageUpdateFunction()
    }
//    func imageUpload()
//    {
//        let imageData = profileImage.image
//        let parameters =  ["file1":"p_\(self.userReg!)","fileNames":"p_\(self.userReg!)","id":"\(userReg!)","userType":"5"]
//
//        print(parameters)
//
//        let headers = ["Authorization": authTokens,"Content-Type": "image/jpg"]
//
//        Alamofire.upload(multipartFormData: { (multipartFormData) in
//
//            multipartFormData.append(UIImageJPEGRepresentation(imageData!, 0.8)!, withName: "p_\(self.userReg!)", fileName: "\(self.fileType!)", mimeType: "image/jpg")
//
//            for (key, value) in parameters {
//                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
//            }
//
//        }, usingThreshold:UInt64.init(),
//           to: "http://35.231.13.2:8080/bestdoc6_dev/webresources/image/imageupload", //URL Here
//            method: .post,
//            headers: headers, //pass header dictionary here
//            encodingCompletion: { (result) in
//
//                switch result {
//                case .success(let upload, _, _):
//                    print("the status code is :")
//
//                    upload.uploadProgress(closure: { (progress) in
//                        print("something")
//                    })
//
//                    upload.responseJSON { response in
//                        print("the resopnse code is : \(response.response?.statusCode)")
//                        print("the response is : \(response)")
//                    }
//                    break
//                case .failure(let encodingError):
//                    print("the error is  : \(encodingError.localizedDescription)")
//                    break
//                }
//        })
//    }
//    func uploadImage(urlString:String,headers:[String:String]?,params:[String:String]?,image:UIImage?){
//        let boundary: String = "------VohpleBoundary4QuqLuM1cE5lMwCy"
//        let contentType: String = "multipart/form-data; boundary=\(boundary)"
//
//        let request = NSMutableURLRequest()
//        if let tHeaders = headers {
//            for (key, value) in tHeaders {
//                request.setValue(value, forHTTPHeaderField: key)
//            }
//        }
//        request.httpShouldHandleCookies = false
//        request.timeoutInterval = 60
//        request.httpMethod = "POST"
//        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
//
//        let body = NSMutableData()
//        if let parameters = params {
//            for (key, value) in parameters {
//                body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
//                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
//                body.append("\(value)\r\n".data(using: String.Encoding.utf8)!)
//            }
//        }
//        //which field you have to sent image on server
//        let fileName: String = "file"
//        if image != nil {
//            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
//            body.append("Content-Disposition: form-data; name=\"\(fileName)\"; filename=\"image.jpeg\"\r\n".data(using: String.Encoding.utf8)!)
//            body.append("Content-Type:image/jpeg\r\n\r\n".data(using: String.Encoding.utf8)!)
//            body.append(UIImagePNGRepresentation(image!)!)
//            body.append("\r\n".data(using: String.Encoding.utf8)!)
//        }
//        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
//        request.httpBody = body as Data
//        let session = URLSession.shared
//        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
//            if(error != nil){
//                print(response)
//               // print(String(data: data!, encoding: .utf8) ?? "No response from server")
//            }
//        }
//        task.resume()
//    }
//    func saveAction()
//    {
//        print("Hello");
//
//    }
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

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
extension Data{
    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}

extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
}
}
extension BDEditProfileTableViewController: UIImageCropperProtocol {
    func didCropImage(originalImage: UIImage?, croppedImage: UIImage?) {
        pickerflag = true
        profileImage.image = croppedImage
        editImage = croppedImage!
    }
    
    //optional
    func didCancel() {
        picker.dismiss(animated: true, completion: nil)
        print("did cancel")
    }
}
