//
//  PinAnnotationView.swift
//  TripManager
//
//  Created by thomas lacan on 10/07/2024.
//

import MapKit

class PinAnnotationView: MKAnnotationView {
  static let kIdentifier = "Pin"

  override var annotation: MKAnnotation? {
    didSet {
      guard let mapItem = annotation as? MapItem else { return }
      image = mapItem.image
      clusteringIdentifier = PinAnnotationView.kIdentifier
    }
  }
}
