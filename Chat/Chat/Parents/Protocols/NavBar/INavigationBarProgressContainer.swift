//
//  INavigationBarProgressContainer.swift
//  Chat
//
//  Created by User on 9/15/21.
//

import Foundation
import UIKit

public protocol INavigationBarProgressContainer: AnyObject {
  var activityView: INavigationBarProgressView & UIView { get set }
  func startNavigationActivity()
  func stopNavigationActivity()
}

public extension INavigationBarProgressContainer {
  func startNavigationActivity() {
    self.activityView.didStartPending()
  }

  func stopNavigationActivity() {
    self.activityView.didStopPending()
  }
}
