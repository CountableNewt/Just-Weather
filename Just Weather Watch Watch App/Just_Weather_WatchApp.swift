//
//  Just_Weather_WatchApp.swift
//  Just Weather Watch Watch App
//
//  Created by Sam Clemente on 11/6/24.
//

import SwiftUI
import WeatherKit
import CoreLocation

@main
struct Just_Weather_Watch_Watch_AppApp: App {
    @StateObject private var locationManager = LocationManager()
    
    var body: some Scene {
        WindowGroup {
            WatchView()
                .environmentObject(locationManager)
                .onAppear {
                    locationManager.requestLocationPermission()
                }
        }
    }
}
