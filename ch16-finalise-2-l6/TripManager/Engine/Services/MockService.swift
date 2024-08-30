//
//  MockService.swift
//  TripManager
//
//  Created by thomas lacan on 07/08/2024.
//

class MockService {
  func randomWait() async {
    try? await Task.sleep(nanoseconds: UInt64(Double.random(in: 0.1...3.0) * 1_000_000_000))
  }
}
