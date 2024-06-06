//
//  HomeScreen.swift
//  TripManager
//
//  Created by thomas lacan on 23/05/2024.
//

import SwiftUI

struct HomeScreen: View {
  let countries = Set(CityModel.sampleValues.compactMap({ $0.country }))

  @State private var values = CityModel.sampleValues

  var body: some View {
    NavigationStack {
      List {
        ForEach(values) { city in
          NavigationLink {
            Text(city.name)
          } label: {
            Text(city.name)
          }
          .swipeActions {
            Button {
              print("Editer")
            } label: {
              Label("Editer", systemImage: "pencil")
            }.tint(.blue)
          }
        }.onDelete(perform: { indexSet in
          values.remove(atOffsets: indexSet)
        })
      }
      .listStyle(.insetGrouped)
    }
  }
}

#Preview {
    HomeScreen()
}
