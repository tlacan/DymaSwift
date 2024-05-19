//
//  OnboardingScreen.swift
//  TripManager
//
//  Created by thomas lacan on 15/05/2024.
//

import SwiftUI

struct OnboardingScreen: View {
  struct ViewStyles {
    static let stepImageBottomSpacing: CGFloat = 80
  }

  @State var index: Int = 0
  let stepsData = OnboardingStepData.allValues()

  var body: some View {

    stepView(data: OnboardingStepData.allValues()[0])
  }

  @ViewBuilder
  func stepView(data: OnboardingStepData) -> some View {
      ZStack(alignment: .bottom) {
        GeometryReader { geometry in
          Image(data.image)
            .resizable()
            .scaledToFill()
            .frame(width: geometry.size.width)
            .frame(maxHeight: geometry.size.height - ViewStyles.stepImageBottomSpacing)
        }
        VStack {
          data.title.textView(style: .title, multiligneAlignment: .center)
          data.description.textView(style: .description, multiligneAlignment: .center)
        }.padding(.horizontal, AppStyles.Padding.medium24.rawValue)
      }
  }
}

#Preview {
    OnboardingScreen()
}
