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
    let annotations = delegate?.annotations() ?? []
    view.delegate = delegate
    view.addAnnotations(annotations)
    if let firstCenter = annotations.first {
      let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
      let region = MKCoordinateRegion(center: firstCenter.coordinate, span: span)
      view.setRegion(region, animated: false)
    }
    view.register(PinAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
  }
}
