//
//  AppDependencyInjection.swift
//  tripManagerTwist
//
//  Created by thomas lacan on 27/11/2024.
//

import Swinject
import NetworkClient
import CityActivitiesUI
import SwiftUICore
import MainTabbar
import GlobalHelper

struct AppDependencyInjection {

  static func createContainer() -> Container {
    let container = Container()

    // MARK: - NetworkClient
    let networkClient = NetworkClient(server: .dev)
    container.register(NetworkClient.self) { _ in networkClient }

    // MARK: - MainTabbarConfiguration
    let tabBarConfiguration = MainTabbarConfiguration(
      homeTabView: AnyView(HomeScreen(networkClient: networkClient)),
      tripsTabView: AnyView(Text("B")))
    let tabbarAssembly = MainTabBarAssembly(configuration: tabBarConfiguration)
    tabbarAssembly.assemble(container: container)

    return container
  }
}

extension Container {
    /// Retrieves the instance with the specified service type, or returns a default value if
    /// no registration is found and the type conforms to `DefaultValue`.
    ///
    /// - Parameter serviceType: The service type to resolve.
    ///
    /// - Returns: The resolved service instance, or the `defaultValue` for the service type if no registration is found.
    public func resolve<Service>(_ serviceType: Service.Type) -> Service where Service: DefaultValue {
        resolve(serviceType, name: nil) ?? Service.defaultValue
    }
}
