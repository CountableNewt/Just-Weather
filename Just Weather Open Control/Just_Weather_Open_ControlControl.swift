//
//  Just_Weather_Open_ControlControl.swift
//  Just Weather Open Control
//
//  Created by Sam Clemente on 9/15/24.
//

import AppIntents
import SwiftUI
import WidgetKit

@available(iOS 18.0, *)
struct Just_Weather_Open_ControlControl: ControlWidget {
    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(
            kind: "com.sam-clemente.just-weather-app.Just-Weather-Open-Control"
        ) {
            ControlWidgetButton(
                action: LaunchAppIntent()
            ) {
                Label("Open App", systemImage: "thermometer.medium")
            }
        }
        .displayName("Open Just. Weather.")
        .description("Open the Just. Weather. App")
    }
}

// struct LaunchAppIntent: OpenIntent {
//     static var title: LocalizedStringResource = "Launch App"
//     @Parameter(title: "Target")
//     var target: LaunchAppEnum
// }
//
// enum LaunchAppEnum: String, AppEnum {
//     case justWeather = "com.sam-clemente.just-weather-app"
//
//     static var typeDisplayRepresentation = TypeDisplayRepresentation("My Apps")
//     static var caseDisplayRepresentations = [
//         LaunchAppEnum.justWeather : DisplayRepresentation("Just. Weather.")
//     ]
// }

@available(iOS 18.0, *)
struct LaunchAppIntent: AppIntent {
    static let title: LocalizedStringResource = "Launch App"
    
    static var openAppWhenRun: Bool = true
    
    func perform() async throws -> some IntentResult {
        return .result()
    }
}
