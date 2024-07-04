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

  var body: some Scene {
      WindowGroup {
        if onboardingCompleted {
          MainTabView()
            .task {
              var reference1: ClassExample?
              var reference2: ClassExample?
              weak var reference3: ClassExample?

              reference1 = ClassExample(name: "ARC tutorial") // Compteur 1
              reference2 = reference1 // Compteur 2
              reference3 = reference1 // Compteur 2

              reference1 = nil // Compteur 2
              print("Ref1 a été mis à nil")
              print("Ref3 est nil \(reference3 == nil)")

              reference2 = nil // Compteur 0
              print("Ref2 a été mis à nil")
              print("Ref3 est nil \(reference3 == nil)")
            }
        } else {
          OnboardingScreen()
        }
      }
  }
}

class ClassExample {
  var name: String

  init(name: String) {
    self.name = name
    print("\(name) est initialisée")
  }

  deinit {
    print("\(name) est libérée")
  }
}
