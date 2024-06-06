//
//  HomeScreen.swift
//  TripManager
//
//  Created by thomas lacan on 23/05/2024.
//

import SwiftUI

struct HomeScreen: View {
  struct ViewStyles {
    static let cityCellHeight: CGFloat = 200
    static let cellCellBottomHeight: CGFloat = 48
    static let cellBottomColor = Color.white.opacity(0.8)
    static let cornerSize = CGSize(width: 20, height: 10)
  }

  @State private var values = CityModel.sampleValues
  @State private var searchText = ""

  var body: some View {
    NavigationStack {
      List {
        ForEach(values.filter({ $0.name.lowercased().contains(searchText.lowercased()) || searchText.isEmpty })) { city in
          cityCell(city)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets())
        }
      }
      .navigationTitle(R.string.localizable.tabHome())
      .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
      .listRowSpacing(AppStyles.Padding.small16.rawValue)
      .background(Color(R.color.mainBackground.name))
      .scrollContentBackground(.hidden)
      .overlay {
        if values.filter({ $0.name.lowercased().contains(searchText.lowercased()) || searchText.isEmpty }).isEmpty {
          ContentUnavailableView.search
        }
      }
    }
  }

  @ViewBuilder
  func cityCell(_ city: CityModel) -> some View {
    AsyncImage(url: URL(string: city.image)) { image in
      ZStack(alignment: .bottomLeading, content: {
        image
          .resizable()
          .scaledToFill()
          .frame(height: ViewStyles.cityCellHeight)
        ViewStyles.cellBottomColor
          .frame(height: ViewStyles.cellCellBottomHeight)
        city.name.textView(style: .sectionTitle)
          .offset(x: ViewStyles.cellCellBottomHeight, y: -AppStyles.Padding.verySmall8.rawValue)
      })
        .clipShape(RoundedRectangle(cornerSize: ViewStyles.cornerSize))
        .frame(height: ViewStyles.cityCellHeight, alignment: .bottomLeading)
    } placeholder: {
      ProgressView()
        .frame(maxWidth: .infinity, alignment: .center)
        .frame(height: ViewStyles.cityCellHeight)
        .background(Color(R.color.mainBackground.name))
    }
  }
}

#Preview {
    HomeScreen()
}
