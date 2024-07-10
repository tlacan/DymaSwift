//
//  MapView.swift
//  TripManager
//
//  Created by thomas lacan on 09/07/2024.
//

import SwiftUI
import UIKit
import MapKit

protocol MapViewDelegate: MKMapViewDelegate {
  func annotations() -> [MapItem]
}

struct MapView: UIViewRepresentable {
  weak var delegate: MapViewDelegate?

  func makeUIView(context: Context) -> MKMapView {
    MKMapView(frame: .zero)
  }

  func updateUIView(_ view: MKMapView, context: Context) {
    view.delegate = delegate
    view.addAnnotations(delegate?.annotations() ?? [])
  }
}
