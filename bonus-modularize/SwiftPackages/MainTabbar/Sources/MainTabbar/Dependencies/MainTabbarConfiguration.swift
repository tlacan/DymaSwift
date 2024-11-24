//
//  MainTabbarConfiguration.swift
//  MainTabbar
//
//  Created by thomas lacan on 23/11/2024.
//
import SwiftUI

public struct MainTabbarConfiguration {
  let homeTabView: AnyView
  let tripsTabView: AnyView

  public init(homeTabView: AnyView, tripsTabView: AnyView) {
    self.homeTabView = homeTabView
    self.tripsTabView = tripsTabView
  }
}
