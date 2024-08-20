//
//  CityModel.swift
//  TripManager
//
//  Created by thomas lacan on 29/05/2024.
//

import Foundation

struct CityModel: Identifiable, Hashable, Codable {
  let id: String
  let image: String
  let name: String
  let country: String?
  var postCode: String?
  var creationDate: Date?

  static var sampleValues: [CityModel] {
    [
      CityModel(id: "1", image: "https://picsum.photos/300/140", name: "Paris", country: "France"),
      CityModel(id: "2", image: "https://picsum.photos/300/140", name: "Lyon", country: "France"),
      CityModel(id: "3", image: "https://picsum.photos/300/140", name: "Nice", country: "France"),
      CityModel(id: "4", image: "https://picsum.photos/300/140", name: "Barcelona", country: "Spain"),
      CityModel(id: "5", image: "https://picsum.photos/300/140", name: "Madrid", country: "Spain"),
      CityModel(id: "6", image: "https://picsum.photos/300/140", name: "Sevilla", country: "Spain")
    ]
  }

  enum CodingKeys: String, CodingKey {
    case id = "_id"
    case image, name, country
  }
}
