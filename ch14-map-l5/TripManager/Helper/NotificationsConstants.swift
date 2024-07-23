//
//  NotificationsConstants.swift
//  TripManager
//
//  Created by thomas lacan on 03/07/2024.
//

import Foundation

enum NotificationsConstants: String {
  case didCreateTrip

  var notificationName: Notification.Name {
    Notification.Name(rawValue: self.rawValue)
  }

  var publisher: NotificationCenter.Publisher {
    NotificationCenter.default.publisher(for: notificationName)
  }

  func post(object: Any? = nil) {
    NotificationCenter.default.post(name: notificationName, object: object)
  }
}
