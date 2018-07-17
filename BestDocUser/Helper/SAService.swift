//
//  SAService.swift
//  surveyApp
//
//  Created by nitheesh.u on 26/02/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//

import UIKit
import Alamofire
class BDService: NSObject {
    enum WebServiceNames: String {
        case baseUrl = "https://api.bestdocapp.com/bestdoc_prod_v7_5_4/webresources"
      //  https://api.bestdocapp.com/bestdoc_prod_v7_5_4/
        //"http://35.231.13.2:8080/bestdoc6_dev/webresources"
        //"https://api.bestdocapp.com/bestdoc_prod_v7_4_9/webresources"
       // http://35.231.13.2:8080/bestdoc6_dev/webresources/patient_details_view
        case district = "/viewlocation/districtsbystateid"
        case region = "/viewlocation/regionsbydistricts"
        case speciality = "/department_speciality_list"
        case clinic = "/clinic_search_by_name"
        case doctor = "/view_location_doctors_by_locationid"
        case doctorProfile = "/doctor_profile_by_patient"
        case bookingExist = "/booking/check_booking_exist"
        case getOp = "/get_opno"
        case login = "/patient_login"
        case resendOtp = "/resend_otp_patient/get_otp"
        case clinicDepartment = "/departments/getDepartmentsInClinic/"
        case session = "/viewSessions/"
        case friendsAndFamily = "/patients_frndandfamily"
        case addFriends = "/addpatient_frndsndfamily"
        case countryCode = "/view_country_details"
        case registratioCheck = "/registration_one"
        case otpVerification = "/registration_two"
        case patientView = "/patient_details_view"
        case register = "/patient_reg"
        case mobileVerification = "/confirm_pat_otp"
        case emailVerification = "/verification/email_otp_verify"
        case resendOtpVerify = "/resend_otp_patient"
        case favoriteList = "/patient/get_favorite_doctors"
        case appoinments = "/patient_bookinglist"
        case patientBooking = "/patient_booking"
        case cancelBooking = "/cancel_booking_patient"
         case docfeedBack = "/add_doctor_feedback"
        case addRating = "/rating_recommendation"
        case viewRating = "/view_rating_recommendation"
        //hms
        case searchOpNumber = "/hms/get_patient_details"
        case forgotOpNumber = "/hms/search_patient_half_opno"
        case listPatientDetails = "/details/list_patient_details"
        case patientDetail = "/add_patient_details"
        case confirmBooking = "/hms/get_amount_details"
        case paymentHashValue = "/paymentgateway/gethashcode"
        case imageUpload = "/image/imageupload"
        case feedBack = "/feedback/addOrUpdateFeedback"
        case ResetPassword = "/forgotpass_reset"
        case addRemovefvite = "/patient/add_or_remove_favorite_doctor"
        case resetpasswordChane = "/forgotpasschange"
        case deletefriends = "/addpatient_frndsndfamily/delete_pat_friendsandFamily"
        case hmsBooking = "/make_booking"
        case logout = "/logout_patient"
        // case Login   = "patient_login"
    }
    var viewRating = NSDictionary()
    var cancelBooking = NSDictionary()
    var hmsBooking = NSDictionary()
    var feedBack = NSDictionary()
    var patientBooking = NSDictionary()
    var profileImageUpdateData : NSDictionary?
    var confirmBookigData = NSDictionary()
    var districts = NSDictionary()
    var region = NSDictionary()
    var speciality = NSDictionary()
    var clinic = NSDictionary()
    var doctor = NSDictionary()
    var doctorProfiledic =  NSDictionary()
    var checkDict =  NSDictionary()
    var OpnumberDetails = NSDictionary()
    var loginDic = NSDictionary()
    var resendOtp = NSDictionary()
    var clinicDepDetailsDic = NSDictionary()
    var sessionDic = NSDictionary()
    var friendslist = NSDictionary()
    var addFriendsDict = NSDictionary()
    var countryCodeDetails = NSDictionary()
    var registrationCheck = NSDictionary()
    var otpDic = NSDictionary()
    var patientViewDic = NSDictionary()
    var registrationDetails = NSDictionary()
    var mobileVerificationDic = NSDictionary()
    var emailVerificationDic = NSDictionary()
    var resendOtpVerifyDic = NSDictionary()
    var favouriteListDic = NSDictionary()
    var appoinmentList = NSDictionary()
    var hmsSearchDetails = NSDictionary()
    var forgotOpnumberDetails = NSDictionary()
    var listPatientDetails = NSDictionary()
    var savepatientDetails = NSDictionary()
    var hashcodedata = NSDictionary()
    var imageUpload = NSDictionary()
    var ResetPassword = NSDictionary()
    var addRemove = NSDictionary()
    var patientDetailsForEdit = NSDictionary()
    var resetPasswordChange = NSDictionary()
    var deleteFriends = NSDictionary()
    var logout = NSDictionary()
    var docfeedABck = NSDictionary()
    var addRating = NSDictionary()
    // MARK :- Profile Image Update
    class func profileImageUpdate(params:[String:AnyObject],imageName: UIImage,fileExtension: String,mimeType:String, completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        let url = WebServiceNames.baseUrl.rawValue + WebServiceNames.imageUpload.rawValue
        let params = params
        BDService.postWebServiceWithImage(urlString: url, params: params as [String : AnyObject], imageToUploadURL: imageName,fileType: fileExtension,mimeName: mimeType, token: authTokens) { (response, message, status) in
            print(response ?? "Error")
            let result = BDService()
            if let data = response as? NSDictionary {
                print(data)
               // result.contactUsData = data
                result.profileImageUpdateData = data
                completion(result, "Success", true)
            }else {
                completion("" as AnyObject?, "Failed", false)
            }
        }
    }
    // MARK :- addRemove
    class func addRemove( params:[String:AnyObject], completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        let url = WebServiceNames.baseUrl.rawValue+WebServiceNames.addRemovefvite.rawValue
        let parameter = params
        BDService.alamofireFunctionWithRegisterHeader(urlString: url, method: .post, parameters: parameter, token: authTokens){ (response, message, status) in
            print(response ?? "Error")
            let result = BDService()
            if let data = response as? NSDictionary {
                result.addRemove = data
                completion(result, "Success", true)
            }else {
                completion("" as AnyObject?, "Failed", false)
            }
        }
    }
    // MARK :- rating
    class func addRating( params:[String:AnyObject], completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        let url = WebServiceNames.baseUrl.rawValue+WebServiceNames.addRating.rawValue
        let parameter = params
        BDService.alamofireFunctionWithRegisterHeader(urlString: url, method: .post, parameters: parameter, token: authTokens){ (response, message, status) in
            print(response ?? "Error")
            let result = BDService()
            if let data = response as? NSDictionary {
                result.addRating = data
                completion(result, "Success", true)
            }else {
                completion("" as AnyObject?, "Failed", false)
            }
        }
    }
    // MARK :- viewrating
    class func showRating( params:[String:AnyObject], completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        let url = WebServiceNames.baseUrl.rawValue+WebServiceNames.viewRating.rawValue
        let parameter = params
        BDService.alamofireFunctionWithRegisterHeader(urlString: url, method: .post, parameters: parameter, token: authTokens){ (response, message, status) in
            print(response ?? "Error")
            let result = BDService()
            if let data = response as? NSDictionary {
                result.viewRating = data
                completion(result, "Success", true)
            }else {
                completion("" as AnyObject?, "Failed", false)
            }
        }
    }
    // MARK :- cancelBooking
    class func cancelBooking( params:[String:AnyObject], completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        let url = WebServiceNames.baseUrl.rawValue+WebServiceNames.cancelBooking.rawValue
        let parameter = params
        BDService.alamofireFunctionWithRegisterHeader(urlString: url, method: .post, parameters: parameter, token: authTokens){ (response, message, status) in
            print(response ?? "Error")
            let result = BDService()
            if let data = response as? NSDictionary {
                result.cancelBooking = data
                completion(result, "Success", true)
            }else {
                completion("" as AnyObject?, "Failed", false)
            }
        }
    }
    // MARK :- cancelBooking
    class func docFeedBack( params:[String:AnyObject], completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        let url = WebServiceNames.baseUrl.rawValue+WebServiceNames.docfeedBack.rawValue
        let parameter = params
        BDService.alamofireFunctionWithRegisterHeader(urlString: url, method: .post, parameters: parameter, token: authTokens){ (response, message, status) in
            print(response ?? "Error")
            let result = BDService()
            if let data = response as? NSDictionary {
                result.docfeedABck = data
                completion(result, "Success", true)
            }else {
                completion("" as AnyObject?, "Failed", false)
            }
        }
    }
    // MARK :- logout
    class func logout( params:[String:AnyObject], completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        let url = WebServiceNames.baseUrl.rawValue+WebServiceNames.logout.rawValue
        let parameter = params
        BDService.alamofireFunctionWithRegisterHeader(urlString: url, method: .post, parameters: parameter, token: authTokens){ (response, message, status) in
            print(response ?? "Error")
            let result = BDService()
            if let data = response as? NSDictionary {
                result.logout = data
                completion(result, "Success", true)
            }else {
                completion("" as AnyObject?, "Failed", false)
            }
        }
    }
    // MARK :- addRemove
    class func deleteFriendsFamily( params:[String:AnyObject], completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        let url = WebServiceNames.baseUrl.rawValue+WebServiceNames.deletefriends.rawValue
        let parameter = params
        BDService.alamofireFunctionWithRegisterHeader(urlString: url, method: .post, parameters: parameter, token: authTokens){ (response, message, status) in
            print(response ?? "Error")
            let result = BDService()
            if let data = response as? NSDictionary {
                result.deleteFriends = data
                completion(result, "Success", true)
            }else {
                completion("" as AnyObject?, "Failed", false)
            }
        }
    }
    // MARK :- patientView
    class func patientView(params:[String:AnyObject], completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        let url = WebServiceNames.baseUrl.rawValue+WebServiceNames.patientView.rawValue
        let parameter = params
        BDService.alamofireFunctionWithRegisterHeader(urlString: url, method: .post, parameters: parameter, token: authTokens){ (response, message, status) in
            print(response ?? "Error")
            let result = BDService()
            if let data = response as? NSDictionary {
                result.patientDetailsForEdit = data
                completion(result, "Success", true)
            }else {
                completion("" as AnyObject?, "Failed", false)
            }
        }
    }
    // MARK :- Get District
    class func getDistrict( params:[String:AnyObject], completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        let url = WebServiceNames.baseUrl.rawValue+WebServiceNames.district.rawValue
        let parameter = params
        BDService.alamofireFunctionWithRegisterHeader(urlString: url, method: .post, parameters: parameter, token: authTokens){ (response, message, status) in
            print(response ?? "Error")
            let result = BDService()
            if let data = response as? NSDictionary {
                result.districts = data
                completion(result, "Success", true)
            }else {
                completion("" as AnyObject?, "Failed", false)
            }
        }
    }
    // MARK :- ResetPassword
    class func resetPAssword( params:[String:AnyObject], completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        let url = WebServiceNames.baseUrl.rawValue+WebServiceNames.ResetPassword.rawValue
        let parameter = params
        BDService.alamofireFunctionWithRegisterHeader(urlString: url, method: .post, parameters: parameter, token: authTokens){ (response, message, status) in
            print(response ?? "Error")
            let result = BDService()
            if let data = response as? NSDictionary {
                result.ResetPassword = data
                completion(result, "Success", true)
            }else {
                completion("" as AnyObject?, "Failed", false)
            }
        }
    }
    // MARK :- ResetPasswordChange
    class func resetPasswordChange( params:[String:AnyObject], completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        let url = WebServiceNames.baseUrl.rawValue+WebServiceNames.resetpasswordChane.rawValue
        let parameter = params
        BDService.alamofireFunctionWithRegisterHeader(urlString: url, method: .post, parameters: parameter, token: authTokens){ (response, message, status) in
            print(response ?? "Error")
            let result = BDService()
            if let data = response as? NSDictionary {
                result.resetPasswordChange = data
                completion(result, "Success", true)
            }else {
                completion("" as AnyObject?, "Failed", false)
            }
        }
    }
    // MARK :- Get FeedBack
    class func feedBack( params:[String:AnyObject], completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        let url = WebServiceNames.baseUrl.rawValue+WebServiceNames.feedBack.rawValue
        let parameter = params
        BDService.alamofireFunctionWithRegisterHeader(urlString: url, method: .post, parameters: parameter, token: authTokens){ (response, message, status) in
            print(response ?? "Error")
            let result = BDService()
            if let data = response as? NSDictionary {
                result.feedBack = data
                completion(result, "Success", true)
            }else {
                completion("" as AnyObject?, "Failed", false)
            }
        }
    }
    // MARK :- postBooking
    class func booking( params:[String:AnyObject], completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        let url = WebServiceNames.baseUrl.rawValue+WebServiceNames.patientBooking.rawValue
        let parameter = params
        BDService.alamofireFunctionWithRegisterHeader(urlString: url, method: .post, parameters: parameter, token: authTokens){ (response, message, status) in
            print(response ?? "Error")
            let result = BDService()
            if let data = response as? NSDictionary {
                result.patientBooking = data
                completion(result, "Success", true)
            }else {
                completion("" as AnyObject?, "Failed", false)
            }
        }
    }
    // MARK :- hmspostBooking
    class func hmsbooking( params:[String:AnyObject], completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        let url = WebServiceNames.baseUrl.rawValue+WebServiceNames.hmsBooking.rawValue
        let parameter = params
        BDService.alamofireFunctionWithRegisterHeader(urlString: url, method: .post, parameters: parameter, token: authTokens){ (response, message, status) in
            print(response ?? "Error")
            let result = BDService()
            if let data = response as? NSDictionary {
                result.hmsBooking = data
                completion(result, "Success", true)
            }else {
                completion("" as AnyObject?, "Failed", false)
            }
        }
    }
   
    // MARK :- Get HashCode
    class func getHashCode( params:[String:AnyObject], completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        let url = WebServiceNames.baseUrl.rawValue+WebServiceNames.paymentHashValue.rawValue
        let parameter = params
        BDService.alamofireFunctionWithRegisterHeaderjson(urlString: url, method: .post, parameters: parameter, token: authTokens){ (response, message, status) in
            print(response ?? "Error")
            let result = BDService()
            if let data = response as? NSDictionary {
                result.hashcodedata = data
                completion(result, "Success", true)
            }else {
                completion("" as AnyObject?, "Failed", false)
            }
        }
    }
     // MARK :- CONFIRM BOOKING
    class func confirmBooking( params:[String:AnyObject], completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        let url = WebServiceNames.baseUrl.rawValue+WebServiceNames.confirmBooking.rawValue
        let parameter = params
        BDService.alamofireFunctionWithRegisterHeader(urlString: url, method: .post, parameters: parameter, token: authTokens){ (response, message, status) in
            print(response ?? "Error")
            let result = BDService()
            if let data = response as? NSDictionary {
                result.confirmBookigData = data
                completion(result, "Success", true)
            }else {
                completion("" as AnyObject?, "Failed", false)
            }
        }
    }
    // MARK :- savePatientDetails
    class func savePatientDetails( params:[String:AnyObject], completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        let url = WebServiceNames.baseUrl.rawValue+WebServiceNames.patientDetail.rawValue
        let parameter = params
        BDService.alamofireFunctionWithRegisterHeader(urlString: url, method: .post, parameters: parameter, token: authTokens){ (response, message, status) in
            print(response ?? "Error")
            let result = BDService()
            if let data = response as? NSDictionary {
                result.savepatientDetails = data
                completion(result, "Success", true)
            }else {
                completion("" as AnyObject?, "Failed", false)
            }
        }
    }
    // MARK :- listPatientDetails
    class func listPatientDetails( params:[String:AnyObject], completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        let url = WebServiceNames.baseUrl.rawValue+WebServiceNames.listPatientDetails.rawValue
        let parameter = params
        BDService.alamofireFunctionWithRegisterHeader(urlString: url, method: .post, parameters: parameter, token: authTokens){ (response, message, status) in
            print(response ?? "Error")
            let result = BDService()
            if let data = response as? NSDictionary {
                result.listPatientDetails = data
                completion(result, "Success", true)
            }else {
                completion("" as AnyObject?, "Failed", false)
            }
        }
    }
    // MARK :- forgotOpNumber
    class func forgotOpNumber( params:[String:AnyObject], completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        let url = WebServiceNames.baseUrl.rawValue+WebServiceNames.forgotOpNumber.rawValue
        let parameter = params
        BDService.alamofireFunctionWithRegisterHeader(urlString: url, method: .post, parameters: parameter, token: authTokens){ (response, message, status) in
            print(response ?? "Error")
            let result = BDService()
            if let data = response as? NSDictionary {
                result.forgotOpnumberDetails = data
                completion(result, "Success", true)
            }else {
                completion("" as AnyObject?, "Failed", false)
            }
        }
    }
    // MARK :- searchOPNumber
    class func searchOPNumber( params:[String:AnyObject], completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        let url = WebServiceNames.baseUrl.rawValue+WebServiceNames.searchOpNumber.rawValue
        let parameter = params
        BDService.alamofireFunctionWithRegisterHeader(urlString: url, method: .post, parameters: parameter, token: authTokens){ (response, message, status) in
            print(response ?? "Error")
            let result = BDService()
            if let data = response as? NSDictionary {
                result.hmsSearchDetails = data
                completion(result, "Success", true)
            }else {
                completion("" as AnyObject?, "Failed", false)
            }
        }
    }
    // MARK :- Get Favourite
    class func postFavourite( params:[String:AnyObject], completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        let url = WebServiceNames.baseUrl.rawValue+WebServiceNames.favoriteList.rawValue
        let parameter = params
        BDService.alamofireFunctionWithRegisterHeader(urlString: url, method: .post, parameters: parameter, token: authTokens){ (response, message, status) in
            print(response ?? "Error")
            let result = BDService()
            if let data = response as? NSDictionary {
                result.favouriteListDic = data
                completion(result, "Success", true)
            }else {
                completion("" as AnyObject?, "Failed", false)
            }
        }
    }
    // MARK :- Get appoinments
    class func postAppoinments( params:[String:AnyObject], completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        let url = WebServiceNames.baseUrl.rawValue+WebServiceNames.appoinments.rawValue
        let parameter = params
        BDService.alamofireFunctionWithRegisterHeader(urlString: url, method: .post, parameters: parameter, token: authTokens){ (response, message, status) in
            print(response ?? "Error")
            let result = BDService()
            if let data = response as? NSDictionary {
                result.appoinmentList = data
                completion(result, "Success", true)
            }else {
                completion("" as AnyObject?, "Failed", false)
            }
        }
    }
    // MARK :- resendOtpverification
    class func resendOtpverification( params:[String:AnyObject], completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        let url = WebServiceNames.baseUrl.rawValue+WebServiceNames.resendOtpVerify.rawValue
        let parameter = params
        BDService.alamofireFunctionWithRegisterHeader(urlString: url, method: .post, parameters: parameter, token: authTokens){ (response, message, status) in
            print(response ?? "Error")
            let result = BDService()
            if let data = response as? NSDictionary {
                result.resendOtpVerifyDic = data
                completion(result, "Success", true)
            }else {
                completion("" as AnyObject?, "Failed", false)
            }
        }
    }
    // MARK :- MobileVerification
    class func mobileVerify( params:[String:AnyObject], completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        let url = WebServiceNames.baseUrl.rawValue+WebServiceNames.mobileVerification.rawValue
        let parameter = params
        BDService.alamofireFunctionWithRegisterHeader(urlString: url, method: .post, parameters: parameter, token: authTokens){ (response, message, status) in
            print(response ?? "Error")
            let result = BDService()
            if let data = response as? NSDictionary {
                result.mobileVerificationDic = data
                completion(result, "Success", true)
            }else {
                completion("" as AnyObject?, "Failed", false)
            }
        }
    }
    // MARK :- EmailVerification
    class func emailVerify( params:[String:AnyObject], completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        let url = WebServiceNames.baseUrl.rawValue+WebServiceNames.emailVerification.rawValue
        let parameter = params
        BDService.alamofireFunctionWithRegisterHeader(urlString: url, method: .post, parameters: parameter, token: authTokens){ (response, message, status) in
            print(response ?? "Error")
            let result = BDService()
            if let data = response as? NSDictionary {
                result.emailVerificationDic = data
                completion(result, "Success", true)
            }else {
                completion("" as AnyObject?, "Failed", false)
            }
        }
    }
    // MARK :- checkRegistrationOne
    class func checkRegistration( params:[String:AnyObject], completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        let url = WebServiceNames.baseUrl.rawValue+WebServiceNames.registratioCheck.rawValue
        let parameter = params
        BDService.alamofireFunctionWithRegisterHeader(urlString: url, method: .post, parameters: parameter, token: authTokens){ (response, message, status) in
            print(response ?? "Error")
            let result = BDService()
            if let data = response as? NSDictionary {
                result.registrationCheck = data
                completion(result, "Success", true)
            }else {
                completion("" as AnyObject?, "Failed", false)
            }
        }
    }
    // MARK :- registration
    class func register( params:[String:AnyObject], completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        let url = WebServiceNames.baseUrl.rawValue+WebServiceNames.register.rawValue
        let parameter = params
        BDService.alamofireFunctionWithRegisterHeader(urlString: url, method: .post, parameters: parameter, token: authTokens){ (response, message, status) in
            print(response ?? "Error")
            let result = BDService()
            if let data = response as? NSDictionary {
                result.registrationDetails = data
                completion(result, "Success", true)
            }else {
                completion("" as AnyObject?, "Failed", false)
            }
        }
    }
    // MARK :- Get FriendsList
    class func getFriendsList( params:[String:AnyObject], completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        let url = WebServiceNames.baseUrl.rawValue+WebServiceNames.friendsAndFamily.rawValue
        let parameter = params
        BDService.alamofireFunctionWithRegisterHeader(urlString: url, method: .post, parameters: parameter, token: authTokens){ (response, message, status) in
            print(response ?? "Error")
            let result = BDService()
            if let data = response as? NSDictionary {
                result.friendslist = data
                completion(result, "Success", true)
            }else {
                completion("" as AnyObject?, "Failed", false)
            }
        }
    }
    // MARK :- AddFriends
    class func addFriends( params:[String:AnyObject], completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        let url = WebServiceNames.baseUrl.rawValue+WebServiceNames.addFriends.rawValue
        let parameter = params
        BDService.alamofireFunctionWithRegisterHeader(urlString: url, method: .post, parameters: parameter, token: authTokens){ (response, message, status) in
            print(response ?? "Error")
            let result = BDService()
            if let data = response as? NSDictionary {
                result.addFriendsDict = data
                completion(result, "Success", true)
            }else {
                completion("" as AnyObject?, "Failed", false)
            }
        }
    }
    // MARK :- Get Region
    class func getRegion( params:[String:AnyObject], completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        let url = WebServiceNames.baseUrl.rawValue+WebServiceNames.region.rawValue
        let parameter = params
        BDService.alamofireFunctionWithRegisterHeader(urlString: url, method: .post, parameters: parameter, token: authTokens){ (response, message, status) in
            print(response ?? "Error")
            let result = BDService()
            if let data = response as? NSDictionary {
                
                result.region = data
                
                completion(result, "Success", true)
            }else {
                completion("" as AnyObject?, "Failed", false)
            }
        }
        
    }
    // MARK :- verifyOtp
    class func verifyOtp( params:[String:AnyObject], completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        let url = WebServiceNames.baseUrl.rawValue+WebServiceNames.otpVerification.rawValue
        let parameter = params
        BDService.alamofireFunctionWithRegisterHeader(urlString: url, method: .post, parameters: parameter, token: authTokens){ (response, message, status) in
            print(response ?? "Error")
            let result = BDService()
            if let data = response as? NSDictionary {
                
                result.otpDic = data
                
                completion(result, "Success", true)
            }else {
                completion("" as AnyObject?, "Failed", false)
            }
        }
        
    }
    // MARK :- patientDetailsview
    class func patientDetailsview( params:[String:AnyObject], completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        let url = WebServiceNames.baseUrl.rawValue+WebServiceNames.patientView.rawValue
        let parameter = params
        BDService.alamofireFunctionWithRegisterHeader(urlString: url, method: .post, parameters: parameter, token: authTokens){ (response, message, status) in
            print(response ?? "Error")
            let result = BDService()
            if let data = response as? NSDictionary {
             result.patientViewDic = data
             completion(result, "Success", true)
            }else {
                completion("" as AnyObject?, "Failed", false)
            }
        }
        
    }
    
    
    // MARK :- Get Speciality
    class func getSpeciality( params:[String:AnyObject], completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        let url = WebServiceNames.baseUrl.rawValue+WebServiceNames.speciality.rawValue
        print(url)
        let parameter = params
        print(parameter)
        BDService.alamofireFunctionWithRegisterHeader(urlString: url, method: .post, parameters: parameter, token: authTokens){ (response, message, status) in
            
            print(response ?? "Error")
            let result = BDService()
            if let data = response as? NSDictionary {
                result.speciality = data
                completion(result, "Success", true)
            }else {
                completion("" as AnyObject?, "Failed", false)
            }
        }
        
    }
    // MARK :- Get Clinic
    class func getClinic( params:[String:AnyObject], completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        let url = WebServiceNames.baseUrl.rawValue+WebServiceNames.clinic.rawValue
        let parameter = params
        BDService.alamofireFunctionWithRegisterHeader(urlString: url, method: .post, parameters: parameter, token: authTokens){ (response, message, status) in
            print(response ?? "Error")
            let result = BDService()
            if let data = response as? NSDictionary {
                
                result.clinic = data
                
                completion(result, "Success", true)
            }else {
                completion("" as AnyObject?, "Failed", false)
            }
        }
        
    }
    // MARK :- Get Doctor
    class func getDoctor( params:[String:AnyObject], completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        let url = WebServiceNames.baseUrl.rawValue+WebServiceNames.doctor.rawValue
        let parameter = params
        BDService.alamofireFunctionWithRegisterHeader(urlString: url, method: .post, parameters: parameter, token: authTokens){ (response, message, status) in
            print(response ?? "Error")
            let result = BDService()
            if let data = response as? NSDictionary {
                
                result.doctor = data
                
                completion(result, "Success", true)
            }else {
                completion("" as AnyObject?, "Failed", false)
            }
        }
    }
    // MARK :- Get DoctorProfile
    class func getDoctorProfile( params:[String:AnyObject], completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        let url = WebServiceNames.baseUrl.rawValue+WebServiceNames.doctorProfile.rawValue
        //"/http://192.168.1.153:8081/bestdoc6_dev/webresources/doctor_profile_by_patient"
        //WebServiceNames.baseUrl.rawValue+WebServiceNames.doctorProfile.rawValue
        let parameter = params
        BDService.alamofireFunctionWithRegisterHeader(urlString: url, method: .post, parameters: parameter,token: authTokens){ (response, message, status) in
            print(response ?? "Error")
            let result = BDService()
            if let data = response as? NSDictionary {
                result.doctorProfiledic = data
                completion(result, "Success", true)
            }else {
                completion("" as AnyObject?, "Failed", false)
            }
        }
    }
    // MARK :- checkBox
    class func checkBoxResponse( params:[String:AnyObject], completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        let url = WebServiceNames.baseUrl.rawValue+WebServiceNames.bookingExist.rawValue
        let parameter = params
        BDService.alamofireFunctionWithRegisterHeader(urlString: url, method: .post, parameters: parameter, token: authTokens){ (response, message, status) in
            print(response ?? "Error")
            let result = BDService()
            if let data = response as? NSDictionary {
                result.checkDict = data
                completion(result, "Success", true)
            }else {
                completion("" as AnyObject?, "Failed", false)
            }
        }
    }
    // MARK :- getOtp
    class func getOtp( params:[String:AnyObject], completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        let url = WebServiceNames.baseUrl.rawValue+WebServiceNames.getOp.rawValue
        let parameter = params
        BDService.alamofireFunctionWithRegisterHeader(urlString: url, method: .post, parameters: parameter, token: authTokens){ (response, message, status) in
            print(response ?? "Error")
            let result = BDService()
            if let data = response as? NSDictionary {
                result.OpnumberDetails = data
                completion(result, "Success", true)
            }else {
                completion("" as AnyObject?, "Failed", false)
            }
        }
    }
    // MARK :-login
    class func login( params:[String:AnyObject], completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        let url = WebServiceNames.baseUrl.rawValue+WebServiceNames.login.rawValue
        let parameter = params
        BDService.alamofireFunctionWithRegisterHeader(urlString: url, method: .post, parameters: parameter, token: authTokens){ (response, message, status) in
            print(response ?? "Error")
            let result = BDService()
            if let data = response as? NSDictionary {
                result.loginDic = data
                completion(result, "Success", true)
            }else {
                completion("" as AnyObject?, "Failed", false)
            }
        }
    }
    // MARK :-resendOtp
    class func resendOtp( params:[String:AnyObject], completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        let url = WebServiceNames.baseUrl.rawValue+WebServiceNames.resendOtp.rawValue
        let parameter = params
        BDService.alamofireFunctionWithRegisterHeader(urlString: url, method: .post, parameters: parameter, token: authTokens){ (response, message, status) in
            print(response ?? "Error")
            let result = BDService()
            if let data = response as? NSDictionary {
                result.resendOtp = data
                completion(result, "Success", true)
            }else {
                completion("" as AnyObject?, "Failed", false)
            }
        }
    }
    //  Mark:- getdepartment
    class func getdepartment( params:[String:AnyObject], completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        let url = WebServiceNames.baseUrl.rawValue+WebServiceNames.clinicDepartment.rawValue
        let parameter = params
        _ =   ["Authorization" : authTokens]
        
        BDService.alamofireFunctionWithRegisterHeader(urlString: url, method: .get, parameters: parameter, token: authTokens){ (response, message, status) in
            
            print(response ?? "Error")
            let result = BDService()
            if let data = response as? NSDictionary {
                result.clinicDepDetailsDic = data
                completion(result, "Success", true)
            }else {
                completion("" as AnyObject?, "Failed", false)
            }
        }
    }
    //  Mark:- getCountryList
    class func getCountryList( params:[String:AnyObject], completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        let url = WebServiceNames.baseUrl.rawValue+WebServiceNames.countryCode.rawValue
        let parameter = params
        _ =   ["Authorization" : authTokens]
        
        BDService.alamofireFunctionWithRegisterHeader(urlString: url, method: .get, parameters: parameter, token: authTokens){ (response, message, status) in
            
            print(response ?? "Error")
            let result = BDService()
            if let data = response as? NSDictionary {
                result.countryCodeDetails = data
                completion(result, "Success", true)
            }else {
                completion("" as AnyObject?, "Failed", false)
            }
        }
    }
    //Mark:-viewSession
    class func viewSession( params:[String:AnyObject], completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        let url = WebServiceNames.baseUrl.rawValue+WebServiceNames.session.rawValue
        let parameter = params
        //_ =   ["Authorization" : authTokens]
        
        BDService.alamofireFunctionWithRegisterHeader(urlString: url, method: .get, parameters: parameter, token: authTokens){ (response, message, status) in
            
            print(response ?? "Error")
            let result = BDService()
            if let data = response as? NSDictionary {
                result.sessionDic = data
                completion(result, "Success", true)
            }else {
                completion("" as AnyObject?, "Failed", false)
            }
        }
    }
    
    /****************************************/
    //MARK :- Get
    class func getWebService(urlString: String, params: [String : AnyObject], completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> Void) {
        alamofireFunction(urlString: urlString, method: .get, paramters: params) { (response, message, success) in
            if response != nil {
                completion(response as AnyObject?, "", true)
            }else{
                completion(nil, "", false)
            }
        }
    }
    
    //MARK :- Post
    class func postWebService(urlString: String, params: [String : AnyObject], completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> Void) {
        alamofireFunction(urlString: urlString, method: .post, paramters: params) { (response, message, success) in
            if response != nil {
                completion(response as AnyObject?, "", true)
            }else{
                completion(nil, "", false)
            }
        }
    }
    
    class func alamofireFunction(urlString : String, method : Alamofire.HTTPMethod, paramters : [String : AnyObject], completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> Void){
        
        if method == Alamofire.HTTPMethod.post {
            Alamofire.request(urlString, method: .post, parameters: paramters, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
                
                print(urlString)
                
                if response.result.isSuccess{
                    completion(response.result.value as AnyObject?, "", true)
                }else{
                    completion(nil, "", false)
                }
            }
        } else {
            Alamofire.request(urlString).responseJSON { (response) in
                
                if response.result.isSuccess{
                    completion(response.result.value as AnyObject?, "", true)
                }else{
                    completion(nil, "", false)
                }
            }
        }
    }
    
    //MARK :- PostWithHeader
    class func postWebServiceWithRegisterHeader(urlString: String, params: [String : AnyObject], AuthToken: String, completion : @escaping ( _ response : AnyObject?,  _ message: String?, _ success : Bool)-> Void) {
        alamofireFunctionWithRegisterHeader(urlString: urlString, method: .post, parameters: params, token: AuthToken) { (response, message, success) in
            if response != nil {
                completion(response as AnyObject?, "", true)
            } else{
                completion(nil, "", false)
            }
        }
    }
    
    class func postWebServiceWithTokenHeader(urlString: String, params: [String : AnyObject], urlToken: String, completion : @escaping ( _ response : AnyObject?,  _ message: String?, _ success : Bool)-> Void) {
        alamofireFunctionWithTokenHeader(urlString: urlString, method: .post, parameters: params, token: urlToken) { (response, message, success) in
            if response != nil {
                completion(response as AnyObject?, "", true)
            }else{
                completion(nil, "", false)
            }
        }
    }
    
    class func postWebServiceWithUserHeader(urlString: String, params: [String : AnyObject], urlToken: String, completion : @escaping ( _ response : AnyObject?,  _ message: String?, _ success : Bool)-> Void) {
        alamofireFunctionWithUserHeader(urlString: urlString, method: .post, parameters: params, token: urlToken) { (response, message, success) in
            if response != nil {
                completion(response as AnyObject?, "", true)
            }else{
                completion(nil, "", false)
            }
        }
    }
    
    //Location Header
    class func postWebServiceWithLocationHeader(urlString: String, params: [String : AnyObject], AuthToken: String, completion : @escaping ( _ response : AnyObject?,  _ message: String?, _ success : Bool)-> Void) {
        alamofireFunctionWithLocationHeader(urlString: urlString, method: .post, parameters: params, token: AuthToken) { (response, message, success) in
            if response != nil {
                completion(response as AnyObject?, "", true)
            }else{
                completion(nil, "", false)
            }
        }
    }
    class func alamofireFunctionWithRegisterHeaderjson(urlString : String, method : Alamofire.HTTPMethod, parameters : [String : AnyObject], token: String, completion : @escaping ( _ response : AnyObject?,  _ message: String?, _ success : Bool)-> Void){
        
        if method == Alamofire.HTTPMethod.post {
            Alamofire.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Authorization" : token]).responseJSON { (response:DataResponse<Any>) in
                print(urlString)
                
                if response.result.isSuccess{
                    completion(response.result.value as AnyObject?, "", true)
                }else{
                    completion(nil, "", false)
                }
            }
            
        }
    }
    class func alamofireFunctionWithRegisterHeader(urlString : String, method : Alamofire.HTTPMethod, parameters : [String : AnyObject], token: String, completion : @escaping ( _ response : AnyObject?,  _ message: String?, _ success : Bool)-> Void){
        
        if method == Alamofire.HTTPMethod.post {
            Alamofire.request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: ["Authorization" : token]).responseJSON { (response:DataResponse<Any>) in
                print(urlString)
                
                if response.result.isSuccess{
                    completion(response.result.value as AnyObject?, "", true)
                }else{
                    completion(nil, "", false)
                }
            }
            
        }else if method == Alamofire.HTTPMethod.get {
            Alamofire.request(urlString, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: ["Authorization" : token]).responseJSON { (response:DataResponse<Any>) in
                print(urlString)
                
                if response.result.isSuccess{
                    completion(response.result.value as AnyObject?, "", true)
                }else{
                    completion(nil, "", false)
                }
            }
        }
        else{
            
            Alamofire.request(urlString).responseJSON { (response) in
                if response.result.isSuccess{
                    completion(response.result.value as AnyObject?, "", true)
                }else{
                    completion(nil, "", false)
                }
            }
        }
        
    }
    
    class func alamofireFunctionWithTokenHeader(urlString : String, method : Alamofire.HTTPMethod, parameters : [String : AnyObject], token: String, completion : @escaping ( _ response : AnyObject?,  _ message: String?, _ success : Bool)-> Void){
        
        if method == Alamofire.HTTPMethod.post {
            Alamofire.request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: ["token" : token]).responseJSON { (response:DataResponse<Any>) in
                print(urlString)
                
                if response.result.isSuccess{
                    completion(response.result.value as AnyObject?, "", true)
                }else{
                    completion(nil, "", false)
                }
            }
            
        }else {
            Alamofire.request(urlString).responseJSON { (response) in
                if response.result.isSuccess{
                    completion(response.result.value as AnyObject?, "", true)
                }else{
                    completion(nil, "", false)
                }
            }
        }
    }
    
    class func alamofireFunctionWithUserHeader(urlString : String, method : Alamofire.HTTPMethod, parameters : [String : AnyObject], token: String, completion : @escaping ( _ response : AnyObject?,  _ message: String?, _ success : Bool)-> Void){
        
        if method == Alamofire.HTTPMethod.post {
            Alamofire.request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: ["usrtoken" : token]).responseJSON { (response:DataResponse<Any>) in
                print(urlString)
                
                if response.result.isSuccess{
                    completion(response.result.value as AnyObject?, "", true)
                }else{
                    completion(nil, "", false)
                }
            }
            
        }else {
            Alamofire.request(urlString).responseJSON { (response) in
                if response.result.isSuccess{
                    completion(response.result.value as AnyObject?, "", true)
                }else{
                    completion(nil, "", false)
                }
            }
        }
    }
    
    //Location Header
    class func alamofireFunctionWithLocationHeader(urlString : String, method : Alamofire.HTTPMethod, parameters : [String : AnyObject], token: String, completion : @escaping ( _ response : AnyObject?,  _ message: String?, _ success : Bool)-> Void){
        
        if method == Alamofire.HTTPMethod.post {
            //            Alamofire.request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: ["usrtoken" : token,"lat": latToken!,"lng":longToken!]).responseJSON { (response:DataResponse<Any>) in
            //                print(urlString)
            //
            //                if response.result.isSuccess{
            //                    completion(response.result.value as AnyObject?, "", true)
            //                }else{
            //                    completion(nil, "", false)
            //                }
            //            }
            //
        }else {
            Alamofire.request(urlString).responseJSON { (response) in
                if response.result.isSuccess{
                    completion(response.result.value as AnyObject?, "", true)
                }else{
                    completion(nil, "", false)
                }
            }
        }
    }
    
    //Image
    class func postWebServiceWithImage(urlString: String, params: [String : AnyObject], imageToUploadURL: UIImage,fileType:String,mimeName: String, token: String, completion : @escaping ( _ response : AnyObject?,  _ message: String?, _ success : Bool)-> Void) {
        let imageData = UIImageJPEGRepresentation(imageToUploadURL,1.0)
        let URL = try! URLRequest(url: urlString, method: .post, headers: ["Authorization" : token])
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imageData!, withName: "image", fileName: fileType, mimeType: mimeName)
           
            for (key, value) in params {
                // multipartFormData.append(value.data(using: String.Encoding.utf8.rawValue)!, withName: key)
              //  multipartFormData.app
                //appendBodyPart(data: value.dataUsingEncoding(String.Encoding.utf8)!, name: key)
            multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            }
        }, with: URL, encodingCompletion: { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print(response.request!)  // original URL request
                    print(response.response!) // URL response
                    print(response.data!)     // server data
                    print(response.result)   // result of response serialization
                    
                    if let JSON = response.result.value {
                        print("JSON: \(JSON)")
                        completion(response.result.value as AnyObject?, "", true)
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
                completion(nil, "", false)
            }
        })
    }
    
    //Mark:-Cancel
    class func cancelAllRequests()
    {
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
            dataTasks.forEach { $0.cancel() }
            uploadTasks.forEach { $0.cancel() }
            downloadTasks.forEach { $0.cancel() }
        }
    }
}
