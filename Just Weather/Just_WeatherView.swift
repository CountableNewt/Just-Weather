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
                        if Locale.current.measurementSystem == .us {
                            Text("\(toFahrenheit(weatherData.apparentTemperature.value), specifier: "%.0f")º")
                                .font(.custom("SF-Pro-Display-Regular", fixedSize: 150))
                        } else {
                            let feelsLike = (weatherData.apparentTemperature.value * 2).rounded() / 2
                            
                            // If the temperature's value is a single-digit number, show the decimal (if it's not N.0)
                            if feelsLike < 10 && feelsLike > -10 && feelsLike != floor(feelsLike) {
                                Text("\(feelsLike, specifier: "%.1f")º")
                                    .font(.custom("SF-Pro-Display-Regular", fixedSize: 150))
                            } else {
                                Text("\(feelsLike, specifier: "%.0f")º")
                                    .font(.custom("SF-Pro-Display-Regular", fixedSize: 150))
                            }
                            
                        }
//                        Text("\(formatter.string(from: weatherData.apparentTemperature).prefix(2))º")
//                            .font(.custom("SF-Pro-Display-Regular", fixedSize: 175))
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
                        var highTemp: Double {
                            return Locale.current.measurementSystem == .us ? toFahrenheit(weatherData.highTemp.value) : weatherData.highTemp.value
                        }
                        var lowTemp: Double {
                            return Locale.current.measurementSystem == .us ? toFahrenheit(weatherData.lowTemp.value) : weatherData.lowTemp.value
                        }
                        Text("H: \(highTemp, specifier: "%.0f")º")
                        Text("L: \(lowTemp, specifier: "%.0f")º")
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
                                var actualTemp: Double {
                                    return Locale.current.measurementSystem == .us ? toFahrenheit(weatherData.temperature.value) : weatherData.temperature.value
                                }
                                Text("\(actualTemp, specifier: "%.0f")º")
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
                                var dewPoint: Double {
                                    return Locale.current.measurementSystem == .us ? toFahrenheit(weatherData.dewPoint.value) : weatherData.dewPoint.value
                                }
                                Text("\(dewPoint, specifier: "%.0f")º")
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
