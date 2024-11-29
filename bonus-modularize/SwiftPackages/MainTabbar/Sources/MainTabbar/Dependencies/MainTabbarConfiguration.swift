//
//  MainTabbarConfiguration.swift
//  MainTabbar
//
//  Created by thomas lacan on 23/11/2024.
//
import SwiftUI
import GlobalHelper

public struct MainTabbarConfiguration: DefaultValue {
  let homeTabView: AnyView
  let tripsTabView: AnyView

  public init(homeTabView: AnyView, tripsTabView: AnyView) {
    self.homeTabView = homeTabView
    self.tripsTabView = tripsTabView
  }

  public static var defaultValue: MainTabbarConfiguration {
    MainTabbarConfiguration(homeTabView: AnyView(EmptyView()), tripsTabView: AnyView(EmptyView()))
  }
}
