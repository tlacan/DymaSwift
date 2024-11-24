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

@Observable

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

   func createTrip() async {
     if let newApiTrip: TripModel = await DesignSystem.AppStyles.makeAPICall(
      operations: { [tripService, city, selectedActivities] in
       return await tripService.createTrip(TripModel(city: city.id, activities: selectedActivities))
     }) {
       Task { @MainActor in
         // NotificationsConstants.didCreateTrip.post(object: newApiTrip)
       }
     }
   }
 }
