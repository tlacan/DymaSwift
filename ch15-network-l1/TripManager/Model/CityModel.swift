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
    case id
    case image
    case name
    case country
    case postCode = "zipCode"
    case creationDate
  }

  internal init(id: String, image: String, name: String, country: String? = nil, postCode: String? = nil, creationDate: Date? = nil) {
    self.id = id
    self.image = image
    self.name = name
    self.country = country
    self.postCode = postCode
    self.creationDate = creationDate
  }

  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    self.id = try container.decode(String.self, forKey: .id)
    self.image = try container.decode(String.self, forKey: .image)
    self.name = try container.decode(String.self, forKey: .name)
    self.country = try container.decodeIfPresent(String.self, forKey: .country)

    let stringValueZipCode = try? container.decodeIfPresent(String.self, forKey: .postCode)
    let intValueZipCode = try? container.decodeIfPresent(Int.self, forKey: .postCode)
    self.postCode = intValueZipCode != nil ? String(intValueZipCode ?? 0) : stringValueZipCode

    self.creationDate = try container.decodeIfPresent(Date.self, forKey: .creationDate)
  }

  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.id, forKey: .id)
    try container.encode(self.name, forKey: .name)
    try container.encode(self.image, forKey: .image)
    try container.encodeIfPresent(self.country, forKey: .country)
    if let postCode {
      try container.encodeIfPresent(Int(postCode), forKey: .postCode)
    }
    try container.encodeIfPresent(self.creationDate, forKey: .creationDate)
  }

  static func exampleDecodingJSON() -> [CityModel] {
    let jsonString = """
      [{
        "id": "1",
        "image": "https://picsum.photos/300/140",
        "name": "Paris",
        "country": "France",
        "zip_code": "75001",
        "creation_date": "2024-07-26T12:00:00Z"
      },
      {
        "id": "2",
        "image": "https://picsum.photos/300/140",
        "name": "Lyon",
        "country": "France",
        "zip_code": 69000,
      }
      ]
      """
    if let jsonData = jsonString.data(using: .utf8) {
      let jsonDecoder = JSONDecoder()
      jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
      jsonDecoder.dateDecodingStrategy = .iso8601
      do {
        let decodedCities = try jsonDecoder.decode([CityModel].self, from: jsonData)
        print("Result \(decodedCities)")
        return decodedCities
      } catch let error {
        print("Decoding error \(error.localizedDescription)")
      }
    }
    return []
  }

  static func encodeTestJSON() {
    let cities = exampleDecodingJSON()
    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = .convertToSnakeCase
    encoder.dateEncodingStrategy = .iso8601
    if let jsonData = try? encoder.encode(cities) {
      if let jsonString = String(data: jsonData, encoding: .utf8) {
        print("JSON: \(jsonString)")
      }
    }
  }
}
