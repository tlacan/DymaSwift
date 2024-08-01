//
//  APIEndPoints.swift
//  TripManager
//
//  Created by thomas lacan on 01/08/2024.
//

import Foundation

enum HTTPVerb: String {
  case get = "GET"
  case post = "POST"
  case put = "PUT"
  case patch = "PATCH"
  case delete = "DELETE"
}

enum APIEndPoint {
  case trips
  case cities
  case createTrip
  case updateTrip
  case addActivityToCity(cityId: String)
  case verifyActivityInCity(cityId: String, activityName: String)
  case uploadActivityImage
}

protocol EndpointMapper {
  static func path(for endPoint: APIEndPoint) -> String
  static func method(for endPoint: APIEndPoint) -> HTTPVerb
}

struct TripManagerEndpointMapper: EndpointMapper {
  static func path(for endPoint: APIEndPoint) -> String {
    switch endPoint {
    case .trips:
      return "api/trips"
    case .cities:
      return "api/cities"
    case .createTrip, .updateTrip:
      return "api/trip"
    case .addActivityToCity(let cityId):
      return "api/city/\(cityId)/activity"
    case .verifyActivityInCity(let cityId, let activityName):
      return "api/city/\(cityId)/activities/verify/\(activityName)"
    case .uploadActivityImage:
      return "api/activity/image"
    }
  }
  
  static func method(for endPoint: APIEndPoint) -> HTTPVerb {
    switch endPoint {
    case .createTrip, .addActivityToCity, .uploadActivityImage:
      return .post
    case .updateTrip:
      return .put
    default: return .get
    }
  }
}
