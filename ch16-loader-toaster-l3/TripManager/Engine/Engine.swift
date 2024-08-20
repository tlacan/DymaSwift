//
//  Engine.swift
//  TripManager
//
//  Created by thomas lacan on 07/08/2024.
//

final class Engine {
  let networkClient = NetworkClient(server: .dev)
  let cityService: CityService

  init(mock: Bool) {
    self.cityService = mock ? CityServiceMock() : CityServiceNetwork(networkClient: networkClient)
  }
}
