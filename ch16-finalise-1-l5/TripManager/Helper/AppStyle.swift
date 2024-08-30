//
//  AppStyle.swift
//  TripManager
//
//  Created by thomas lacan on 13/04/2024.
//

import Foundation
import SwiftUI

struct AppStyles {

  enum Padding: CGFloat {
    case verySmall8 = 8
    case small16 = 16
    case medium24 = 24
    case big32 = 32
  }

  enum TextStyles {
    case title
    case sectionTitle
    case buttonCTA
    case description
    case navigationAction
    case navigationTitle

    var size: CGFloat {
      switch self {
      case .title: return 37
      case .sectionTitle: return 22
      case .buttonCTA: return 16
      case .description: return 20
      case .navigationAction: return 18
      case .navigationTitle: return 28
      }
    }

    var font: Font {
      switch self {
      case .title, .sectionTitle, .navigationTitle: return Font.custom(R.font.avenirNextBold, size: size)
      case .buttonCTA, .navigationAction: return Font.custom(R.font.avenirNextDemiBold, size: size)
      case .description: return Font.custom(R.font.avenirNextRegular, size: size)
      }
    }

    var uiFont: UIFont? {
      switch self {
      case .title, .sectionTitle, .navigationTitle: return UIFont(name: R.font.avenirNextBold.name, size: size)
      case .buttonCTA, .navigationAction: return UIFont(name: R.font.avenirNextDemiBold.name, size: size)
      case .description: return UIFont(name: R.font.avenirNextRegular.name, size: size)
      }
    }

    var defaultColor: Color {
      switch self {
      case .title, .sectionTitle, .navigationTitle: return Color(R.color.primaryText)
      case .buttonCTA: return Color.white
      case .description: return Color(R.color.secondaryText)
      case .navigationAction: return Color(R.color.primaryBlue)
      }
    }
  }

  static func showLoader() {
    EntryKitViewDisplayer.showLoader()
  }

  static func hideLoader() {
    EntryKitViewDisplayer.hideLoader()
  }

  static func showError(_ error: LocalizedError) {
    EntryKitViewDisplayer.showMessage(error.localizedDescription)
  }
}
