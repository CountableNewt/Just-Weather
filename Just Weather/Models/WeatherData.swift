//
//  WeatherData.swift
//  Just Weather
//
//  Created by Sam Clemente on 8/21/24.
//

import WeatherKit
import CoreLocation

@MainActor
class WeatherData: ObservableObject {
    @Published var temperature: Measurement<UnitTemperature> = Measurement(value: 0, unit: .fahrenheit)
    @Published var apparentTemperature: Measurement<UnitTemperature> = Measurement(value: 0, unit: .fahrenheit)
    
    @Published var dewPoint: Measurement<UnitTemperature> = Measurement(value: 0, unit: .fahrenheit)
    @Published var humidity: Double = 0.0
    
    @Published var wind: Wind?
    
    @Published var condition: WeatherCondition = .clear
    
    @Published var conditionSymbol: String = "sun.max"
    
    @Published var sunrise: Date?
    @Published var sunset: Date?
    
    @Published var moonPhase: MoonPhase?
    
    func fetchWeather(for location: CLLocation) async {
        do {
            let weather = try await WeatherService.shared.weather(for: location)
            
            self.temperature = weather.currentWeather.temperature
            self.apparentTemperature = weather.currentWeather.apparentTemperature
            
            self.dewPoint = weather.currentWeather.dewPoint
            self.humidity = weather.currentWeather.humidity
            
            self.wind = weather.currentWeather.wind
            
            self.condition = weather.currentWeather.condition
            
            self.conditionSymbol = weather.currentWeather.symbolName
            
            self.sunrise = weather.dailyForecast[0].sun.sunrise
            self.sunset = weather.dailyForecast[0].sun.sunset
            
            self.moonPhase = weather.dailyForecast[0].moon.phase
            
        } catch {
            print("Error fetching weather: \(error.localizedDescription)")
        }
    }
}
