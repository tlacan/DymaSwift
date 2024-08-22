//
//  TripModel.swift
//  TripManager
//
//  Created by thomas lacan on 30/06/2024.
//

import Foundation

struct TripModel: Equatable, Hashable, Codable {
  var id: String?
  var city: String
  var activities: [ActivityModel]
  var date: Date?

  enum CodingKeys: String, CodingKey {
    case id = "_id"
    case city, activities, date
  }

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

  func hash(into hasher: inout Hasher) {
    hasher.combine(id ?? "" + city)
  }
}
