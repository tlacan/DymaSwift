import SwiftUI
import DesignSystem
import GlobalHelper

public struct MainTabView: View {
  enum Tabs: String, CaseIterable {
    case home
    case myTrips

    var name: String {
      switch self {
      case .home: return R.string.localizable.tabHome()
      case .myTrips: return R.string.localizable.tabMyTrips()
      }
    }

    var icon: String {
      switch self {
      case .home: return "globe.europe.africa.fill"
      case .myTrips: return "suitcase.rolling.fill"
      }
    }
  }
  @State private var tabSelection = Tabs.home
  @State private var animateTabHome = false
  @State private var animateTabMyTrips = false

  private let homeTabView: AnyView
  private let tripsTabView: AnyView

  enum ViewStyles {
    static let gradientColors: [Color] = [Color(DesignSystem.R.color.mainBackground.name),
                                          Color(red: 0.85, green: 0.85, blue: 0.85)]
    static let borderHeight: CGFloat = 6
    static let borderOpacity = 0.8

    static let tabbarButtonHeight: CGFloat = 48
    static let tabbarButtonSymbolSize: CGFloat = 22
    static let tabbarButtonTextSize: CGFloat = 10
  }

  public init(configuration: MainTabbarConfiguration) {
    self.homeTabView = configuration.homeTabView
    self.tripsTabView = configuration.tripsTabView
  }

  public var body: some View {
    VStack(spacing: 0) {
      tabContent()
      tabbar()
    }.onReceive(NotificationsConstants.didCreateTrip.publisher) { _ in
      withAnimation(.default) {
        tabSelection = .myTrips
      }
    }
  }

  @ViewBuilder
  func tabContent() -> some View {
    switch tabSelection {
    case .home:
      homeTabView
    case .myTrips:
      tripsTabView
    }
  }

  @ViewBuilder
  func tabbar() -> some View {
    VStack(spacing: 0) {
        LinearGradient(colors: ViewStyles.gradientColors, startPoint: .top, endPoint: .bottom)
          .frame(height: ViewStyles.borderHeight)
          .opacity(ViewStyles.borderOpacity)
        tabbarButtons()
      }
  }

  @ViewBuilder
  func tabbarButtons() -> some View {
    HStack {
      tabbarButton(.home, action: {
        withAnimation(.default) {
          tabSelection = .home
          animateTabHome.toggle()
        }
      })
        .symbolEffect(.bounce.byLayer.down, value: animateTabHome)
        .sensoryFeedback(.selection, trigger: animateTabHome)
        .frame(maxWidth: .infinity)

      tabbarButton(.myTrips, action: {
        withAnimation(.default) {
          tabSelection = .myTrips
          animateTabMyTrips.toggle()
        }
      })
        .symbolEffect(.bounce.byLayer.down, value: animateTabMyTrips)
        .sensoryFeedback(.selection, trigger: animateTabMyTrips)
        .frame(maxWidth: .infinity)
    }.background(Color(DesignSystem.R.color.mainBackground.name))
  }

  @ViewBuilder
  func tabbarButton(_ tab: Tabs, action: @escaping () -> Void) -> some View {
      Button {
          action()
      } label: {
          VStack(spacing: 0) {
            Image(systemName: tab.icon)
              .font(.system(size: ViewStyles.tabbarButtonSymbolSize))
              .foregroundColor(tabSelection == tab ? Color.accentColor : Color(uiColor: UIColor.systemGray))

            Text(tab.name)
              .font(.system(size: ViewStyles.tabbarButtonTextSize, weight: .medium))
              .foregroundColor(tabSelection == tab ? Color.accentColor : Color(uiColor: UIColor.systemGray))
          }.frame(height: ViewStyles.tabbarButtonHeight)
      }
      .buttonStyle(PlainButtonStyle())
  }
}

#Preview {
  let configuration = MainTabbarConfiguration(
      homeTabView: AnyView(Text("Welcome to Home")),
      tripsTabView: AnyView(Text("Explore your Trips"))
  )
  return MainTabView(configuration: configuration)
}
