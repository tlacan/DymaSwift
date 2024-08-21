//
//  MyTripsScreen.swift
//  TripManager
//
//  Created by thomas lacan on 23/05/2024.
//

import SwiftUI

struct MyTripsScreen: View {
  @State var viewModel = MyTripsScreenViewModel()

  struct ViewStyles {
    static let dateFont = Font.custom(R.font.avenirNextMedium, size: 12)
    static let nbPastItemsPerRow = 2
    static let futureItemShadowRadius: CGFloat = 10
    static let pastItemShadowRadius: CGFloat = 6
    static let futureItemRadius: CGFloat = 4
    static let taleImageRadius: CGFloat = 4
  }

  var tripDateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM d yyyy"
    return formatter
  }

  var pastItemsRows: Int {
    let totalValues = viewModel.pastTrips.count
    return totalValues.isMultiple(of: ViewStyles.nbPastItemsPerRow) ?
    totalValues / ViewStyles.nbPastItemsPerRow : (totalValues / ViewStyles.nbPastItemsPerRow) + 1
  }

  var body: some View {
    NavigationStack {
      GeometryReader { geo in
        ScrollView(.vertical) {
          VStack {
            futureTrips()
            pastTrips(width: geo.size.width)
          }.padding(AppStyles.Padding.medium24.rawValue)
        }
          .clipped()
          .scrollIndicators(.hidden)
          .background(Color(R.color.mainBackground.name))
          .navigationTitle(R.string.localizable.myTripsTitle())
          .navigationDestination(item: $viewModel.selectedTrip) { trip in
            MyTripsMapView(activities: trip.activities)
          }
      }
    }
  }

  @ViewBuilder
  func futureTrips() -> some View {
    VStack(alignment: .leading) {
      R.string.localizable.myTripsFutureSectionTitle()
        .textView(style: .sectionTitle, multiligneAlignment: .leading, lineLimit: 1)
        .minimumScaleFactor(0.5)
      if viewModel.futureTrips.isEmpty {
        R.string.localizable.myTripsFutureSectionEmpty()
          .textView(style: .description)
      }
      ForEach(viewModel.futureTrips, id: \.id) { trip in
        Button {
          viewModel.selectedTrip = trip
        } label: {
          futureCell(trip)
        }
      }
    }
  }

  @ViewBuilder
  func futureCell(_ trip: TripModel) -> some View {
    ZStack {
      RoundedRectangle(cornerRadius: ViewStyles.futureItemRadius)
        .fill(Color.white)
        .shadow(radius: ViewStyles.futureItemShadowRadius)
      VStack(alignment: .leading) {
        tripImage(trip)
        VStack(alignment: .leading) {
          trip.cityModel.name
            .textView(style: .navigationAction, overrideColor: Color(R.color.primaryText.name))
          if let date = trip.date {
            Text(tripDateFormatter.string(from: date))
              .font(ViewStyles.dateFont)
              .foregroundStyle(Color.accentColor)
          }
        }
      }.padding(AppStyles.Padding.small16.rawValue)
    }
  }

  @ViewBuilder
  func tripImage(_ trip: TripModel, withoutUnavailableText: Bool = false) -> some View {
    AsyncImage(url: URL(string: trip.cityModel.image), content: { image in
      if let imageValue = image.image {
        imageValue
          .resizable()
          .scaledToFill()
          .cornerRadius(ViewStyles.taleImageRadius)
      } else if image.error != nil {
        ContentUnavailableView {
          VStack {
            Image(systemName: "photo")
            if !withoutUnavailableText {
              R.string.localizable.errorImageUnavailable().textView(style: .description, multiligneAlignment: .center)
            }
          }
        }
      } else {
        ProgressView()
          .frame(maxWidth: .infinity)
      }
    })
  }

  @ViewBuilder
  func pastTrips(width: CGFloat) -> some View {
    VStack(alignment: .leading) {
      R.string.localizable.myTripsPastSectionTitle()
        .textView(style: .sectionTitle, multiligneAlignment: .leading, lineLimit: 1)
        .minimumScaleFactor(0.5)
      if viewModel.pastTrips.isEmpty {
        R.string.localizable.myTripsPastSectionEmpty()
          .textView(style: .description)
      }
      Grid(horizontalSpacing: AppStyles.Padding.small16.rawValue,
           verticalSpacing: AppStyles.Padding.small16.rawValue) {
        ForEach(0..<pastItemsRows, id: \.self) { rowIndex in
          GridRow {
            ForEach(0..<ViewStyles.nbPastItemsPerRow, id: \.self) { itemIndex in
              if let trip = viewModel.pastTrips[safe: rowIndex * ViewStyles.nbPastItemsPerRow + itemIndex] {
                Button {
                  viewModel.selectedTrip = trip
                } label: {
                  pastItem(trip, fullWidth: width)
                    .shadow(radius: ViewStyles.pastItemShadowRadius)
                }
              }
            }
          }
        }
      }
    }
  }

  func pastItem(_ trip: TripModel, fullWidth: CGFloat) -> some View {
    let nbPastItemsPerRow = CGFloat(ViewStyles.nbPastItemsPerRow)
    let gridSpacing = AppStyles.Padding.medium24.rawValue * (nbPastItemsPerRow - 1)
    let fullSpacing = gridSpacing + AppStyles.Padding.medium24.rawValue * 2
    var size = (fullWidth - fullSpacing) / nbPastItemsPerRow
    size = size.isFinite && size > 0 ? size : 1
    return ZStack(alignment: .bottom) {
      tripImage(trip, withoutUnavailableText: true)
        .frame(width: size, height: size)
      VStack(alignment: .leading) {
        VStack(alignment: .leading) {
          trip.cityModel.name.textView(style: .sectionTitle, lineLimit: 1)
          if let ago = viewModel.timeAgo(trip: trip) {
            Text(ago)
              .font(ViewStyles.dateFont)
              .foregroundStyle(Color(R.color.secondaryText.name))
          }
        }.padding(AppStyles.Padding.verySmall8.rawValue)
      }
        .frame(width: size, alignment: .leading)
        .background(Color.white)
    }
      .modifier(GridCellModifier(width: size))
      .frame(width: size, height: size)
  }
}

#Preview {
  MyTripsScreen()
}
