//
//  LocationManager.swift
//  Just Weather Watch Watch App
//
//  Created by Sam Clemente on 11/12/24.
//

import CoreLocation
import WatchKit

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            print("Location Permission Denied")
        case .notDetermined:
            print("Location Permission Not Determined")
        @unknown default:
            break
        }
    }
    
}
