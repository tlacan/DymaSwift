//
//  String+Extensions.swift
//  TripManager
//
//  Created by thomas lacan on 13/04/2024.
//

import Foundation
import SwiftUI
import RswiftResources

public extension String {
  func textView(style: AppStyles.TextStyles,
                overrideColor: Color? = nil,
                multilineAlignment: TextAlignment = .leading,
                lineLimit: Int? = nil) -> some View {
    Text(self)
      .foregroundStyle(overrideColor ?? style.defaultColor)
      .font(style.font)
      .lineLimit(lineLimit)
      .multilineTextAlignment(multilineAlignment)
  }
}
