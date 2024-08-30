//
//  ClusterAnnotationView.swift
//  TripManager
//
//  Created by thomas lacan on 19/07/2024.
//

import UIKit
import MapKit

class ClusterAnnotationView: MKAnnotationView {
  override var annotation: MKAnnotation? {
    didSet {
      guard let cluster = annotation as? MKClusterAnnotation else { return }
      displayPriority = .defaultHigh
      image = UIGraphicsImageRenderer.image(for: cluster.memberAnnotations, in:
                                              CGRect(x: 0, y: 0, width: 40, height: 40))
    }
  }
}

extension UIGraphicsImageRenderer {
    static func image(for annotations: [MKAnnotation]?, in rect: CGRect) -> UIImage {
      let renderer = UIGraphicsImageRenderer(size: rect.size)
      let image = UIImage(named: R.image.mapCluster.name) ?? UIImage()

      return renderer.image { _ in
          image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
          if annotations != nil {
              String(annotations?.count ?? 0).drawForCluster(in: rect)
          }
      }
    }
}

extension String {
    func drawForCluster(in rect: CGRect) {
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                          NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]
        let textSize = self.size(withAttributes: attributes)
        let textRect = CGRect(x: (rect.width / 2) - (textSize.width / 2),
                              y: (rect.height / 2) - (textSize.height / 2),
                              width: textSize.width,
                              height: textSize.height)

        self.draw(in: textRect, withAttributes: attributes)
    }
}
