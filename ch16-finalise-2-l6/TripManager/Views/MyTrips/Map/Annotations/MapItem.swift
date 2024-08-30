//
//  MapItem.swift
//  TripManager
//
//  Created by thomas lacan on 09/07/2024.
//

import MapKit

class MapItem: NSObject, MKAnnotation {

  let id: String
  let item: ActivityModel
  var coordinate: CLLocationCoordinate2D
  var image: UIImage

  init(item: ActivityModel) {
    self.item = item
    self.coordinate = CLLocationCoordinate2D(latitude: item.location?.latitude ?? 0,
                                             longitude: item.location?.longitude ?? 0)
    self.id = item.id ?? UUID().uuidString
    self.image = UIImage(named: R.image.mapPin.name) ?? UIImage()
    super.init()
  }
}
