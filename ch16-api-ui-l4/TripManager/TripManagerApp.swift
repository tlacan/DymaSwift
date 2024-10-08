//
//  TripManagerApp.swift
//  TripManager
//
//  Created by thomas lacan on 19/03/2024.
//

import SwiftUI

@main
struct TripManagerApp: App {
  @AppStorage(UserDefaultsKeys.onboardingCompleted.rawValue)
  var onboardingCompleted: Bool = false
  let engine = Engine(mock: false)

  var body: some Scene {
      WindowGroup {
        if onboardingCompleted {
          MainTabView(engine: engine)
        } else {
          OnboardingScreen()
        }
      }
  }
}
