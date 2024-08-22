//
//  TripService.swift
//  TripManager
//
//  Created by thomas lacan on 21/08/2024.
//

protocol TripService {
  func createTrip(_ trip: TripModel) async -> APIResponse<TripModel>
  func trips() async -> APIResponse<[TripModel]>
}

final class TripServiceNetwork: TripService {
  let networkClient: NetworkClient

  init(networkClient: NetworkClient) {
    self.networkClient = networkClient
  }

  func createTrip(_ trip: TripModel) async -> APIResponse<TripModel> {
    await networkClient.call(endPoint: .createTrip, dict: NetworkClient.encodedDict(trip))
  }

  func trips() async -> APIResponse<[TripModel]> {
    await networkClient.call(endPoint: .trips)
  }
}

final class TripServiceMock: MockService, TripService {
  func createTrip(_ trip: TripModel) async -> APIResponse<TripModel> {
    await randomWait()
    return .success(TripModel.sampleValues().first ?? TripModel(city: "", activities: []))
  }

  func trips() async -> APIResponse<[TripModel]> {
    await randomWait()
    return .success(TripModel.sampleValues())
  }
}
