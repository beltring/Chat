//
//  NavigationBarProgressViewConfigurator.swift
//  Chat
//
//  Created by User on 9/15/21.
//

import Foundation
import UIKit

public struct NavigationBarProgressViewConfigurator {
  public let activityStyle: UIActivityIndicatorView.Style
  public let frame: CGRect
  public let interItemSpace: CGFloat
  public let regularTitle: String
  public let pendingTitle: String
  public let titleColor: UIColor
  public let titleFont: UIFont

  public init(
    activityStyle: UIActivityIndicatorView.Style = .gray,
    frame: CGRect = .init(origin: .zero, size: .init(width: 120, height: 20)),
    interItemSpace: CGFloat,
    regularTitle: String,
    pendingTitle: String,
    titleColor: UIColor = .darkText,
    titleFont: UIFont
  ) {
    self.activityStyle = activityStyle
    self.frame = frame
    self.interItemSpace = interItemSpace
    self.regularTitle = regularTitle
    self.pendingTitle = pendingTitle
    self.titleColor = titleColor
    self.titleFont = titleFont
  }
}
