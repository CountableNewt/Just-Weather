//
//  WatchView.swift
//  Just Weather Watch Watch App
//
//  Created by Sam Clemente on 11/6/24.
//

import Foundation
import SwiftUI
import WeatherKit

struct WatchView: View {
    @EnvironmentObject var locationManager: LocationManager
    @StateObject private var weatherData = WeatherData()
    @State private var isLoading = true
    
    let formatter = MeasurementFormatter()
    
    var body: some View {
        VStack {
            if isLoading {
                Text("Fetching Weather Data...")
                    .font(.headline)
            } else if weatherData.wind != nil {
                
            } else {
                Text("No Weather Data Available")
                    .font(.headline)
            }
        }
        .onAppear {
            fetchWeatherIfLocationAvailable()
        }
        // .onChange(of: locationManager.locationStatus, perform: fetchWeatherIfLocationAvailable)
    }
    
    private func fetchWeatherIfLocationAvailable() {
        Task {
            if let lastLocation = locationManager.lastKnownLocation {
                await weatherData.fetchWeather(for: lastLocation)
                isLoading = false
            } else {
                print("No Location Found")
                isLoading = false
            }
        }
    }
}

#Preview {
    WatchView()
}
