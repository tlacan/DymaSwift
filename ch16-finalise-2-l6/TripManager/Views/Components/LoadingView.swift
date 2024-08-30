//
//  LoadingView.swift
//  TripManager
//
//  Created by thomas lacan on 20/08/2024.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
      VStack {
        ProgressView()
          .padding(.top, AppStyles.Padding.medium24.rawValue)
        R.string.localizable.loaderDescription().textView(style: .sectionTitle)
        Spacer()
          .frame(width: 1, height: AppStyles.Padding.medium24.rawValue)
      }
    }
}

#Preview {
    LoadingView()
}
