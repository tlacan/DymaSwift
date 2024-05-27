//
//  HomeScreen.swift
//  TripManager
//
//  Created by thomas lacan on 23/05/2024.
//

import SwiftUI

struct HomeScreen: View {
    var body: some View {
      ZStack {
        Color(R.color.mainBackground.name)
          .ignoresSafeArea()
        Text("Home")
      }
    }
}

#Preview {
    HomeScreen()
}
