//
//  Just_WeatherApp.swift
//  Just Weather
//
//  Created by Sam Clemente on 8/21/24.
//

import SwiftUI
import WeatherKit
import CoreLocation

@main
struct Just_WeatherApp: App {
    @StateObject private var locationManager = LocationManager()
    
    var body: some Scene {
        WindowGroup {
            Just_WeatherView()
                .environmentObject(locationManager)
                .onAppear {
                    locationManager.startUpdatingLocation()
                }
                .onDisappear {
                    locationManager.stopUpdatingLocation()
                }
        }
    }
}
