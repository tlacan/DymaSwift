//
//  TripModel.swift
//  TripManager
//
//  Created by thomas lacan on 30/06/2024.
//

import Foundation

public struct TripModel: Equatable, Hashable, Codable {
  public var id: String?
  public var city: String
  public var activities: [ActivityModel]
  public var date: Date?

  enum CodingKeys: String, CodingKey {
    case id = "_id"
    case city, activities, date
  }

  public init(id: String? = nil, city: String, activities: [ActivityModel], date: Date? = nil) {
    self.id = id
    self.city = city
    self.activities = activities
    self.date = date
  }

  public static func sampleValues() -> [TripModel] {
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

  public func hash(into hasher: inout Hasher) {
    hasher.combine(id ?? "" + city)
  }
}
