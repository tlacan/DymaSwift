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
      .frame(height: GridCellModifier.gridSquareHeight(availableFullWidth:width))
  }

  static func gridSquareHeight(availableFullWidth: CGFloat, totalColumns: Int = 2, spacing: CGFloat = AppStyles.Padding.small16.rawValue) -> CGFloat {
    let formattedColumns = CGFloat(totalColumns)
     return (availableFullWidth - (2 + formattedColumns - 1) * spacing) / formattedColumns
   }
}

extension View {
    func gridCellmodifier(width: CGFloat) -> ModifiedContent<Self, GridCellModifier> {
      return self.modifier(GridCellModifier(width: width))
    }
}

struct CityActivitiesScreen: View {
  var body: some View {
        GeometryReader { geo in
          ScrollView(.vertical) {
            Grid(horizontalSpacing: AppStyles.Padding.small16.rawValue,
                 verticalSpacing: AppStyles.Padding.small16.rawValue) {
              GridRow {
                Color.clear
                  .frame(height: 1)
                Text("Mon exemple")
              }
              ForEach(1..<10) { _ in
                GridRow {
                  Color.yellow
                    .gridCellmodifier(width: geo.size.width)
                  Color.red
                    .modifier(GridCellModifier(width: geo.size.width))
                }
              }
            }.padding(AppStyles.Padding.small16.rawValue)
          }
      }
  }
}

#Preview {
    CityActivitiesScreen()
}
