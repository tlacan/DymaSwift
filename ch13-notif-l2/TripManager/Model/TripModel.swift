//
//  TripModel.swift
//  TripManager
//
//  Created by thomas lacan on 30/06/2024.
//

import Foundation

struct TripModel {
  var id: String?
  var city: String
  var activities: [ActivityModel]
  var date: Date?
}
