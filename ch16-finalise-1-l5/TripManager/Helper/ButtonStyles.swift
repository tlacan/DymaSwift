//
//  ButtonStyles.swift
//  TripManager
//
//  Created by thomas lacan on 02/05/2024.
//

import Foundation
import SwiftUI

struct HighlightButton: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .overlay(Color.black.opacity(configuration.isPressed ? 0.2 : 0))
  }
}
struct PrimaryButton: ButtonStyle {

  func makeBody(configuration: Configuration) -> some View {
      configuration.label
        .font(AppStyles.TextStyles.buttonCTA.font)
        .padding()
        .foregroundStyle(.white)
        .background(Color.accentColor)
        .clipShape(Capsule())
        .opacity(configuration.isPressed ? 0.8 : 1.0)
  }
}

struct SecondaryButton: ButtonStyle {

  func makeBody(configuration: Configuration) -> some View {
      configuration.label
        .font(AppStyles.TextStyles.buttonCTA.font)
        .padding()
        .foregroundStyle(Color.accentColor)
        .background(configuration.isPressed ? Color(uiColor: .lightGray).opacity(0.2) : .white)
        .opacity(configuration.isPressed ? 0.8 : 1.0)
        .overlay(
          Capsule()
            .stroke(Color.accentColor, lineWidth: 1.0)
        )
        .clipShape(Capsule())
        .opacity(configuration.isPressed ? 0.8 : 1.0)
  }
}
