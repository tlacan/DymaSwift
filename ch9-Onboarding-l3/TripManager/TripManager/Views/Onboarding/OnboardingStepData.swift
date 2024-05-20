//
//  OnboardingStepData.swift
//  TripManager
//
//  Created by thomas lacan on 17/05/2024.
//

import Foundation
import RswiftResources

struct OnboardingStepData: Identifiable {
  let id: Int
  let image: String
  let title: StringResource
  let description: StringResource

  static func allValues() -> [OnboardingStepData] {
    [
      OnboardingStepData(id: 0, image: R.image.onboarding1.name, title: R.string.localizable.onboardingStep1Title, description: R.string.localizable.onboardingStep1Description),
      OnboardingStepData(id: 1, image: R.image.onboarding2.name, title: R.string.localizable.onboardingStep2Title, description: R.string.localizable.onboardingStep2Description),
      OnboardingStepData(id: 2, image: R.image.onboarding3.name, title: R.string.localizable.onboardingStep3Title, description: R.string.localizable.onboardingStep3Description)
    ]
  }
}
