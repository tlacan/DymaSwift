import SwiftUI
import CityActivitiesDomain
import DesignSystem
import CityActivitiesData
import Swinject
import NetworkClient

public struct HomeScreen: View {
  enum ViewStyles {
    static let cityCellHeight: CGFloat = 200
    static let cityCellBottomHeight: CGFloat = 48
    static let cellBottomColor = Color.white.opacity(0.8)
    static let cityCornerSize = CGSize(width: 20, height: 10)
  }

  @State private var values: [CityModel] = []
  @State private var searchText = ""
  @State private var cityDestination: CityModel?

  let cityService: CityService

  public init(networkClient: NetworkClient, mock: Bool = false) {
    self.cityService = mock ? CityServiceMock() : CityServiceNetwork(networkClient: networkClient)
  }

  public var body: some View {
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
        /*
         .navigationDestination(item: $cityDestination) { city in
          CityActivitiesScreen(city: city, networkClient: cityService.networkClient)
        }
         */
        .background(Color(DesignSystem.R.color.mainBackground.name))
        .scrollContentBackground(.hidden)
        .listRowSpacing(AppStyles.Padding.small16.rawValue)
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        .navigationTitle(R.string.localizable.HomeScreenNavigationTitle())
        .overlay {
          if !values.contains(where: { city in
              city.name.lowercased().contains(searchText.lowercased()) || searchText.isEmpty
            }) {
                ContentUnavailableView.search
            }
        }
        /*.task {
          if !values.isEmpty {
            return
          }
          let cities: [CityModel]? = await AppStyles.makeAPICall {
            await cityService.cities()
          }
          Task { @MainActor in
            self.values = cities ?? []
          }
        }*/
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
          .background(Color(DesignSystem.R.color.mainBackground.name))
    }
  }
}

#Preview {
  HomeScreen(networkClient: NetworkClient(server: .dev), mock: true)
}
