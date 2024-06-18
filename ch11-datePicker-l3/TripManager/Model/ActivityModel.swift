//
//  ActivityModel.swift
//  TripManager
//
//  Created by thomas lacan on 18/06/2024.
//

import CoreLocation

enum ActivityStatus {
  case ongoing
  case done
}

struct LocationActivity {
  var address: String?
  var longitude: CLLocationDegrees?
  var latitude: CLLocationDegrees?

  init(address: String? = nil, longitude: CLLocationDegrees? = nil, latitude: CLLocationDegrees? = nil) {
    self.address = address
    self.longitude = longitude
    self.latitude = latitude
  }
}

struct ActivityModel {
  var id: String?
  var name: String
  var image: String
  var city: String
  var price: Double
  var status: ActivityStatus
  var location: LocationActivity?

  init(name: String, city: String, image: String, price: Double, status: ActivityStatus = .ongoing, location: LocationActivity? = nil) {
    self.name = name
    self.city = city
    self.image = image
    self.price = price
    self.status = status
    self.location = location
  }

  static func sampleValues() -> [ActivityModel] {
      [
        ActivityModel(name: "Louvre Museum Visit", city: "Paris", image: "https://picsum.photos/300/300", price: 20.0,
                      location: LocationActivity(address: "Rue de Rivoli, 75001 Paris", longitude: 2.3333, 
                                                 latitude: 48.8606)),
        ActivityModel(name: "Wine Tasting", city: "Bordeaux", image: "https://picsum.photos/300/300", price: 50.0,
                      location: LocationActivity(address: "1 Cours du 30 Juillet, 33000 Bordeaux", longitude: -0.5761,
                                                 latitude: 44.8378)),
        ActivityModel(name: "Cooking Class", city: "Lyon", image: "https://picsum.photos/300/300", price: 100.0,
                      location: LocationActivity(address: "5 Quai des Célestins, 69002 Lyon", longitude: 4.8343, 
                                                 latitude: 45.7595)),
        ActivityModel(name: "Mont Saint-Michel Tour", city: "Normandy", image: "https://picsum.photos/300/300", price: 30.0,
                      location: LocationActivity(address: "50170 Mont Saint-Michel", longitude: -1.5104, latitude: 48.6358)),
        ActivityModel(name: "Perfume Workshop", city: "Grasse", image: "https://picsum.photos/300/300", price: 75.0,
                      location: LocationActivity(address: "20 Boulevard Fragonard, 06130 Grasse", longitude: 6.9232, latitude: 43.6587)),
        ActivityModel(name: "Canoeing", city: "Ardèche", image: "https://picsum.photos/300/300", price: 40.0,
                      location: LocationActivity(address: "7 Rue Jean Jaurès, 07150 Vallon-Pont-d'Arc", longitude: 4.4172, latitude: 44.4063)),
        ActivityModel(name: "Alpine Skiing", city: "Chamonix", image: "https://picsum.photos/300/300", price: 120.0,
                      location: LocationActivity(address: "35 Place de l'Église, 74400 Chamonix-Mont-Blanc", 
                                                 longitude: 6.8694, latitude: 45.9237)),
        ActivityModel(name: "Castle Tour", city: "Loire Valley", image: "https://picsum.photos/300/300", price: 25.0,
                      location: LocationActivity(address: "1 Rue d'Authion, 37400 Amboise", longitude: 0.9868, 
                                                 latitude: 47.4125)),
        ActivityModel(name: "Surfing Lessons", city: "Biarritz", image: "https://picsum.photos/300/300", price: 60.0,
                      location: LocationActivity(address: "15 Avenue de la Grande Plage, 64200 Biarritz", 
                                                 longitude: -1.5596, latitude: 43.4832)),
        ActivityModel(name: "Hot Air Balloon Ride", city: "Provence", image: "https://picsum.photos/300/300", price: 180.0,
                      location: LocationActivity(address: "10 Rue Henri Fabre, 84120 Pertuis", longitude: 5.5030, 
                                                 latitude: 43.6957))
      ]
    }
}
