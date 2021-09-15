//
//  INavigationBarProgressView.swift
//  Chat
//
//  Created by User on 9/15/21.
//

import Foundation

public protocol INavigationBarProgressView: AnyObject {
  func didStartPending()
  func didStopPending()
}
