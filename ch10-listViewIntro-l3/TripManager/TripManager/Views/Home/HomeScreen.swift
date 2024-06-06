//
//  HomeScreen.swift
//  TripManager
//
//  Created by thomas lacan on 23/05/2024.
//

import SwiftUI

struct HomeScreen: View {
  let countries = Set(CityModel.sampleValues.compactMap({ $0.country }))

  var body: some View {
    List {
      ForEach(Array(countries), id: \.self) { country in
        Section {
          ForEach(CityModel.sampleValues.filter({ $0.country == country })) { city in
            Text(city.name)
          }
        } header: {
          Text(country)
        } footer: {
          Text("Fin de liste")
        }
      }
    }
    .scrollIndicators(.hidden)
    .listStyle(.insetGrouped)
  }
}

#Preview {
    HomeScreen()
}
