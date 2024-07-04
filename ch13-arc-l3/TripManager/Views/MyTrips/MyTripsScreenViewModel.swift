//
//  MyTripsScreenViewModel.swift
//  TripManager
//
//  Created by thomas lacan on 03/07/2024.
//

import Observation
import Combine

@Observable
class MyTripsScreenViewModel {
  var myTrips: [TripModel] = []
  var cancellables: [AnyCancellable] = []

  init() {
    NotificationsConstants.didCreateTrip.publisher.sink { [weak self] notif in
      guard let tripModel = notif.object as? TripModel else { return }
      self?.myTrips.append(tripModel)
    }.store(in: &cancellables)
  }
}
