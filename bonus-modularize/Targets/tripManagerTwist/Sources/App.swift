import SwiftUI
import OnboardingUI
import OnboardingData
import MainTabbar
import Swinject
import NetworkClient
import CityActivitiesUI

@main
struct MyApp: App {
  @AppStorage(OnboardingData.UserDefaultsKeys.onboardingCompleted.rawValue)
  var onboardingCompleted: Bool = false

  private let container = AppDependencyInjection.createContainer()

  var body: some Scene {
      WindowGroup {
        if onboardingCompleted {
          MainTabView(configuration: container.resolve(MainTabbarConfiguration.self))
        } else {
          OnboardingScreen()
        }
      }
  }
}
