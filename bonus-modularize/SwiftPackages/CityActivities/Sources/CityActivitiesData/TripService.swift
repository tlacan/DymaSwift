//
//  TripService.swift
//  TripManager
//
//  Created by thomas lacan on 21/08/2024.
//

import NetworkClient
import CityActivitiesDomain

public protocol TripService {
  func createTrip(_ trip: TripModel) async -> APIResponse<TripModel>
  func trips() async -> APIResponse<[TripModel]>
}

public final class TripServiceNetwork: TripService {
  let networkClient: NetworkClient

  public init(networkClient: NetworkClient) {
    self.networkClient = networkClient
  }

  public func createTrip(_ trip: TripModel) async -> APIResponse<TripModel> {
    await networkClient.call(endPoint: .createTrip, dict: NetworkClient.encodedDict(trip))
  }

  public func trips() async -> APIResponse<[TripModel]> {
    await networkClient.call(endPoint: .trips)
  }
}

public final class TripServiceMock: TripService {

  public init() { }
  public func createTrip(_ trip: TripModel) async -> APIResponse<TripModel> {
    await NetworkClient.randomAwait()
    return .success(TripModel.sampleValues().first ?? TripModel(city: "", activities: []))
  }

  public func trips() async -> APIResponse<[TripModel]> {
    await NetworkClient.randomAwait()
    return .success(TripModel.sampleValues())
  }
}
