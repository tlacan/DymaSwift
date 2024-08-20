//
//  CityActivitiesScreen.swift
//  TripManager
//
//  Created by thomas lacan on 14/06/2024.
//

import SwiftUI

struct CityActivitiesScreen: View {
  @Environment(\.dismiss)
  var dismiss
  @State var viewModel: CityActivitiesScreenViewModel

  struct ViewStyles {
    static let headerHeight: CGFloat = 70
    static let headerGradient = LinearGradient(stops: [
      Gradient.Stop(color: Color(R.color.mainBackground.name), location: 0.85),
      Gradient.Stop(color: Color(R.color.mainBackground.name).opacity(0), location: 1.0)
    ], startPoint: .top, endPoint: .bottom)
    static let gridItemBottomGradient = LinearGradient(colors: [
      .black, .black.opacity(0)], startPoint: .bottom, endPoint: .top)
    static let gridItemBottomHeight: CGFloat = 48
    static let itemSelectionColor = Color.black.opacity(0.5)
    static let itemSelectionIconSize = Font.system(size: 24)
  }

  init(city: CityModel) {
    _viewModel = State(initialValue: CityActivitiesScreenViewModel(city: city))
  }

  var nbRows: Int {
    let totalValues = viewModel.values.count
    return totalValues.isMultiple(of: 2) ? totalValues / 2 : (totalValues / 2) + 1
  }

  var body: some View {
    ZStack {
      Color(R.color.mainBackground.name)
        .ignoresSafeArea()
      ZStack(alignment: .top) {
        scrollContentView()
        header()
      }
    }
      .navigationBarTitleDisplayMode(.inline)
      .navigationTitle(R.string.localizable.cityActivitiesTitle())
      .toolbar {
        ToolbarItem(placement: .primaryAction) {
          Button {
            viewModel.createTrip()
            dismiss()
          } label: {
            Text(R.string.localizable.cityActivitiesButtonCreate)
          }.disabled(viewModel.selectedActivities.isEmpty)
        }
      }
  }

  @ViewBuilder
  func scrollContentView() -> some View {
    GeometryReader { geo in
      ScrollView(.vertical) {
        Grid(horizontalSpacing: AppStyles.Padding.small16.rawValue,
             verticalSpacing: AppStyles.Padding.small16.rawValue) {
          GridRow {
            Color(R.color.mainBackground.name)
              .frame(width: ViewStyles.headerHeight, height: ViewStyles.headerHeight)
          }
          ForEach(0..<nbRows, id: \.self) { rowIndex in
            GridRow {
              if let activity = viewModel.values[safe: rowIndex * 2] {
                itemButton(activity: activity, fullWidth: geo.size.width)
              }
              if let activity = viewModel.values[safe: rowIndex * 2 + 1] {
                itemButton(activity: activity, fullWidth: geo.size.width)
              }
            }
          }
        }.padding(AppStyles.Padding.small16.rawValue)
      }
        .clipped()
        .scrollIndicators(.hidden)

    }
  }

  @ViewBuilder
  func header() -> some View {
    VStack {
      DatePicker(selection: $viewModel.date, in: Date()..., displayedComponents: .date) {
        R.string.localizable.cityActivitiesDatePicker().textView(style: .description,
                                                                 overrideColor: Color(R.color.primaryText.name))
      }
      PriceTextField(currencySymbol: "€", placeholder: R.string.localizable.cityActivitiesPrice(),
                     value: $viewModel.doubleValue)
        .font(AppStyles.TextStyles.description.font)
        .multilineTextAlignment(.trailing)
        .disabled(true)

    }
      .padding(AppStyles.Padding.small16.rawValue)
      .background(ViewStyles.headerGradient)
  }

  @ViewBuilder
  func itemButton(activity: ActivityModel, fullWidth: CGFloat) -> some View {
    let selected = viewModel.selectedActivities.contains(activity)
    Button {
      if selected {
        viewModel.selectedActivities.removeAll(where: { $0 == activity })
        return
      }
      viewModel.selectedActivities.append(activity)
    } label: {
      ZStack(alignment: .topTrailing) {
        gridItem(activity: activity, fullWidth: fullWidth)
          .overlay {
            if selected {
              RoundedRectangle(cornerSize: GridCellModifier.ModifierStyles.gridItemCornerSize)
                .fill(ViewStyles.itemSelectionColor)
            }
          }
        if selected {
          Image(systemName: "checkmark.circle.fill")
            .symbolRenderingMode(.palette)
            .foregroundStyle(Color.accentColor, .white)
            .font(ViewStyles.itemSelectionIconSize)
            .padding(AppStyles.Padding.verySmall8.rawValue)
        }
      }
    }.buttonStyle(PlainButtonStyle())
  }

  @ViewBuilder
  func gridItem(activity: ActivityModel, fullWidth: CGFloat) -> some View {
    AsyncImage(url: URL(string: activity.image)) { image in
      if let imageValue = image.image {
        ZStack(alignment: .bottomLeading) {
          imageValue
            .resizable()
            .scaledToFill()
          ViewStyles.gridItemBottomGradient.frame(height: ViewStyles.gridItemBottomHeight)
          activity.name.textView(style: .buttonCTA, lineLimit: 1)
            .padding(AppStyles.Padding.verySmall8.rawValue)
            .minimumScaleFactor(0.5)
        }
      } else if image.error != nil {
        ContentUnavailableView {
          VStack {
            Image(systemName: "photo")
            R.string.localizable.errorImageUnavailable().textView(style: .description, multiligneAlignment: .center)
          }
        }
      } else {
        ProgressView()
          .frame(maxWidth: .infinity)
      }
    }
    .background(Color(R.color.mainBackground.name))
    .modifier(GridCellModifier(width: fullWidth))
  }
}
