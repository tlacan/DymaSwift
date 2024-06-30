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
   let city: CityModel
   var values = ActivityModel.sampleValues()
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

   init(city: CityModel, values: [ActivityModel] = ActivityModel.sampleValues(),
        date: Date = Date(), doubleValue: Double? = nil) {
     self.city = city
     self.values = values
     self.date = date
     self.doubleValue = doubleValue
     self.selectedActivities = []
   }

   func createTrip() {
     let newTrip = TripModel(id: UUID().uuidString, city: city.id, activities: selectedActivities)
   }
 }
