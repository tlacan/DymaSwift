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
    VStack {
      TabView(selection: $index) {
        ForEach(stepsData) { stepData in
          stepView(data: stepData)
            .ignoresSafeArea(edges: .top)
            .tag(stepData.id)
        }
      }
      .tabViewStyle(.page)
      .indexViewStyle(.page(backgroundDisplayMode: .always))
      buttonsView()
    }
  }

  @ViewBuilder
  func buttonsView() -> some View {
    HStack {
      if index != stepsData.count - 1 {
        Button(action: {
          withAnimation {
            print("skip")
          }
        }, label: {
          Text(R.string.localizable.onboardingButtonSkip)
        }).buttonStyle(SecondaryButton())
        Button(action: {
          withAnimation {
            if index < stepsData.count - 1 {
              index += 1
            }
          }
        }, label: {
          Text(R.string.localizable.onboardingButtonNext)
        }).buttonStyle(PrimaryButton())
      } else {
        Button(action: {
          withAnimation {
            print("start")
          }
        }, label: {
          Text(R.string.localizable.onboardingButtonStart)
        }).buttonStyle(PrimaryButton())
      }
    }
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
