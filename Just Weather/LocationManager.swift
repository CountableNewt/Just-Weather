//
//  LocationManager.swift
//  Just Weather
//
//  Created by Sam Clemente on 8/21/24.
//

import Foundation
import SwiftUI
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var lastLocation: CLLocation?
    @Published var locationStatus: CLAuthorizationStatus?
    
    private var locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        requestLocationPermission()
    }
    
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        lastLocation = location
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationStatus = status
        
        switch status {
        case .notDetermined:
            print("Location Permission Not Determined")
        case .restricted:
            print("Location Permission Restricted")
        case .denied:
            print("Location Permission Denied")
        case .authorizedAlways, .authorizedWhenInUse:
            print("Location Permission Authorized")
            startUpdatingLocation()
        @unknown default:
            print("Unknown Status")
        }
    }
}
