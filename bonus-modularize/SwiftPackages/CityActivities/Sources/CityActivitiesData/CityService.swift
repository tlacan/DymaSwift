//
//  Placeholder.swift
//  CityActivities
//
//  Created by thomas lacan on 24/11/2024.
//

import NetworkClient
import CityActivitiesDomain

public protocol CityService: Sendable {
  func cities() async -> APIResponse<[CityModel]>
}

final public class CityServiceNetwork: CityService, @unchecked Sendable {
  public let networkClient: NetworkClient

  public init(networkClient: NetworkClient) {
    self.networkClient = networkClient
  }

  public func cities() async -> APIResponse<[CityModel]> {
    await networkClient.call(endPoint: .cities)
  }
}

final public class CityServiceMock: CityService, @unchecked Sendable {

  public init() { }

  public func cities() async -> APIResponse<[CityModel]> {
    await NetworkClient.randomAwait()
    return .success(CityModel.sampleValues)
  }
}
