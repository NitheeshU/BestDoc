//
//  location.swift
//  BestDocUser
//
//  Created by nitheesh.u on 21/04/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//

import Foundation
import CoreLocation
class LocationDelegate : NSObject, CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // here you will receive your location updates on `locations` parameter
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // if something goes wrong comes to here
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // here you can monitor the authorization status changes
    }
    
}
open class Reachability {
    class func isLocationServiceEnabled() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                return false
            case .authorizedAlways, .authorizedWhenInUse:
                return true
            default:
                print("Something wrong with Location services")
                return false
            }
        } else {
            print("Location services are not enabled")
            return false
        }
    }
}
