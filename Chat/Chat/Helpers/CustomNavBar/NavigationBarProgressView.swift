//
//  NavigationBarProgressView.swift
//  Chat
//
//  Created by User on 9/15/21.
//

import UIKit

class NavigationBarProgressView: UIView {
    var activityIndicator: UIActivityIndicatorView = .init(style: .gray)
    
    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        return label
    } ()

    let config: NavigationBarProgressViewConfigurator
    private(set) var isPending: Bool = false
    
    public init(config: NavigationBarProgressViewConfigurator) {
        self.config = config
        self.activityIndicator = UIActivityIndicatorView(style: config.activityStyle)
        self.activityIndicator.hidesWhenStopped = true
        super.init(frame: config.frame)
        self.titleLabel.font = config.titleFont
        self.titleLabel.text = config.regularTitle
        self.addSubview(self.activityIndicator)
        self.addSubview(self.titleLabel)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.activityIndicator.frame.origin = .zero
        let maxWidth = self.isPending
          ? self.frame.width - self.activityIndicator.frame.size.width - self.config.interItemSpace
          : self.frame.width
        let maxTextSize = CGSize(
          width: maxWidth,
          height: self.activityIndicator.frame.height
        )
        let minTextSize = self.titleLabel.sizeThatFits(maxTextSize)
        let titleX = self.isPending
          ? self.activityIndicator.frame.maxX + self.config.interItemSpace
          : (maxWidth - minTextSize.width) / 2

        self.titleLabel.frame = CGRect(origin: .init(x: titleX,
                                                     y: (maxTextSize.height - minTextSize.height)/2),
                                       size: minTextSize)
      }
}

// MARK: - INavigationBarProgressView
extension NavigationBarProgressView: INavigationBarProgressView {
  public func didStartPending() {
    self.isPending = true
    self.setNeedsLayout()
    self.activityIndicator.isHidden = false
    self.activityIndicator.startAnimating()
    self.titleLabel.text = self.config.pendingTitle
  }

  public func didStopPending() {
    self.isPending = false
    self.setNeedsLayout()
    self.activityIndicator.isHidden = true
    self.titleLabel.text = self.config.regularTitle
  }
}
