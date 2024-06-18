//
//  Untitled.swift
//  TripManager
//
//  Created by thomas lacan on 18/06/2024.
//


extension Collection {
  subscript(safe index: Index) -> Element? {
    indices.contains(index) ? self[index] : nil
  }
}
