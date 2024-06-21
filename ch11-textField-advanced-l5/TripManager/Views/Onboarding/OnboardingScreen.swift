//
//  OnboardingScreen.swift
//  TripManager
//
//  Created by thomas lacan on 15/05/2024.
//

import SwiftUI

struct OnboardingScreen: View {
  struct ViewStyles {
    static let tabViewBottomSpacing: CGFloat = 106
    static let stepImageBottomSpacing: CGFloat = 80
    static let pageControlSelectedSize: CGFloat = 8
    static let pageControlNotSelectedSize: CGFloat = 6
    static let pageControlStokeWidth: CGFloat = 1
  }

  @AppStorage(UserDefaultsKeys.onboardingCompleted.rawValue)
  var onboardingCompleted: Bool = false

  @State var index: Int = 0
  let stepsData = OnboardingStepData.allValues()

  var body: some View {
    ZStack {
      Color(R.color.mainBackground.name).ignoresSafeArea()
      ZStack(alignment: .bottom) {
        TabView(selection: $index) {
          ForEach(stepsData) { stepData in
            stepView(data: stepData)
              .ignoresSafeArea(edges: .top)
              .tag(stepData.id)
              .padding(.bottom, AppStyles.Padding.medium24.rawValue)
          }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .ignoresSafeArea(edges: .top)
        .padding(.bottom, ViewStyles.tabViewBottomSpacing)
        VStack(spacing: AppStyles.Padding.medium24.rawValue) {
          pageControl()
          buttonsView()
        }
        .padding(.bottom, AppStyles.Padding.medium24.rawValue)
      }
    }
  }

  @ViewBuilder
  func pageControl() -> some View {
    HStack(spacing: AppStyles.Padding.verySmall8.rawValue) {
      ForEach(0..<stepsData.count, id: \.self) { pageIndex in
        Circle()
          .stroke(Color.accentColor, lineWidth: ViewStyles.pageControlStokeWidth)
          .fill(index == pageIndex ? Color.accentColor : Color.white)
          .frame(width: index == pageIndex ? ViewStyles.pageControlSelectedSize : ViewStyles.pageControlNotSelectedSize,
                 height: index == pageIndex ? ViewStyles.pageControlSelectedSize : ViewStyles.pageControlNotSelectedSize)
      }
    }
  }

  @ViewBuilder
  func buttonsView() -> some View {
    HStack {
      if index != stepsData.count - 1 {
        Button(action: {
          withAnimation {
            onboardingCompleted = true
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
            onboardingCompleted = true
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
