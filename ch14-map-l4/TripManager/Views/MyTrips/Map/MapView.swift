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
  let view = MKMapView(frame: .zero)

  func makeUIView(context: Context) -> MKMapView {
    view
  }

  func updateUIView(_ view: MKMapView, context: Context) {
    let annotations = delegate?.annotations() ?? []
    view.delegate = delegate
    view.addAnnotations(annotations)
    if let firstCenter = annotations.first {
      center(at: firstCenter.coordinate)
    }
    view.showsUserLocation = true
    view.userTrackingMode = .follow
    view.register(PinAnnotationView.self,
                  forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
    view.register(ClusterAnnotationView.self,
                  forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
  }

  func center(at coordinate: CLLocationCoordinate2D) {
    let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    let region = MKCoordinateRegion(center: coordinate, span: span)
    view.setRegion(region, animated: true)
  }
}
