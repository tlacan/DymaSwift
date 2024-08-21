//
//  CityActivitiesScreenViewModel.swift
//  TripManager
//
//  Created by thomas lacan on 26/06/2024.
//

import Observation
import Foundation
import Combine

 @Observable
 class CityActivitiesScreenViewModel {
   let engine: Engine
   let city: CityModel
   var values: [ActivityModel]
   var date = Date()
   var doubleValue: Double?
   var selectedActivities: [ActivityModel] = [] {
     didSet {
       if selectedActivities.isEmpty {
         doubleValue = nil
         return
       }
       doubleValue = selectedActivities.map({ $0.price }).reduce(0, +)
     }
   }

   init(city: CityModel, engine: Engine,
        date: Date = Date(), doubleValue: Double? = nil) {
     self.city = city
     self.engine = engine
     self.values = city.activities
     self.date = date
     self.doubleValue = doubleValue
     self.selectedActivities = []
   }

   func createTrip() {
     Task {
       if let newApiTrip: TripModel = await engine.makeAPICall(operations: {
         await engine.tripService.createTrip(TripModel(city: city.id, activities: selectedActivities))
       }) {
         Task { @MainActor in
           NotificationsConstants.didCreateTrip.post(object: newApiTrip)
         }
       }
     }
   }
 }
