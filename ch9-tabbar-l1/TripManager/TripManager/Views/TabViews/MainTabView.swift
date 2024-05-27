//
//  MainTabView.swift
//  TripManager
//
//  Created by thomas lacan on 23/05/2024.
//

import SwiftUI

struct MainTabView: View {
  enum Tabs {
    case home
    case myTrips
  }

  @State private var tabSelection = Tabs.home

  var body: some View {
    TabView(selection: Binding(get: {
      tabSelection
    }, set: { value in
      tabSelection = value
    })) {
      HomeScreen()
        .tabItem {
          Label(R.string.localizable.tabHome(), systemImage: "globe.europe.africa.fill")
        }

      MyTripsScreen()
        .tabItem {
          Label(R.string.localizable.tabMyTrips(), systemImage: "suitcase.rolling.fill")
        }
        .badge(5)
    }
  }
}

#Preview {
    MainTabView()
}
