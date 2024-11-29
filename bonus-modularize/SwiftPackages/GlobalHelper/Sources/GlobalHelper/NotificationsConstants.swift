//
//  NotificationsConstants.swift
//  TripManager
//
//  Created by thomas lacan on 03/07/2024.
//

import Foundation

public enum NotificationsConstants: String {
  case didCreateTrip

  public var notificationName: Notification.Name {
    Notification.Name(rawValue: self.rawValue)
  }

  public var publisher: NotificationCenter.Publisher {
    NotificationCenter.default.publisher(for: notificationName)
  }

  public func post(object: Any? = nil) {
    NotificationCenter.default.post(name: notificationName, object: object)
  }
}
