// swiftlint:disable:all
import UIKit
import SwiftUI

// MARK: - Asset Catalogs

typealias GHColor = Assets.Colors
typealias GHImage = Assets.Images
typealias GHIcons = Assets.Icons

enum Assets {
   enum Colors {
       static let background = CustomColor(name: "background")
       static let border = CustomColor(name: "border")
       static let foreground = CustomColor(name: "foreground")
       static let label = CustomColor(name: "label")
  }
   enum Icons {
       static let erase = CustomImage(name: "erase")
  }
   enum Images {
       static let ghLogo = CustomImage(name: "ghLogo")
  }
}

final class CustomColor {
  fileprivate(set) var name: String
  typealias AssetColor = UIColor
  var view: Color { Color(name) }

  private(set) lazy var color: AssetColor = {
   guard let color = AssetColor(asset: self) else {
    fatalError("Unable to load color asset named \(name).")
   }
    return color
   }()

  fileprivate init(name: String) {
    self.name = name
  }
}

extension CustomColor.AssetColor {
  convenience init?(asset: CustomColor) {
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
  }
}

struct CustomImage {
  typealias AssetImage = UIImage
  fileprivate(set) var name: String
  var view: Image { Image(uiImage: image) }

   var image: AssetImage {
    let bundle = BundleToken.bundle
    let image = AssetImage(named: name, in: bundle, compatibleWith: nil)
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
}

extension CustomImage.AssetImage {
  convenience init?(asset: CustomImage) {
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
  }
}

private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}

