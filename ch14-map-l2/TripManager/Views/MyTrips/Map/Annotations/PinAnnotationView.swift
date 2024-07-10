//
//  PinAnnotationView.swift
//  TripManager
//
//  Created by thomas lacan on 10/07/2024.
//

import MapKit

class PinAnnotationView: MKAnnotationView {
  override var annotation: MKAnnotation? {
    didSet {
      guard let mapItem = annotation as? MapItem else { return }
      image = mapItem.image
    }
  }
}
