//
//  MyTripsMapView.swift
//  TripManager
//
//  Created by thomas lacan on 10/07/2024.
//

import SwiftUI

struct MyTripsMapView: View {
  @State var viewModel: MyTripsMapViewModel
  @State var mapView: MapView

  struct ViewStyles {
    static let buttonSize: CGFloat = 32
  }

  init(activities: [ActivityModel] = ActivityModel.sampleValues()) {
    let viewModel = MyTripsMapViewModel(activities: activities)
    self._viewModel = State(initialValue: viewModel)
    self._mapView = State(initialValue: MapView(delegate: viewModel))
  }

  var body: some View {
    ZStack(alignment: .bottomTrailing) {
      mapView
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
      if viewModel.hasAccessToLocation {
        centerOnUserButton()
          .offset(x: -AppStyles.Padding.medium24.rawValue,
                  y: -AppStyles.Padding.medium24.rawValue)
      }
    }
  }

  @ViewBuilder
  func centerOnUserButton() -> some View {
    Button {
      if let location = viewModel.locationManger.location {
        mapView.center(at: location.coordinate)
      }
    } label: {
      Image(systemName: "location.circle.fill")
        .symbolRenderingMode(.palette)
        .foregroundStyle(Color(uiColor: .systemBlue), Color.white)
        .font(.system(size: ViewStyles.buttonSize))
    }
  }
}

#Preview {
    MyTripsMapView()
}
