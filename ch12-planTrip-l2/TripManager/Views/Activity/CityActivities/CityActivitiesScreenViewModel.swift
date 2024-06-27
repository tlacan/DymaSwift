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
 }
