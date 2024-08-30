//
//  Engine.swift
//  TripManager
//
//  Created by thomas lacan on 07/08/2024.
//

final class Engine {
  let networkClient = NetworkClient(server: .dev)
  let cityService: CityService
  let tripService: TripService

  init(mock: Bool) {
    self.cityService = mock ? CityServiceMock() : CityServiceNetwork(networkClient: networkClient)
    self.tripService = mock ? TripServiceMock() : TripServiceNetwork(networkClient: networkClient)
  }

  func makeAPICall<T: Decodable>(operations: () async -> APIResponse<T>,
                                 showLoader: Bool = true, showError: Bool = true) async -> T? {
    if showLoader {
      Task { @MainActor in
        AppStyles.showLoader()
      }
    }
    let apiResult = await operations()
    if showLoader {
      Task { @MainActor in
        AppStyles.hideLoader()
      }
    }
    switch apiResult {
    case .success(let result): return result
    case .failure(let error):
      if showError {
        AppStyles.showError(error)
      }
      return nil
    }
  }

  func makeAPICall<T: Decodable, V: Decodable>(operations1: () async -> APIResponse<T>,
                                               operations2: () async -> APIResponse<V>,
                                               showLoader: Bool = true, showError: Bool = true) async -> (T?, V?) {
    if showLoader {
      Task { @MainActor in
        AppStyles.showLoader()
      }
    }
    async let apiResult1Await = await operations1()
    async let apiResult2Await = await operations2()
    let (apiResult1, apiResult2) = await (apiResult1Await, apiResult2Await)

    if showLoader {
      Task { @MainActor in
        AppStyles.hideLoader()
      }
    }
    switch (apiResult1, apiResult2) {
    case (.success(let result1), .success(let result2)): return (result1, result2)
    case (.failure(let error), _):
      if showError {
        AppStyles.showError(error)
      }
      return (nil, nil)
    case (_, .failure(let error)):
      if showError {
        AppStyles.showError(error)
      }
      return (nil, nil)
    }
  }
}
