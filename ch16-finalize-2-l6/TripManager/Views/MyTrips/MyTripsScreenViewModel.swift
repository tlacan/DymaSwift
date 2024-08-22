//
//  MyTripsScreenViewModel.swift
//  TripManager
//
//  Created by thomas lacan on 03/07/2024.
//

import Observation
import Combine
import Foundation

@Observable
class MyTripsScreenViewModel {
  let engine: Engine
  var myTrips: [TripModel] = []
  var cities: [CityModel] = []
  var cancellables: [AnyCancellable] = []
  var selectedTrip: TripModel?

  init(engine: Engine) {
    self.engine = engine
    NotificationsConstants.didCreateTrip.publisher.sink { [weak self] notif in
      guard let tripModel = notif.object as? TripModel else { return }
      self?.myTrips.append(tripModel)
    }.store(in: &cancellables)
  }

  var futureTrips: [TripModel] {
    myTrips.filter({ ($0.date ?? Date()) >= Date() || Calendar.current.isDateInToday($0.date ?? Date()) })
  }

  var pastTrips: [TripModel] {
    myTrips.filter({ !futureTrips.contains($0) })
  }

  func timeAgo(trip: TripModel) -> String? {
    guard let date = trip.date else { return nil }
    let formatter = RelativeDateTimeFormatter()
    formatter.unitsStyle = .full
    return formatter.localizedString(for: date, relativeTo: Date())
  }

  func loadTrips(showLoader: Bool) {
    Task { [weak self] in
      let apiResult: ([TripModel]?, [CityModel]?)?
      apiResult = await self?.engine.makeAPICall(operations1: { [weak self] in
        guard let self else { return .failure(.unknownError) }
        return await self.engine.tripService.trips()
      }, operations2: { [weak self] in
        guard let self else { return .failure(.unknownError) }
        return await self.engine.cityService.cities()
      }, showLoader: showLoader)
      Task { @MainActor [weak self] in
        if let apiTrips = apiResult?.0 {
          self?.myTrips = apiTrips
        }
        if let apiCities = apiResult?.1 {
          self?.cities = apiCities
        }
      }
    }
  }

  func city(for trip: TripModel) -> CityModel? {
    cities.first(where: { $0.id == trip.city })
  }
}
