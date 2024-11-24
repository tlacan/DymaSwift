//
//  AppStyle.swift
//  TripManager
//
//  Created by thomas lacan on 13/04/2024.
//

import Foundation
import SwiftUI
import NetworkClient

public enum AppStyles {

  public enum Padding: CGFloat {
    case verySmall8 = 8
    case small16 = 16
    case medium24 = 24
    case big32 = 32
  }

  public enum TextStyles {
    case title
    case sectionTitle
    case buttonCTA
    case description
    case navigationAction
    case navigationTitle

    public var size: CGFloat {
      switch self {
      case .title: return 37
      case .sectionTitle: return 22
      case .buttonCTA: return 16
      case .description: return 20
      case .navigationAction: return 18
      case .navigationTitle: return 28
      }
    }

    public var font: Font {
      switch self {
      case .title, .sectionTitle, .navigationTitle: return Font.custom(R.font.avenirNextBold, size: size,
                                                                       relativeTo: .title)
      case .buttonCTA, .navigationAction: return Font.custom(R.font.avenirNextDemiBold, size: size,
                                                             relativeTo: .headline)
      case .description: return Font.custom(R.font.avenirNextRegular, size: size, relativeTo: .body)
      }
    }

    public var uiFont: UIFont? {
      switch self {
      case .title, .sectionTitle, .navigationTitle: return UIFont(name: R.font.avenirNextBold.name, size: size)
      case .buttonCTA, .navigationAction: return UIFont(name: R.font.avenirNextDemiBold.name, size: size)
      case .description: return UIFont(name: R.font.avenirNextRegular.name, size: size)
      }
    }

    public var defaultColor: Color {
      switch self {
      case .title, .sectionTitle, .navigationTitle: return Color(R.color.primaryText)
      case .buttonCTA: return Color.white
      case .description: return Color(R.color.secondaryText)
      case .navigationAction: return Color(R.color.primaryBlue)
      }
    }
  }

  public static func showLoader() {
    Task { @MainActor in
      EntryKitViewDisplayer.showLoader()
    }
  }

  public static func hideLoader() {
    Task { @MainActor in
      EntryKitViewDisplayer.hideLoader()
    }
  }

  public static func showError(_ error: LocalizedError) {
    Task { @MainActor in
      EntryKitViewDisplayer.showMessage(error.localizedDescription)
    }
  }

  public static func makeAPICall<T: Decodable>(operations: () async -> APIResponse<T>,
                                               showLoader: Bool = true, showError: Bool = true) async -> T? {
    if showLoader {
      Task { @MainActor in
        AppStyles.showLoader()
      }
    }
    let apiResult = await operations()
    if showLoader {
      Task { @MainActor in
        AppStyles.hideLoader()
      }
    }
    switch apiResult {
    case .success(let result): return result
    case .failure(let error):
      if showError {
        AppStyles.showError(error)
      }
      return nil
    }
  }

  public static func makeAPICall<T: Decodable, V: Decodable>(operations1: @Sendable () async -> APIResponse<T>,
                                                             operations2: @Sendable () async -> APIResponse<V>,
                                                             showLoader: Bool = true, showError: Bool = true) async -> (T?, V?) {
    if showLoader {
      Task { @MainActor in
        AppStyles.showLoader()
      }
    }
    async let apiResult1Await = await operations1()
    async let apiResult2Await = await operations2()
    let (apiResult1, apiResult2) = await (apiResult1Await, apiResult2Await)

    if showLoader {
      Task { @MainActor in
        AppStyles.hideLoader()
      }
    }
    switch (apiResult1, apiResult2) {
    case (.success(let result1), .success(let result2)): return (result1, result2)
    case (.failure(let error), _):
      if showError {
        AppStyles.showError(error)
      }
      return (nil, nil)
    case (_, .failure(let error)):
      if showError {
        AppStyles.showError(error)
      }
      return (nil, nil)
    }
  }
}
