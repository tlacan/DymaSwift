//
//  MyTripsMapViewModel.swift
//  TripManager
//
//  Created by thomas lacan on 10/07/2024.
//

import Observation
import ObjectiveC
import CoreLocation
import MapKit

@Observable
class MyTripsMapViewModel: NSObject, MapViewDelegate, CLLocationManagerDelegate {
  static let zoomImageIncrease: CGFloat = 1.4

  let activities: [ActivityModel]
  let locationManger = CLLocationManager()
  var hasAccessToLocation = false
  weak var selectedAnnotation: PinAnnotationView?
  var didCenterOnSelectedAnnotation: Bool = false

  init(activities: [ActivityModel]) {
    self.activities = activities
    super.init()
    locationManger.delegate = self
    locationManger.requestWhenInUseAuthorization()
  }

  func annotations() -> [MapItem] {
    activities.map({ MapItem(item: $0) })
  }

  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    switch manager.authorizationStatus {
    case .authorizedAlways, .authorizedWhenInUse:
      hasAccessToLocation = true
      manager.startUpdatingLocation()
    default: return
    }
  }

  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    guard let selectedAnnotation = view as? PinAnnotationView,
          let item = selectedAnnotation.annotation as? MapItem else { return }
    didCenterOnSelectedAnnotation = false
    self.selectedAnnotation = selectedAnnotation
    resizeAnnotationViewImage(sizeInPercent: MyTripsMapViewModel.zoomImageIncrease,
                              mapView: selectedAnnotation, image: item.image)
  }

  func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
    guard let selectedAnnotation,
          let image = selectedAnnotation.image else { return }

    if !didCenterOnSelectedAnnotation {
      didCenterOnSelectedAnnotation = true
      return
    }
    resizeAnnotationViewImage(sizeInPercent: CGFloat(1) / MyTripsMapViewModel.zoomImageIncrease,
                              mapView: selectedAnnotation, image: image)
    didCenterOnSelectedAnnotation = false
    self.selectedAnnotation = nil
    mapView.selectedAnnotations.removeAll()
  }

  func resizeAnnotationViewImage(sizeInPercent: CGFloat, mapView: PinAnnotationView, image: UIImage) {
    UIView.animate(withDuration: 0.1) {
      let newSize = CGSize(width: image.size.width * sizeInPercent, height: image.size.height * sizeInPercent)
      let renderer = UIGraphicsImageRenderer(size: newSize)
      let resizedImage = renderer.image { _ in
        image.draw(in: CGRect(origin: .zero, size: newSize))
      }
      mapView.image = resizedImage
    }
  }
}
