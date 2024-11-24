//
//  Container.swift
//  MainTabbar
//
//  Created by thomas lacan on 23/11/2024.
//

import Swinject
import SwiftUI

public final class MainTabBarAssembly: Assembly {
  static let kHomeTabView = "HomeView"
  static let kTripsTabView = "TripsView"
  private let configuration: MainTabbarConfiguration

  public init(configuration: MainTabbarConfiguration) {
    self.configuration = configuration
  }

  public func assemble(container: Container) {
    container.register(AnyView.self, name: MainTabBarAssembly.kHomeTabView) { _ in
      self.configuration.homeTabView
    }.inObjectScope(.container)

    container.register(AnyView.self, name: MainTabBarAssembly.kTripsTabView) { _ in
      self.configuration.tripsTabView
    }.inObjectScope(.container)
  }
}
