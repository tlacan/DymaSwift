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
    static let activitySheetHeight: CGFloat = 0.33
  }

  init(activities: [ActivityModel] = ActivityModel.sampleValues()) {
    let viewModel = MyTripsMapViewModel(activities: activities)
    self._viewModel = State(initialValue: viewModel)
    self._mapView = State(initialValue: MapView(delegate: viewModel))
  }

  var body: some View {
    GeometryReader { geo in
      ZStack(alignment: .bottomTrailing) {
        mapView
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .ignoresSafeArea()
        if viewModel.hasAccessToLocation {
          centerOnUserButton()
            .offset(x: -AppStyles.Padding.medium24.rawValue,
                    y: viewModel.selectedAnnotation != nil ?
                    -(AppStyles.Padding.medium24.rawValue  + geo.size.height * ViewStyles.activitySheetHeight) :
                      -AppStyles.Padding.medium24.rawValue)
        }
      }
    }

    .sheet(isPresented: Binding(get: {
      viewModel.selectedAnnotation != nil
    }, set: { _ in }), content: {
        if let item = viewModel.selectedAnnotation?.annotation as? MapItem {
          selectedAnnotationView(item)
            .interactiveDismissDisabled()
            .presentationDetents([.fraction(ViewStyles.activitySheetHeight)])
            .presentationBackgroundInteraction(.enabled(upThrough: .fraction(ViewStyles.activitySheetHeight)))
        }
    })

    .onChange(of: viewModel.selectedAnnotation) { _, newValue in
      if let selectedAnnotation = newValue?.annotation as? MapItem {
        mapView.center(at: selectedAnnotation.coordinate, zoomValue: 0.005)
      }
    }
  }

  @ViewBuilder
  func selectedAnnotationView(_ mapItem: MapItem) -> some View {
    VStack {
      mapItem.item.name.textView(style: .title, multiligneAlignment: .center)
      PriceTextField(currencySymbol: "€", placeholder: R.string.localizable.cityActivitiesPrice(),
                     value: .constant(mapItem.item.price))
        .font(AppStyles.TextStyles.description.font)
        .multilineTextAlignment(.trailing)
        .disabled(true)
    }.padding(.horizontal, AppStyles.Padding.medium24.rawValue)
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
