//
//  ContentView.swift
//  Just Weather
//
//  Created by Sam Clemente on 8/21/24.
//

import Foundation
import SwiftUI
import WeatherKit

struct Just_WeatherView: View {
    @EnvironmentObject var locationManager: LocationManager
    @StateObject private var weatherData = WeatherData()
    @State private var isLoading = true
    
    let preferredUnit: UnitTemperature = Locale.current.measurementSystem == .metric ? .celsius : .fahrenheit
    
    var body: some View {
        VStack {
            if isLoading {
                Text("Fetching Weather Data...")
                    .font(.largeTitle)
            } else if weatherData.wind != nil {
                VStack {
                    Spacer()
                    Text("\(weatherData.apparentTemperature.value, specifier: "%.0f")º")
                        .font(.largeTitle)
                    Text("Feels Like")
                    Spacer()
                    Text("Condition: \(weatherData.condition)")
                    HStack {
                        Spacer()
                        VStack {
                            Text("Current Temperature: \(weatherData.temperature.value, specifier: "%.0f")º")
                            if let wind = weatherData.wind {
                                Text("Wind: \(wind.speed.value, specifier: "%.0f")km/h \(wind.direction.value)º")
                            } else {
                                Text("Fetching Wind Data...")
                            }
                        }
                        Spacer()
                        VStack {
                            Text("Dew Point: \(weatherData.dewPoint.value, specifier: "%.0f")º")
                            Text("Relative Humidity: \(weatherData.humidity * 100, specifier: "%.0f")%")
                        }
                        Spacer()
                    }
                    Spacer()
                }
            } else {
                Text("No Weather Data Available")
                    .font(.largeTitle)
            }
        }
        .onAppear {
            Task {
                if let lastLocation = locationManager.lastLocation {
                    print("Found last location: \(lastLocation)")
                    await weatherData.fetchWeather(for: lastLocation)
                    isLoading = false
                } else {
                    print("No Location Found")
                    isLoading = false
                }
            }
        }
    }
}
