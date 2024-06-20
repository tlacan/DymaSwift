//
//  CityActivitiesScreen.swift
//  TripManager
//
//  Created by thomas lacan on 14/06/2024.
//

import SwiftUI

struct GridCellModifier: ViewModifier {
  let width: CGFloat

  struct ModifierStyles {
    static let gridItemCornerSize = CGSize(width: 20, height: 20)
  }

  func body(content: Content) -> some View {
    content
      .clipShape(RoundedRectangle(cornerSize: ModifierStyles.gridItemCornerSize))
      .frame(height: GridCellModifier.gridSquareHeight(availableFullWidth: width))
  }

  static func gridSquareHeight(availableFullWidth: CGFloat, totalColumns: Int = 2, spacing: CGFloat = AppStyles.Padding.small16.rawValue) -> CGFloat {
    let formattedColumns = CGFloat(totalColumns)
    return (availableFullWidth -
             (2 + formattedColumns - 1) * spacing) / formattedColumns
   }
}

extension View {
    func gridCellmodifier(width: CGFloat) -> ModifiedContent<Self, GridCellModifier> {
      return self.modifier(GridCellModifier(width: width))
    }
}

struct CityActivitiesScreen: View {
  @State var values = ActivityModel.sampleValues()
  @State var date = Date()
  @State var textValue = ""
  @State var password = ""
  @State var intValue: Int?
  @State var doubleValue: Double?
  @State var amount: Decimal = 0

  init() {
    teachDate()
  }

  func teachDate() {
    let now = Date()

    var dateComponents = DateComponents()
    dateComponents.year = 2024
    dateComponents.month = 7
    dateComponents.day = 12
    dateComponents.hour = 8
    dateComponents.minute = 30
    let calendar = Calendar.current // 
    let newDate = calendar.date(from: dateComponents) ?? Date()

    let nowBeforeNewDate = now < newDate
    let isSameDay = Calendar.current.isDate(now, inSameDayAs: newDate)
    var dateC = Calendar.current.date(byAdding: .day, value: -3, to: newDate) ?? Date()
    let hours = Calendar.current.component(.hour, from: newDate)
    let minutes = Calendar.current.component(.hour, from: newDate)
    dateC = Calendar.current.date(byAdding: .minute, value: hours, to: dateC) ?? Date()
    dateC = Calendar.current.date(byAdding: .minute, value: minutes, to: dateC) ?? Date()

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let value = dateFormatter.string(from: Date())
    let stringExemple = "2024-07-24 15:45:50"
    let newDate2 = dateFormatter.date(from: stringExemple)

    //ISO8601DateFormatter().string(from: <#T##Date#>)

  }
  struct ViewStyles {
    static let gridItemBottomGradient = LinearGradient(colors: [
      .black, .black.opacity(0)], startPoint: .bottom, endPoint: .top)
    static let gridItemBottomHeight: CGFloat = 48
  }

  var nbRows: Int {
    let totalValues = values.count
    return totalValues.isMultiple(of: 2) ? totalValues / 2 : (totalValues / 2) + 1
  }

  var body: some View {
    ZStack {
      Color(R.color.mainBackground.name)
        .ignoresSafeArea()
      GeometryReader { geo in
        ScrollView(.vertical) {
          Grid(horizontalSpacing: AppStyles.Padding.small16.rawValue,
               verticalSpacing: AppStyles.Padding.small16.rawValue) {
            GridRow {
              TextField("Un entier", value: $intValue, format: .number)
                .keyboardType(.numberPad)
                .gridCellColumns(2)

            }
            GridRow {
              TextField("Prix", value: $amount, format: .currency(code: "EUR"))
                .keyboardType(.decimalPad)
                .gridCellColumns(2)

            }
            GridRow {
              TextField("Un double", value: $doubleValue, format: .number)
                .keyboardType(.decimalPad)
                .gridCellColumns(2)

            }
            GridRow {
              SecureField("Mot de passe", text: $password)
                .gridCellColumns(2)

            }
            GridRow {

              TextField("texte", text: $textValue)
                .disableAutocorrection(true)
                .textInputAutocapitalization(.never)
                .textContentType(.emailAddress)
                .textFieldStyle(.roundedBorder)
                .gridCellColumns(2)
                .keyboardType(.phonePad)
                .onChange(of: textValue) { oldValue, newValue in
                  if newValue.count > 10 {
                    textValue = oldValue
                  }
                }
                .onSubmit {
                  print("test")
                }
            }
            GridRow {
              DatePicker(selection: $date, in: Date.now..., displayedComponents: .date) {
                R.string.localizable.cityActivitesDatePicker().textView(style: .description, overrideColor: Color(R.color.primaryText.name))
              }
              .gridCellColumns(2)
            }
            ForEach(0..<nbRows, id: \.self) { rowIndex in
              GridRow {
                if let activity = values[safe: rowIndex * 2] {
                  gridItem(activity: activity, fullWidth: geo.size.width)
                }
                if let activity = values[safe: rowIndex * 2 + 1] {
                  gridItem(activity: activity, fullWidth: geo.size.width)
                }
              }
            }
          }
            .padding(AppStyles.Padding.small16.rawValue)
        }.scrollIndicators(.hidden)

      }
    }
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

#Preview {
    CityActivitiesScreen()
}
