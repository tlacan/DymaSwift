//
//  MyTripsMapView.swift
//  TripManager
//
//  Created by thomas lacan on 10/07/2024.
//

import SwiftUI

struct MyTripsMapView: View {
  @State var viewModel: MyTripsMapViewModel

  init(activities: [ActivityModel] = ActivityModel.sampleValues()) {
    self._viewModel = State(initialValue: MyTripsMapViewModel(activities: activities))
  }

  var body: some View {
    MapView(delegate: viewModel)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .ignoresSafeArea()
  }
}

#Preview {
    MyTripsMapView()
}
