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
    
    let formatter = MeasurementFormatter()
    
    var body: some View {
        VStack {
            if isLoading {
                Text("Fetching Weather Data...")
                    .font(.largeTitle)
            } else if weatherData.wind != nil {
                VStack {
                    Spacer()
                    Spacer()
                    Spacer()
                    VStack {
                        temperatureDecimalFormatter(weatherData.apparentTemperature.value)
                            .font(.custom("SF-Pro-Display-Regular", fixedSize: 150))
                        Text("Feels Like")
                    }
                    Spacer()
                    Spacer()
                    VStack {
                        Image(systemName: weatherData.conditionSymbol)
                            .font(.largeTitle)
                        Text("\(weatherData.condition)")
                    }
                    Spacer()
                    HStack {
                        Text("H:")
                        temperatureDecimalFormatter(weatherData.highTemp.value)
                        Text("L:")
                        temperatureDecimalFormatter(weatherData.lowTemp.value)
                    }
                    HStack {
                        VStack {
                            Image(systemName: "thermometer.medium")
                            Image(systemName: "humidity")
                            Image(systemName: "sunrise")
                        }
                        VStack {
                            HStack {
                                // Text("Actual:")
                                Spacer()
                                temperatureDecimalFormatter(weatherData.temperature.value)
                            }
                            HStack {
                                // Text("Humidity:")
                                Spacer()
                                Text("\(weatherData.humidity * 100, specifier: "%.0f")%")
                            }
                            HStack {
                                // Text("Sunrise:")
                                Spacer()
                                if let sunrise = weatherData.sunrise  {
                                    Text("\(sunrise.formatted(date: .omitted, time: .shortened))")
                                } else {
                                    Text("None")
                                }
                            }
                        }
                        Spacer()
                        VStack {
                            Image(systemName: "wind")
                            Image(systemName: "drop.degreesign")
                            Image(systemName: "sunset")
                        }
                        VStack {
                            HStack {
                                // Text("Wind:")
                                Spacer()
                                if let wind = weatherData.wind {
                                    if Locale.current.measurementSystem == .us {
                                        Text("\(toMilesPerHour(wind.speed.value), specifier: "%.0f")mph \(cardinalDirection(from: wind.direction.value))")
                                    } else {
                                        Text("\(wind.speed.value, specifier: "%.0f")km/h \(cardinalDirection(from: wind.direction.value))")
                                    }
                                } else {
                                    Text("Fetching...")
                                }
                            }
                            HStack {
                                // Text("Dew Point:")
                                Spacer()
                                temperatureDecimalFormatter(weatherData.dewPoint.value)
                            }
                            HStack {
                                // Text("Sunset:")
                                Spacer()
                                if let sunset = weatherData.sunset {
                                    Text("\(sunset.formatted(date: .omitted, time: .shortened))")
                                } else {
                                    Text("None")
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    if let moonPhase = weatherData.moonPhase {
                        HStack {
                            Image(systemName: moonPhase.symbolName)
                            Text("\(moonPhase)")
                        }
                    }
                    Spacer()
                }
            } else {
                Text("No Weather Data Available")
                    .font(.largeTitle)
            }
        }
        .onAppear {
            fetchWeatherIfLocationAvailable()
        }
        .onChange(of: locationManager.locationStatus) { _ in
            fetchWeatherIfLocationAvailable()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            fetchWeatherIfLocationAvailable()
        }
    }
    
    private func fetchWeatherIfLocationAvailable() {
        Task {
            if let lastLocation = locationManager.lastLocation {
                await weatherData.fetchWeather(for: lastLocation)
                isLoading = false
            } else {
                print("No Location Found")
                isLoading = false
            }
        }
    }
    private func temperatureDecimalFormatter(_ temperature: Double) -> Text {
        if Locale.current.measurementSystem == .us {
            return Text("\(toFahrenheit(temperature), specifier: "%.0f")º")
        } else {
            let roundedTemperature = (temperature * 2).rounded() / 2
            
            if roundedTemperature < 10 && roundedTemperature > -10 && roundedTemperature != floor(roundedTemperature) {
                return Text("\(roundedTemperature, specifier: "%.1f")º")
            } else {
                return Text("\(roundedTemperature, specifier: "%.0f")º")
            }
        }
    }
    
    private func toFahrenheit(_ celsius: Double) -> Double {
        return (celsius * 9.0 / 5.0) + 32.0
    }
    
    private func toMilesPerHour(_ kilometersPerHour: Double) -> Double {
        return kilometersPerHour * 0.621371
    }
    
    private func cardinalDirection(from degrees: Double) -> String {
        let directions = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW", "N"]
        let index = Int((degrees + 11.25) / 22.5) % 16
        return directions[index]
    }
}
