//
//  PriceTextField.swift
//  TripManager
//
//  Created by thomas lacan on 21/06/2024.
//

import SwiftUI

struct PriceTextField: View {

  let currencySymbol: String?
  let placeholder: String
  @Binding private var value: Double?
  @State private var text: String
  @FocusState private var isTextFieldFocused: Bool

  static var numberFormatter: NumberFormatter {
    let numberFormatter = NumberFormatter()
    numberFormatter.locale = Locale.current
    numberFormatter.maximumFractionDigits = 2
    numberFormatter.minimumFractionDigits = 2
    numberFormatter.numberStyle = .decimal
    return numberFormatter
  }

  init(currencySymbol: String?, placeholder: String, value: Binding<Double?>) {
    self.currencySymbol = currencySymbol
    self.placeholder = placeholder
    self._value = value
    var textFromDouble = PriceTextField.numberFormatter.string(from: NSNumber(value: value.wrappedValue ?? 0)) ?? ""
    textFromDouble += currencySymbol != nil ? " \(currencySymbol ?? "")" : ""
    self._text = State(initialValue: value.wrappedValue == nil ? "" : textFromDouble)
  }

    var body: some View {
      TextField(currencySymbol == nil ? placeholder : "\(placeholder) \(currencySymbol ?? "")", text: $text)
        .focused($isTextFieldFocused)
        .onChange(of: isTextFieldFocused) { _, isFocusOn in
          if isFocusOn {
            removeCurrencyIfNeeded()
            return
          }
          updateValue()
        }
        .onChange(of: value) { _, newValue in
          updateTextFromValue(newValue)
        }
    }

  func updateTextFromValue(_ newValue: Double?) {
    guard let newValue else {
      text = ""
      return
    }
    var updatedText = PriceTextField.numberFormatter.string(from: NSNumber(value: newValue)) ?? ""
    updatedText += currencySymbol != nil ? " \(currencySymbol ?? "")" : ""
    text = updatedText
  }

  func removeCurrencyIfNeeded() {
    text = text.replacingOccurrences(of: " \(currencySymbol ?? "")", with: "")
  }

  func updateValue() {
    if text.isEmpty {
      value = nil
      return
    }
    let doubleValue = PriceTextField.numberFormatter.number(from: text)?.doubleValue
    value = doubleValue
    text = doubleValue == nil ? "" :
           PriceTextField.numberFormatter.string(from: NSNumber(value: doubleValue ?? 0)) ?? ""
    if !text.isEmpty {
      text += currencySymbol == nil ? "" : " \(currencySymbol ?? "")"
    }
  }
}

#Preview {
  PriceTextField(currencySymbol: "$", placeholder: "Price", value: .constant(4))
}
