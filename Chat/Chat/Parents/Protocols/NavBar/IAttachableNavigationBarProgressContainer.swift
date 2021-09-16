//
//  IAttachableNavigationBarProgressContainer.swift
//  Chat
//
//  Created by User on 9/15/21.
//

import Foundation
import UIKit

public protocol IAttachableNavigationBarProgressContainer: AnyObject {
  func attach(navigationActivityView: INavigationBarProgressView & UIView)
}
