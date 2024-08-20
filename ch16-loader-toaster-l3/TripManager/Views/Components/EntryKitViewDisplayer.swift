//
//  EntryKitViewDisplayer.swift
//  TripManager
//
//  Created by thomas lacan on 20/08/2024.
//

import SwiftEntryKit
import UIKit
import SwiftUI

struct EntryKitViewDisplayer {
  static let loadingEntryName = "LoadingView"

  static func showMessage(_ message: String,
                          stick: Bool = false,
                          color: UIColor = UIColor(named: R.color.secondaryRed.name) ?? .red) {
    let style = EKProperty.LabelStyle(font: AppStyles.TextStyles.description.uiFont ?? .boldSystemFont(ofSize: 12),
                                      color: .white,
                                      alignment: .center)
    let labelContent = EKProperty.LabelContent(text: message, style: style)
    let contentView = EKNoteMessageView(with: labelContent)

    var attributes: EKAttributes
    attributes = .topNote
    attributes.precedence = .enqueue(priority: .normal)
    attributes.hapticFeedbackType = .success
    attributes.displayDuration = stick ? .infinity : 2
    if stick {
      attributes.entryInteraction = .dismiss
    }
    attributes.popBehavior = .animated(animation: .translation)
    attributes.entryBackground = .color(color: EKColor(light: color, dark: color))
    attributes.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 2))
    SwiftEntryKit.display(entry: contentView, using: attributes)
  }

  static func showLoader() {
    if SwiftEntryKit.isCurrentlyDisplaying(entryNamed: EntryKitViewDisplayer.loadingEntryName) {
      return
    }
    let loadingViewController = UIHostingController(rootView: LoadingView())
    var attributes = EKAttributes.centerFloat
    attributes.displayDuration = .infinity
    attributes.screenBackground = .visualEffect(style: .standard)
    attributes.entryBackground = .color(color: .white)
    attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 8))
    attributes.screenInteraction = .absorbTouches
    attributes.entryInteraction = .absorbTouches
    attributes.roundCorners = .all(radius: 8)
    attributes.entranceAnimation = .init(translate:
                                   .init(duration: 0.7, spring: .init(damping: 0.7, initialVelocity: 0)))
    attributes.exitAnimation = .init(translate: .init(duration: 0.2))
    attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.35)))
    attributes.name = EntryKitViewDisplayer.loadingEntryName
    loadingViewController.view.layer.cornerRadius = 25
    SwiftEntryKit.display(entry: loadingViewController.view, using: attributes)
  }

  static func hideLoader() {
    SwiftEntryKit.dismiss(.specific(entryName: EntryKitViewDisplayer.loadingEntryName))
  }
}
