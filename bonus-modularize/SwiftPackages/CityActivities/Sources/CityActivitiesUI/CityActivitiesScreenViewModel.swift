//
//  CityActivitiesScreenViewModel.swift
//  TripManager
//
//  Created by thomas lacan on 26/06/2024.
//

import Observation
import Foundation
import Combine
import CityActivitiesDomain
import DesignSystem
import NetworkClient
import CityActivitiesData
import GlobalHelper

@Observable
@MainActor
 class CityActivitiesScreenViewModel {
   let city: CityModel
   var values: [ActivityModel]
   var date = Date()
   var doubleValue: Double?
   let tripService: TripService

   var selectedActivities: [ActivityModel] = [] {
     didSet {
       if selectedActivities.isEmpty {
         doubleValue = nil
         return
       }
       doubleValue = selectedActivities.map({ $0.price }).reduce(0, +)
     }
   }

   init(city: CityModel,
        networkClient: NetworkClient,
        date: Date = Date(),
        doubleValue: Double? = nil,
        mock: Bool = false) {
     self.city = city
     self.values = city.activities
     self.date = date
     self.doubleValue = doubleValue
     self.selectedActivities = []
     self.tripService = mock ? TripServiceMock() : TripServiceNetwork(networkClient: networkClient)
   }

   @discardableResult
   func createTrip() async -> TripModel? {
     let result = await AppStyles.makeAPICall {
       await tripService.createTrip(TripModel(city: city.id, activities: selectedActivities))
     }
     if let result {
       NotificationsConstants.didCreateTrip.post(object: result)
     }
     return result
     /*
      Version B
     await AppStyles.showLoader()
     let apiResult = await tripService.createTrip(TripModel(city: city.id, activities: selectedActivities))
     await AppStyles.hideLoader()
     switch apiResult {
     case .success(let result): return result
     case .failure(let error):
       await AppStyles.showError(error)
       return nil
     }
      */
   }
 }
