//
//  CityActivitiesScreenViewModel.swift
//  TripManager
//
//  Created by thomas lacan on 26/06/2024.
//

import Observation
import Foundation
import Combine

/*
 Combine version
class CityActivitiesScreenViewModel: ObservableObject {
  @Published var values = ActivityModel.sampleValues()
  @Published var date = Date()
  @Published var doubleValue: Double?

}
*/

 @Observable
 class CityActivitiesScreenViewModel {
   var values = ActivityModel.sampleValues()
   var date = Date()
   var doubleValue: Double?
 }
