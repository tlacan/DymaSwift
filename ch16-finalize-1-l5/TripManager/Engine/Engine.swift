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
}
