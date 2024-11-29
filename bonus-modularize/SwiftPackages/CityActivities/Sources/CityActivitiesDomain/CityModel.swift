//
//  CityModel.swift
//  CityActivities
//
//  Created by thomas lacan on 24/11/2024.
//

import Foundation

public struct CityModel: Identifiable, Hashable, Codable, @unchecked Sendable {
  public let id: String
  public let image: String
  public let name: String
  public let activities: [ActivityModel]
  public let country: String?
  public var postCode: String?
  public var creationDate: Date?

  public static var sampleValues: [CityModel] {
    [
      CityModel(id: "1", image: "https://picsum.photos/300/140", name: "Paris",
                activities: ActivityModel.sampleValues(),
                country: "France"),
      CityModel(id: "2", image: "https://picsum.photos/300/140", name: "Lyon", activities: ActivityModel.sampleValues(),
                country: "France"),
      CityModel(id: "3", image: "https://picsum.photos/300/140", name: "Nice",
                activities: ActivityModel.sampleValues(),
                country: "France"),
      CityModel(id: "4", image: "https://picsum.photos/300/140", name: "Barcelona",
                activities: ActivityModel.sampleValues(),
                country: "Spain"),
      CityModel(id: "5", image: "https://picsum.photos/300/140", name: "Madrid",
                activities: ActivityModel.sampleValues(),
                country: "Spain"),
      CityModel(id: "6", image: "https://picsum.photos/300/140", name: "Sevilla",
                activities: ActivityModel.sampleValues(),
                country: "Spain")
    ]
  }

  enum CodingKeys: String, CodingKey {
    case id = "_id"
    case image, name, country, activities
  }
}
