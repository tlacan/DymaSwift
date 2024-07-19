//
//  MyTripsMapViewModel.swift
//  TripManager
//
//  Created by thomas lacan on 10/07/2024.
//

import Observation
import ObjectiveC

@Observable
class MyTripsMapViewModel: NSObject, MapViewDelegate {
  let activities: [ActivityModel]

  init(activities: [ActivityModel]) {
    self.activities = activities
  }

  func annotations() -> [MapItem] {
    activities.map({ MapItem(item: $0) })
  }
}
