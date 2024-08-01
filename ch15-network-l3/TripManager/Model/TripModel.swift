//
//  TripModel.swift
//  TripManager
//
//  Created by thomas lacan on 30/06/2024.
//

import Foundation

struct TripModel: Equatable, Hashable {
  var id: String?
  var city: String
  var activities: [ActivityModel]
  var date: Date?

  static func sampleValues() -> [TripModel] {
    [
      TripModel(id: UUID().uuidString, city: CityModel.sampleValues.first?.id ?? "",
                activities: ActivityModel.sampleValues(),
                date: Date().addingTimeInterval(24 * 60 * 60 * 5)),
      TripModel(id: UUID().uuidString, city: CityModel.sampleValues.last?.id ?? "",
                activities: ActivityModel.sampleValues(),
                date: Date()),
      TripModel(id: UUID().uuidString, city: CityModel.sampleValues.last?.id ?? "",
                activities: ActivityModel.sampleValues(),
                date: Date().addingTimeInterval(-24 * 60 * 60 * 12)),
      TripModel(id: UUID().uuidString, city: CityModel.sampleValues.first?.id ?? "",
                activities: ActivityModel.sampleValues(),
                date: Date().addingTimeInterval(-24 * 60 * 60 * 89)),
      TripModel(id: UUID().uuidString, city: CityModel.sampleValues.last?.id ?? "",
                activities: ActivityModel.sampleValues(),
                date: Date().addingTimeInterval(-24 * 60 * 60 * 380))
    ]
  }

  var cityModel: CityModel {
    // TO DO: update with real data
    CityModel.sampleValues[.random(in: (0..<CityModel.sampleValues.count - 1))]
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(id ?? "" + city)
  }
}
