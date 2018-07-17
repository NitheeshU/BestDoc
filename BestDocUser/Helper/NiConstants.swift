//
//  NiConstants.swift
//  BestDocUser
//
//  Created by nitheesh.u on 16/01/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//
import UIKit
import Foundation
 var tagdata:Bool?
let defaults = UserDefaults.standard
let locationDelegate: LocationDelegate = LocationDelegate()
var dataLocality: String?
var dataSpeciality:String?
var doctorName:String?
var hospitalName:String?
var tagview:Bool?
var tagspeciality:Bool?
var hospitalData = String()
var ratingValue = String()
var slotData = String()
var timeSlot = String()
var hospitalImage:String!
var doctorImageData:UIImage!
var authTokens = "YmVzVERvQ1BhdDpCRXN0ZGFwcDE3U2Vw"
//"YWRtaW5IYWxzYTpXM2QwMW5nMXRBZ2Exbg=="
var registrationStatus = Bool()
//"Basic YmVzVERvQ1BhdDpCRXN0ZGFwcDE3U2Vw"
//"YWRtaW5IYWxzYTpXM2QwMW5nMXRBZ2Exbg=="
var userProfile = defaults.string(forKey: "userProfile") ?? ""
var districtId = Int()
var regionId = Int()
var specialityId = Int()
var clinicDetails = NSDictionary()
var doctorDetails = NSDictionary()
var segment = Bool()
var rateValueD = String()
var sortIndex = Int()
var clinicDepartmentArray = [NSDictionary]()
var appUserType = "5"
var locUserId: Any?
var userRegID: Any?
var patRegID = "0"
var ownerId:Any?
var locationId: Any?
var loginStatus = Bool()
var logValue = Int()
var logindictionary = NSDictionary()
var deviceTokenStringData = String()
var hmsIntegration = Int()
var PaymentActive = Int()
var countryId :Int = 1
var otp = Int()
var patientRegId: Any?
var phoneNumb = String()
var emailDataOne = String()
var firstRegflag = Int()
var forginTag = Bool()
var feeDataValue = String()
var feeFlotValue = Float()
var patientName = String()
var choseFriends = Bool()
var addFriendTag = Bool()
var dateDetails = String()
var timeDetails = String()
var OpNumber = String()
var intialDate = String()
var intialTime = String()
var totalAmountData = Double()
var totalString = String()
var date24 = String()
var genderDataID:Int = 0
var startTime:String = "00:00:00"
var endTime:String =  "23:00:00"
var feeMin:Int = 0
var feeMax:Int = 0
var SelectedSort:Int = 2
var hashpaymentContract = Int()
var choseFriendTag = Bool()
var editFriends = Bool()
var docregid:Any?
var appoinmentDetailsDict = NSDictionary()
var checkSlotTag :Bool?
