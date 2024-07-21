//
//  MyTripsMapViewModel.swift
//  TripManager
//
//  Created by thomas lacan on 10/07/2024.
//

import Observation
import ObjectiveC
import CoreLocation

@Observable
class MyTripsMapViewModel: NSObject, MapViewDelegate, CLLocationManagerDelegate {
  let activities: [ActivityModel]
  let locationManger = CLLocationManager()
  var hasAccessToLocation = false

  init(activities: [ActivityModel]) {
    self.activities = activities
    super.init()
    locationManger.delegate = self
    locationManger.requestWhenInUseAuthorization()
  }

  func annotations() -> [MapItem] {
    activities.map({ MapItem(item: $0) })
  }

  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    switch manager.authorizationStatus {
    case .authorizedAlways, .authorizedWhenInUse:
      hasAccessToLocation = true
      manager.startUpdatingLocation()
    default: return
    }
  }

}
