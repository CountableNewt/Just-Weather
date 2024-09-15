//
//  Just_Weather_Open_ControlBundle.swift
//  Just Weather Open Control
//
//  Created by Sam Clemente on 9/15/24.
//

import WidgetKit
import SwiftUI

@main
struct Just_Weather_Open_ControlBundle: WidgetBundle {
    var body: some Widget {
        if #available(iOS 18.0, *) { Just_Weather_Open_ControlControl() }
    }
}
