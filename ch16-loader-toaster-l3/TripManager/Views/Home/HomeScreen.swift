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
    static let cityCellBottomHeight: CGFloat = 48
    static let cellBottomColor = Color.white.opacity(0.8)
    static let cityCornerSize = CGSize(width: 20, height: 10)
  }

  let engine: Engine

  @State private var values: [CityModel] = []
  @State private var searchText = ""
  @State private var cityDestination: CityModel?

  var body: some View {
    NavigationStack {
        List {
          ForEach(values.filter({ city in
            city.name.lowercased().contains(searchText.lowercased()) || searchText.isEmpty
          })) { city in
            Button {
              cityDestination = city
            } label: {
              cityCell(city)
            }
              .buttonStyle(HighlightButton())
              .listRowSeparator(.hidden)
              .listRowInsets(EdgeInsets())
          }
        }
        .navigationDestination(item: $cityDestination) { city in
          CityActivitiesScreen(city: city)
        }
        .background(Color(R.color.mainBackground.name))
        .scrollContentBackground(.hidden)
        .listRowSpacing(AppStyles.Padding.small16.rawValue)
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        .navigationTitle(R.string.localizable.tabHome())
        .overlay {
            if values.filter({ city in
              city.name.lowercased().contains(searchText.lowercased()) || searchText.isEmpty
            }).isEmpty {
                ContentUnavailableView.search
            }
        }
        .onAppear {
          Task { @MainActor in
            EntryKitViewDisplayer.showLoader()
            try? await Task.sleep(nanoseconds: 3_000_000_000)
            EntryKitViewDisplayer.hideLoader()
          }
        }
        .task {
          let apiResult = await engine.cityService.cities()
          switch apiResult {
          case .success(let cities):
            Task { @MainActor in
              self.values = cities
            }
          case .failure(let error):
            print(error.localizedDescription)
          }
        }
      }
  }

  @ViewBuilder
  func cityCell(_ city: CityModel) -> some View {
    AsyncImage(url: URL(string: city.image)) { image in
      ZStack(alignment: .bottomLeading) {
        GeometryReader { geo in
          image
            .resizable()
            .scaledToFill()
            .frame(width: geo.size.width, height: ViewStyles.cityCellHeight)
            .clipped()
          VStack {
            Spacer()
            ZStack(alignment: .bottomLeading) {
              ViewStyles.cellBottomColor
                .frame(height: ViewStyles.cityCellBottomHeight)
              city.name.textView(style: .sectionTitle)
                .offset(x: AppStyles.Padding.small16.rawValue, y: -AppStyles.Padding.verySmall8.rawValue)
            }
          }
        }
      }
        .clipShape(RoundedRectangle(cornerSize: ViewStyles.cityCornerSize))
        .frame(height: ViewStyles.cityCellHeight)
    } placeholder: {
        ProgressView()
          .frame(maxWidth: .infinity, alignment: .center)
          .frame(height: ViewStyles.cityCellHeight)
          .background(Color(R.color.mainBackground.name))
    }
  }
}

#Preview {
  HomeScreen(engine: Engine(mock: true))
}
