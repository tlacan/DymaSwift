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

  private let container: Container = {
    let container = Container()
    let networkClient = NetworkClient(server: .dev)
    container.register(NetworkClient.self) { _ in networkClient }

    let tabbarAssembly = MainTabBarAssembly(configuration: MainTabbarConfiguration(homeTabView: AnyView(HomeScreen(networkClient: networkClient)), tripsTabView: AnyView(Text("B"))))
    tabbarAssembly.assemble(container: container)
      return container
  }()

  var body: some Scene {
      WindowGroup {
        if onboardingCompleted {
          MainTabView(container: container)
        } else {
          OnboardingScreen()
        }
      }
  }
}
